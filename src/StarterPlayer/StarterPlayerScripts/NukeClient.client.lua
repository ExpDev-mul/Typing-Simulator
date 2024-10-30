-->> Services
local replicatedStorage = game:GetService("ReplicatedStorage");
local tweenService = game:GetService("TweenService");
local runService = game:GetService("RunService");

local playerGui = game:GetService("Players").LocalPlayer.PlayerGui;

-->> References
local isNuked = replicatedStorage:WaitForChild("IsNuked");
local camera = workspace.CurrentCamera;

local nukeSound = game:GetService("SoundService"):WaitForChild("NukeSound");
local nukeHit = game.SoundService:WaitForChild("NukeHit");
local background = game:GetService("SoundService"):WaitForChild("Background");

-->> Functions & Events
function IsNukedChanged()
	if isNuked.Value then
		local disabled = {}
		for _, screenGui in next, playerGui:GetChildren() do
			if screenGui:IsA("ScreenGui") then
				screenGui.Enabled = false
				table.insert(disabled, screenGui)
			end;
		end;
		
		local wasBackgroundPlaying = background.IsPlaying
		if wasBackgroundPlaying then
			background:Pause()
		end;
		
		local colorCorrection = Instance.new("ColorCorrectionEffect");
		colorCorrection.TintColor = Color3.fromRGB(255, 255, 255)
		colorCorrection.Parent = game:GetService("Lighting")
		tweenService:Create(colorCorrection, TweenInfo.new(1, Enum.EasingStyle.Linear), {
				TintColor = Color3.fromRGB(255, 85, 0)
			}			
		):Play()
		
		task.delay(1, function()
			tweenService:Create(colorCorrection, TweenInfo.new(10, Enum.EasingStyle.Linear), {
					TintColor = Color3.fromRGB(255, 43, 1)
				}			
			):Play()
		end)
		
		nukeSound.Volume = 0
		tweenService:Create(nukeSound, TweenInfo.new(3, Enum.EasingStyle.Sine), {Volume = 0.6}):Play()
		nukeSound:Play()
		
		local amplitude = 0
		
		local start = tick()
		repeat
			local dt = runService.RenderStepped:Wait()
			amplitude = amplitude + (1 - amplitude) * math.min(dt*0.2, 1)
			camera.CFrame = camera.CFrame * CFrame.Angles(math.cos(tick() * 30) * math.rad(amplitude), math.sin(tick() * 30) * math.rad(amplitude), 0)
		until tick() - start > 15
		tweenService:Create(nukeSound, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Volume = 0}):Play()
		tweenService:Create(colorCorrection, TweenInfo.new(2, Enum.EasingStyle.Quint), {Brightness = 2, TintColor = Color3.fromRGB(255, 255, 255)}):Play()
		tweenService:Create(nukeHit, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Volume = 0.5}):Play()
		nukeHit:Play()
		task.wait(5)
		tweenService:Create(nukeHit, TweenInfo.new(1, Enum.EasingStyle.Linear), {Volume = 0}):Play()
		task.wait(4)
		tweenService:Create(colorCorrection, TweenInfo.new(3, Enum.EasingStyle.Linear), {
			Brightness = 0
		}			
		):Play()
		task.wait(3)
		colorCorrection:Destroy()
		for _, screenGui in next, disabled do
			screenGui.Enabled = true
		end;
		
		if wasBackgroundPlaying then
			background:Resume()
		end;
	end;
end;

isNuked:GetPropertyChangedSignal("Value"):Connect(IsNukedChanged)
IsNukedChanged()