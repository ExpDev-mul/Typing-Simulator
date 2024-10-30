-- // Services
local userInputService = game:GetService("UserInputService");
local replicatedStorage = game:GetService("ReplicatedStorage");
local tweenService = game:GetService("TweenService");
local runService = game:GetService("RunService");
local players = game:GetService("Players");
local debris = game:GetService("Debris");
local marketPlaceService = game:GetService("MarketplaceService");

-- // References
local camera = (workspace.CurrentCamera);
local box = script.Parent:WaitForChild("Box");
local correctSond = script:WaitForChild("CorrectSound");
local typeSound = script:WaitForChild("TypeSound");
local failSound = script:WaitForChild("FailSound");
local tickSound = script:WaitForChild("TickSound");
local musicEnabled = (players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Music"):WaitForChild("MusicEnabled"));
players.LocalPlayer:WaitForChild("leaderstats")
local typeSG = (script.Parent);

-- // Modules
local sentencesGenerator = require(script:WaitForChild("SentenceGenerator"));
local notificationsModule = require(players.LocalPlayer.PlayerGui:WaitForChild("Notifications"):WaitForChild("NotificationsModule"));

-- // Non-constants
local currentSentence = nil;
local currentGenerationTime = nil;
local lastTimeLeft = nil;
local lastClearTime = nil;

-- // Modes
local PRACTICE_MODE = false;
local CAMERA_SHAKE = true;

-- // Tables
local ranks = {
	{"Beginner", 0, 1},
	{"Average", 20, 1.5},
	{"Experiened", 50, 2},
	{"Intermediate", 100, 2.5},
	{"Advanced", 250, 3},
	{"Undefeated", 350, 3.5},
	{"Champion", 500, 4.5},
	{"Legendary", 750, 5},
	{"Immortal", 1250, 6},
};

-- // Constants
local TOKEN = ("kYvn08t9H3Yb2vOTWtON");

-- // Functions & Events
function UpdateSentence(toCaptureFocus)
	currentSentence = nil
	currentGenerationTime = nil
	box.Placeholder.Visible = true
	box.TypeBox.Text = ""
	if (toCaptureFocus) then
		box.TypeBox:CaptureFocus()
	end;
end;

function ConvertMS(n) -- // Convert seconds to M:S
	local minutes = (n / 60 % 60);
	local seconds = (n % 60);
	return string.format("%0.2i:%0.2i", minutes, seconds)
end;

function GetRank(value) -- // Get rank based on sentences.
	for index, validRank in next, ranks do
		if (value < validRank[2]) then
			return ranks[index - 1][1], ranks[index - 1][3]
		end;
	end;

	return ranks[#ranks][1], ranks[#ranks][3]
end;

function RenderStep(dt)
	if not (typeSG.Enabled) then return end;
	if not (currentSentence) then
		currentSentence = sentencesGenerator.Randomize()
		currentGenerationTime = tick()
		box.Left.Text = "<i>".. "0/".. string.len(currentSentence).. "</i>"
		box.Sentence.Text = ""
	else
		box.Sentence.Text = (currentSentence) and ("<i>".. string.sub(currentSentence, 1, string.len(box.Sentence.Text) + dt*2).. "</i>") or ("")
	end;
	
	if (userInputService:IsKeyDown(Enum.KeyCode.Tab)) then
		if not (lastClearTime) then
			lastClearTime = tick()
			box.TypeBox.Text = ""
			notificationsModule.new("Cleared Typing Box")
		elseif (tick() - lastClearTime > 1) then
			lastClearTime = tick()
			box.TypeBox.Text = ""
			notificationsModule.new("Cleared Typing Box")
		end;
	end;
	
	local rankName, rankTimeDiv = GetRank(players.LocalPlayer.leaderstats.Sentences.Value);
	box.SpeedUp.Text = string.format("Rank Time Speed Up: X%.1f (%s)", rankTimeDiv, rankName)
	if (tick() - currentGenerationTime) > (string.len(currentSentence) / rankTimeDiv)*(marketPlaceService:UserOwnsGamePassAsync(players.LocalPlayer.UserId, 91500953) and 2 or 1) then
		if not (PRACTICE_MODE) then
			if (musicEnabled.Value) then
				failSound:Play()
			end;
			
			UpdateSentence()
		else
			if (box.TypeBox.Text == currentSentence) then -- // If in practice mode and didn't finish within the timer's range.
				if not (correctSond.IsPlaying) then
					if (musicEnabled.Value) then
						correctSond:Play()
					end;
				end;
				
				UpdateSentence(true)
				return
			end;
		end;
	else
		if (box.TypeBox.Text == currentSentence) then -- // If typed the current sentence
			-- // Grant a prize here			
			if not (correctSond.IsPlaying) then
				if (musicEnabled.Value) then
					correctSond:Play()
				end;
			end;
			
			if not (PRACTICE_MODE) then
				replicatedStorage.GrantSentences:FireServer(1, TOKEN)
			end;
			
			UpdateSentence(true)
			return
		end;
		
		local timeLeft = (string.len(currentSentence) / rankTimeDiv)*(marketPlaceService:UserOwnsGamePassAsync(players.LocalPlayer.UserId, 91500953) and 2 or 1) - math.ceil((tick() - currentGenerationTime));
		local COLOR_INTERPOLATION_SPEED = (10);
		local ROTATION_FREQUENCY = (7);
		if (math.floor(timeLeft) <= 5) then
			if not (PRACTICE_MODE) then
				if (CAMERA_SHAKE) then
					local frequency = (30);
					camera.CFrame = camera.CFrame * CFrame.Angles(math.cos(tick() * frequency) * math.rad(0.2), math.sin(tick() * frequency) * math.rad(0.2), 0)
				end;
				
				if not (lastTimeLeft == timeLeft) and (timeLeft > 0) then
					lastTimeLeft = timeLeft
					
					if (musicEnabled.Value) then
						tickSound:Play()
					end;
				end;
			end;
			
			box.Timer.TextColor3 = box.Timer.TextColor3:Lerp(Color3.fromRGB(255, 0, 0), dt*COLOR_INTERPOLATION_SPEED)
			box.Timer.Rotation = math.cos((3 - (tick() - currentGenerationTime)) * ROTATION_FREQUENCY) * 3
		else
			box.Timer.TextColor3 = box.Timer.TextColor3:Lerp(Color3.fromRGB(0, 0, 0), dt*COLOR_INTERPOLATION_SPEED*1.5)
			box.Timer.Rotation = box.Timer.Rotation + (0 - box.Timer.Rotation) * dt*ROTATION_FREQUENCY*1.5
		end;
		
		box.Timer.Text = ConvertMS(timeLeft)
	end;
	
	if (string.len(box.TypeBox.Text) > 0) or (box.TypeBox:IsFocused()) then
		box.Placeholder.Visible = false
	else
		box.Placeholder.Visible = true
	end;
end;

runService.RenderStepped:Connect(RenderStep)

function TypeboxFocused()
	local uiStroke = Instance.new("UIStroke", box)
	uiStroke.Thickness = 0
	tweenService:Create(uiStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Thickness = 2}):Play()
	local focusedLostConnection
	focusedLostConnection = box.TypeBox.FocusLost:Connect(function()
		focusedLostConnection:Disconnect()
		tweenService:Create(uiStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Thickness = 0}):Play()
		debris:AddItem(uiStroke, 0.5)
	end)
