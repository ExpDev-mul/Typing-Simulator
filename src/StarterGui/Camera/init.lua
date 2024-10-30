-- // Services
local userInputService = game:GetService("UserInputService");
local runService = game:GetService("RunService");
local players = game:GetService("Players");

-- // References
local cameraInstance = (workspace.CurrentCamera);
local localCharacter = (players.LocalPlayer.Character or players.LocalPlayer.CharacterAdded:Wait());

-- // Constants
local MIN_ZOOM_DISTANCE = (4);
local MAX_ZOOM_DISTANCE = (24);
local DEFAULT_ZOOM = (16);
local LERP_SPEED = (10);

local camera = {}
camera.__index = camera
function camera.new()
	return setmetatable({
		Focus = localCharacter:WaitForChild("HumanoidRootPart");
		ZOOM = DEFAULT_ZOOM;
		ZOOM_G = DEFAULT_ZOOM;
		X = (0);
		Y = (0);
		X_G = (0);
		Y_G = (0);
		Connections = {};
	}, camera)
end;

function camera:ApplyModifications()
	local function InputChanged(input)
		if (input.UserInputType == Enum.UserInputType.MouseWheel) then
			self.ZOOM_G = math.clamp(self.ZOOM_G - input.Position.Z*4, MIN_ZOOM_DISTANCE, MAX_ZOOM_DISTANCE)
		end;
	end;
	
	local INPUT_CHANGED = userInputService.InputChanged:Connect(InputChanged)
	table.insert(self.Connections, INPUT_CHANGED)
	
	local function RenderStep(dt)
		self:Update(dt)
	end;
	
	runService:UnbindFromRenderStep("CameraUpdate")
	runService:BindToRenderStep("CameraUpdate", Enum.RenderPriority.Camera.Value, RenderStep)
end;

function camera:GetMinZoomDistance(cframe)
	local origin = (self.Focus.Position);
	local direction = ((cframe * CFrame.new(0, 0, self.ZOOM)).Position - self.Focus.Position).Unit * (self.ZOOM + 1)
	local rayCastParams = RaycastParams.new();
	rayCastParams.FilterDescendantsInstances = {localCharacter, workspace.CameraFiltered}
	local rayCast = workspace:Raycast(
		origin,
		direction,
		rayCastParams
	);
	
	if (rayCast) then
		local magnitude = (rayCast.Position - self.Focus.Position).Magnitude;
		return (magnitude - 1);
	else
		return (self.ZOOM);
	end;
end;

function camera:Update(dt)
	if (userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)) then
		userInputService.MouseBehavior = (userInputService.MouseBehavior == Enum.MouseBehavior.Default) and Enum.MouseBehavior.LockCurrentPosition or userInputService.MouseBehavior
	else
		userInputService.MouseBehavior = (userInputService.MouseBehavior == Enum.MouseBehavior.LockCurrentPosition) and Enum.MouseBehavior.Default or userInputService.MouseBehavior
	end;
	
	local cameraCFrame = CFrame.new(self.Focus.CFrame.Position)*CFrame.Angles(0, self.Y/180*math.pi, 0)*CFrame.Angles(self.X/180*math.pi, 0, 0);
	local minZoomDistance = self:GetMinZoomDistance(cameraCFrame)
	cameraInstance.CameraType = Enum.CameraType.Scriptable
	cameraInstance.CFrame = cameraCFrame * CFrame.new(0, 0, math.min(minZoomDistance, self.ZOOM))
	local mouseDelta = userInputService:GetMouseDelta();
	self.X_G = math.clamp(self.X_G - mouseDelta.Y, -89, 89)
	self.Y_G = self.Y_G - mouseDelta.X
	self.X = self.X + (self.X_G - self.X) * dt*LERP_SPEED
	self.Y = self.Y + (self.Y_G - self.Y) * dt*LERP_SPEED
	self.ZOOM = self.ZOOM + (self.ZOOM_G - self.ZOOM) * dt*LERP_SPEED
end;

return camera