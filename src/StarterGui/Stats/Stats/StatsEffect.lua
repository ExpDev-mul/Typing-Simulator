-- // RunService
local tweenService = game:GetService("TweenService");
local runService = game:GetService("RunService");

-- // References
local statsScreenGui = (script.Parent.Parent);
local stat = script:WaitForChild("Stat");

local statsEffect = {}
statsEffect.__index = statsEffect

function statsEffect.new(text, color)
	local self = {};
	self.StatText = stat:Clone()
	self.StatText.Text = "<i>".. text.. "</i>"	
	self.StatText.TextColor3 = color or self.StatText.TextColor3
	self.BasePosition = UDim2.fromScale(1/2 + math.random(1, 3)/10 * math.random(-1, 1), 1/2 + math.random(1, 3)/10 * -math.random(0, 1)) 
	tweenService:Create(self.StatText, TweenInfo.new(0.15, Enum.EasingStyle.Cubic), {
		TextTransparency = 0;
	}):Play()
	
	local rsConnection = runService.RenderStepped:Connect(function()
		self:Effect()
	end)
	
	task.delay(3, function()
		tweenService:Create(self.StatText, TweenInfo.new(0.6, Enum.EasingStyle.Cubic), {
			TextTransparency = 1;
		}):Play()
		
		task.wait(1)
		rsConnection:Disconnect()
		self.StatText:Destroy()
	end)
	
	return setmetatable(self, statsEffect)
end;

function statsEffect:Effect()
	self.StatText.Parent = statsScreenGui
	self.StatText.Position = self.BasePosition + UDim2.fromScale(math.cos(tick() * 5) * 0.02, math.sin(tick() * 5) * 0.02)
	self.StatText.Rotation = math.cos(tick() * 5) * 3
end;

return statsEffect