end;

box.TypeBox.Focused:Connect(TypeboxFocused)

function TypeboxUpdated()
	if (musicEnabled.Value) then
		local typeSoundClone = typeSound:Clone()
		typeSoundClone.Parent = script
		typeSoundClone:Play()
		debris:AddItem(typeSoundClone, 2)
	end;
	
	box.DisplayBox.Text = box.TypeBox.Text
	local textGoal = ("");
	local correctLetters = (0);
	for i = 1, string.len(box.DisplayBox.Text) do
		local currentLetter = string.sub(box.DisplayBox.Text, i, i);
		local sentenceLetter = string.sub(currentSentence, i, i);
		if (currentLetter == sentenceLetter) then
			textGoal = textGoal..'<font color="rgb(0, 0, 0)">'..currentLetter..'</font>'
			correctLetters += 1
		else
			textGoal = textGoal.. string.sub(box.DisplayBox.Text, i, string.len(box.DisplayBox.Text))
			break
		end;
	end;
	
	if (currentSentence) then
		box.Left.Text = "<i>".. correctLetters.. "/".. string.len(currentSentence).. "</i>"
	end;
	
	box.DisplayBox.Text = textGoal
end;

box.TypeBox:GetPropertyChangedSignal("Text"):Connect(TypeboxUpdated)

function Skip()
	notificationsModule.new("Skipped Sentence")
	UpdateSentence(true)
end;

box.Parent.Skip.Button.MouseButton1Down:Connect(Skip)

function SkipEnter()	
	local uiStroke = Instance.new("UIStroke", box.Parent.Skip)
	uiStroke.Thickness = 0
	tweenService:Create(uiStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Thickness = 2}):Play()
	local mouseLeaveConnection
	mouseLeaveConnection = box.Parent.Skip.MouseLeave:Connect(function()
		mouseLeaveConnection:Disconnect()
		tweenService:Create(uiStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Thickness = 0}):Play()
		debris:AddItem(uiStroke, 0.15)
	end)
end;

box.Parent.Skip.MouseEnter:Connect(SkipEnter)

function InputBegan(input, isGpe)
	if (input.KeyCode == Enum.KeyCode.Return) then
		print(isGpe, box.TypeBox:IsFocused())
		if not (isGpe) then
			notificationsModule.new("Skipped Sentence")
			UpdateSentence(true)
		elseif (isGpe) and (box.TypeBox:IsFocused()) then
			notificationsModule.new("Skipped Sentence")
			UpdateSentence(true)
		end;
	end;
	
	if (input.KeyCode == Enum.KeyCode.F) then
		if (isGpe) then return end;
		task.wait(0.1)
		box.TypeBox:CaptureFocus()
	end;
