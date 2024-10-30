-- // Services
local players = game:GetService("Players");
local tweenService = game:GetService("TweenService");
local debris = game:GetService("Debris");

-- // References
local musicFrame = script.Parent:WaitForChild("MusicFrame");
local musicEnabled = script.Parent:WaitForChild("MusicEnabled");

-- // Modules
local notificationsModule = require(players.LocalPlayer.PlayerGui:WaitForChild("Notifications"):WaitForChild("NotificationsModule"));

-- // Functions & Events
function MusicEnter()
	local uiStroke = Instance.new("UIStroke", musicFrame)
	uiStroke.Thickness = 0
	tweenService:Create(uiStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Thickness = 2}):Play()
	local mouseLeaveConnection
	mouseLeaveConnection = musicFrame.Button.MouseLeave:Connect(function()
		mouseLeaveConnection:Disconnect()
		tweenService:Create(uiStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Thickness = 0}):Play()
		debris:AddItem(uiStroke, 0.15)
	end)
end;

musicFrame.Button.MouseEnter:Connect(MusicEnter)

function MusicButtonDown()
	musicEnabled.Value = not musicEnabled.Value
	if (musicEnabled.Value) then
		game:GetService("SoundService").Background:Resume()
		tweenService:Create(musicFrame.OnIcon, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
		tweenService:Create(musicFrame.OffIcon, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
		notificationsModule.new("Sounds are On")
	else
		game:GetService("SoundService").Background:Pause()
		tweenService:Create(musicFrame.OnIcon, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
		tweenService:Create(musicFrame.OffIcon, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
		notificationsModule.new("Sounds are Off")
	end;
end;

musicFrame.Button.MouseButton1Down:Connect(MusicButtonDown)