end;

userInputService.InputBegan:Connect(InputBegan)

function PracticeMode()
	PRACTICE_MODE = not PRACTICE_MODE
	if (PRACTICE_MODE) then
		box.Parent.PracticeMode.DisplayBox.Text = "Practice Mode: ON"
		notificationsModule.new("Practice Mode On")
		tweenService:Create(box.Parent.PracticeMode, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(85, 170, 0)}):Play()
		box.Timer.Visible = false
		box.SpeedUp.Visible = false
		tweenService:Create(box.PracticeMode, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
		tweenService:Create(box.TypeBox, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.fromScale(1/2, 1/2)}):Play()
		tweenService:Create(box.DisplayBox, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.fromScale(1/2, 1/2)}):Play()
		tweenService:Create(box.Placeholder, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.fromScale(1/2, 1/2)}):Play()
	else
		box.Parent.PracticeMode.DisplayBox.Text = "Practice Mode: OFF"
		notificationsModule.new("Practice Mode Off")
		tweenService:Create(box.Parent.PracticeMode, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(255, 0, 0)}):Play()
		box.Timer.Visible = true
		box.SpeedUp.Visible = true
		tweenService:Create(box.PracticeMode, TweenInfo.new(0), {TextTransparency = 1}):Play()
		tweenService:Create(box.TypeBox, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.fromScale(1/2, 0.4)}):Play()
		tweenService:Create(box.DisplayBox, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.fromScale(1/2, 0.4)}):Play()
		tweenService:Create(box.Placeholder, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.fromScale(1/2, 0.4)}):Play()
		UpdateSentence()
	end;
end;

box.Parent.PracticeMode.Button.MouseButton1Down:Connect(PracticeMode)

function PracticeModeEnter()	
	local uiStroke = Instance.new("UIStroke", box.Parent.PracticeMode)
	uiStroke.Thickness = 0
	tweenService:Create(uiStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Thickness = 2}):Play()
	local mouseLeaveConnection
	mouseLeaveConnection = box.Parent.PracticeMode.MouseLeave:Connect(function()
		mouseLeaveConnection:Disconnect()
		tweenService:Create(uiStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Thickness = 0}):Play()
		debris:AddItem(uiStroke, 0.15)
	end)
end;

box.Parent.PracticeMode.MouseEnter:Connect(PracticeModeEnter)

function CameraShake()
	CAMERA_SHAKE = not CAMERA_SHAKE
	if (CAMERA_SHAKE) then
		box.Parent.CameraShake.DisplayBox.Text = "Camera Shake: ON"
		notificationsModule.new("Camera Shake On")
		tweenService:Create(box.Parent.CameraShake, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(85, 170, 0)}):Play()
	else
		box.Parent.CameraShake.DisplayBox.Text = "Camera Shake: OFF"
		notificationsModule.new("Camera Shake Off")
		tweenService:Create(box.Parent.CameraShake, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(255, 0, 0)}):Play()
	end;
end;

box.Parent.CameraShake.Button.MouseButton1Down:Connect(CameraShake)

function CameraShakeEnter()	
	local uiStroke = Instance.new("UIStroke", box.Parent.CameraShake)
	uiStroke.Thickness = 0
	tweenService:Create(uiStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Thickness = 2}):Play()
	local mouseLeaveConnection
	mouseLeaveConnection = box.Parent.CameraShake.MouseLeave:Connect(function()
		mouseLeaveConnection:Disconnect()
		tweenService:Create(uiStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Thickness = 0}):Play()
		debris:AddItem(uiStroke, 0.15)
	end)
end;

box.Parent.CameraShake.MouseEnter:Connect(CameraShakeEnter)

function Clear()
	if not (lastClearTime) then
		lastClearTime = tick()
		box.TypeBox.Text = ""
		notificationsModule.new("Cleared Typing Box")
	elseif (tick() - lastClearTime > 1) then
		lastClearTime = tick()
		box.TypeBox.Text = ""
		notificationsModule.new("Cleared Typing Box")
	end;
end;

box.Parent.Clear.Button.MouseButton1Down:Connect(Clear)

function ClearEnter()	
	local uiStroke = Instance.new("UIStroke", box.Parent.Clear)
	uiStroke.Thickness = 0
	tweenService:Create(uiStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Thickness = 2}):Play()
	local mouseLeaveConnection
	mouseLeaveConnection = box.Parent.Clear.MouseLeave:Connect(function()
		mouseLeaveConnection:Disconnect()
		tweenService:Create(uiStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Thickness = 0}):Play()
		debris:AddItem(uiStroke, 0.15)
	end)
end;

box.Parent.Clear.MouseEnter:Connect(ClearEnter)