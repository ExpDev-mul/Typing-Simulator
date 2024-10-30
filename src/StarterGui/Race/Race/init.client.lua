-- // Services
local players = game:GetService("Players");
local tweenService = game:GetService("TweenService");
local socialService = game:GetService("SocialService");
local replicatedStorage = game:GetService("ReplicatedStorage");
local debris = game:GetService("Debris");

-- // References
local raceFrame = script.Parent:WaitForChild("RaceFrame");
local raceRequestFrame = script.Parent:WaitForChild("RaceRequest");
local raceContent = script.Parent:WaitForChild("RaceContent");

local musicEnabled = (players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Music"):WaitForChild("MusicEnabled"));

local raceRequest = replicatedStorage:WaitForChild("RaceRequest");
local raceAccept = replicatedStorage:WaitForChild("RaceAccept");
local raceFinish = replicatedStorage:WaitForChild("RaceFinish");

local typeSound = script:WaitForChild("TypeSound");


-- // Modules
local notificationsModule = require(players.LocalPlayer.PlayerGui:WaitForChild("Notifications"):WaitForChild("NotificationsModule"));
local sentencesGenerator = require(script:WaitForChild("SentenceGenerator"));

-- // Functions & Events
function RaceEnter()
	local uiStroke = Instance.new("UIStroke", raceFrame)
	uiStroke.Thickness = 0
	tweenService:Create(uiStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Thickness = 2}):Play()
	local mouseLeaveConnection
	mouseLeaveConnection = raceFrame.Button.MouseLeave:Connect(function()
		mouseLeaveConnection:Disconnect()
		tweenService:Create(uiStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Thickness = 0}):Play()
		debris:AddItem(uiStroke, 0.15)
	end)
end;

raceFrame.Button.MouseEnter:Connect(RaceEnter)

-- // Additional references
local raceMain = script.Parent:WaitForChild("RaceMain");
local playerTemplate = script:WaitForChild("PlayerTemplate");

local open = (false);
function RaceButtonDown()
	open = not open
	if (open) then
		tweenService:Create(raceMain, TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.5, 0.421)
		}):Play()
	else
		tweenService:Create(raceMain, TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.5, -0.5)
		}):Play()
	end;
end;

raceFrame.Button.MouseButton1Down:Connect(RaceButtonDown)

local playerFrames = {}
function UpdatePlayers()
	for _, somePlayer in next, players:GetChildren() do
		if (somePlayer == players.LocalPlayer) then continue end;
		if not (raceMain.Canvas:FindFirstChild(somePlayer.Name)) then
			local newTemplate = playerTemplate:Clone();
			newTemplate.Username.Text = (somePlayer.DisplayName == "") and (somePlayer.Name) or (somePlayer.DisplayName)
			newTemplate.Name = somePlayer.UserId
			table.insert(playerFrames, newTemplate)
			local function OnEnter()
				tweenService:Create(newTemplate, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(235, 235, 235)}):Play()
				tweenService:Create(newTemplate.EnterText, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
			end;
			
			newTemplate.Button.MouseEnter:Connect(OnEnter)
			
			local function OnLeave()
				tweenService:Create(newTemplate, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
				tweenService:Create(newTemplate.EnterText, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
			end;
			
			newTemplate.Button.MouseLeave:Connect(OnLeave)
			
			local function OnButtonDown()
				tweenService:Create(newTemplate, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(205, 205, 205)}):Play()
			end;
			
			newTemplate.Button.MouseButton1Down:Connect(OnButtonDown)
			
			local requestLast = (0);
			local function OnClick()
				if (tick() - requestLast) < 2 then 
					notificationsModule.new("Too many requests.")
					return 
				end;
				
				requestLast = tick()
				notificationsModule.new(string.format("Sent rqeuest to %s.", newTemplate.Username.Text))
				tweenService:Create(newTemplate, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(235, 235, 235)}):Play()
				if not (somePlayer:FindFirstChild("InRace")) then
					raceRequest:FireServer(somePlayer.Name)
				end;
			end;
			
			newTemplate.Button.MouseButton1Click:Connect(OnClick)
			newTemplate.Parent = raceMain.Canvas
		end;
	end;
	
	for _, playerFrame in next, playerFrames do
		local found = false
		for _, player in next, players:GetChildren() do
			if player.UserId == playerFrame.Name then
				found = true
				break
			end;
		end;
		
		if not found then
			playerFrame:Destroy()
		end;
	end;
end;

players.PlayerAdded:Connect(UpdatePlayers)
players.PlayerRemoving:Connect(UpdatePlayers)
UpdatePlayers()

function RaceRequestAccept()
	tweenService:Create(raceRequestFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.fromScale(0.5, -0.1)}):Play()
	if (players:FindFirstChild(raceRequestFrame.Requester.Value)) then
		local randomizedSentence = sentencesGenerator.Randomize();
		raceAccept:FireServer(raceRequestFrame.Requester.Value, randomizedSentence)
		raceContent.OtherPlayer.Value = raceRequestFrame.Requester.Value
		raceContent.DisplayedSentence.Value = randomizedSentence
		raceContent.Sentence.Text = string.format("<i>%s</i>", randomizedSentence)
		raceMain.Visible = false
		raceFrame.Visible = false
		players.LocalPlayer.PlayerGui.Stats.Enabled = false
		players.LocalPlayer.PlayerGui.Type.Enabled = false
		players.LocalPlayer.PlayerGui.Music.Enabled = false
		raceContent.Visible = true
		raceContent.TypeBox:CaptureFocus()
		local connections = {};
		local function Finish()
			raceMain.Visible = true
			raceFrame.Visible = true
			players.LocalPlayer.PlayerGui.Stats.Enabled = true
			players.LocalPlayer.PlayerGui.Type.Enabled = true
			players.LocalPlayer.PlayerGui.Music.Enabled = true
			raceContent.Visible = false
			raceContent.TypeBox:ReleaseFocus()
			raceContent.TypeBox.Text = ""
			for _, someConnection in next, connections do
				someConnection:Disconnect()
			end;
		end;

		table.insert(connections, raceFinish.OnClientEvent:Connect(Finish))

		local function TextUpdated()
			if (musicEnabled.Value) then
				local typeSoundClone = typeSound:Clone()
				typeSoundClone.Parent = script
				typeSoundClone:Play()
				debris:AddItem(typeSoundClone, 2)
			end;
			
			if (string.len(raceContent.TypeBox.Text) == 0) then
				raceContent.Placeholder.Visible = true
			else
				raceContent.Placeholder.Visible = false
			end;

			if (raceContent.TypeBox.Text == raceContent.DisplayedSentence.Value) then
				raceFinish:FireServer(raceContent.OtherPlayer.Value)
				Finish()
			end;
		end;

		table.insert(connections, raceContent.TypeBox:GetPropertyChangedSignal("Text"):Connect(TextUpdated))
		
		local function FocusLost()
			raceContent.TypeBox:CaptureFocus()
		end;
		
		table.insert(connections, raceContent.TypeBox.FocusLost:Connect(FocusLost))
	else
		notificationsModule.new("Requester has already left the game.")
	end;
end;

raceRequestFrame.Accept.MouseButton1Down:Connect(RaceRequestAccept)

function RaceRequestReject()
	tweenService:Create(raceRequestFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(0.5, -0.1)
	}):Play()
end;

raceRequestFrame.Reject.MouseButton1Down:Connect(RaceRequestReject)

function RaceRequestClientEvent(by)
	by = players:FindFirstChild(by)
	if (by) then
		if not (by:FindFirstChild("InRace")) then
			raceRequestFrame.Requester.Value = by.Name
			raceRequestFrame.Username.Text = string.format("<i>%s</i>", (by.DisplayName == "") and (by.Name) or (by.DisplayName))
			tweenService:Create(raceRequestFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Position = UDim2.fromScale(0.5, 0.1)
			}):Play()
		end;
	end;
end;

raceRequest.OnClientEvent:Connect(RaceRequestClientEvent)

function RaceAcceptClientEvent(otherPlayer, randomizedSentence)
	tweenService:Create(raceRequestFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.fromScale(0.5, -0.1)}):Play()
	raceAccept:FireServer(raceRequestFrame.Requester.Value, randomizedSentence)
	raceContent.OtherPlayer.Value = otherPlayer
	raceContent.DisplayedSentence.Value = randomizedSentence
	raceContent.Sentence.Text = string.format("<i>%s</i>", randomizedSentence)
	raceMain.Visible = false
	raceFrame.Visible = false
	players.LocalPlayer.PlayerGui.Stats.Enabled = false
	players.LocalPlayer.PlayerGui.Type.Enabled = false
	players.LocalPlayer.PlayerGui.Music.Enabled = false
	raceContent.Visible = true
	raceContent.TypeBox:CaptureFocus()
	local connections = {};
	local function Finish()
		raceMain.Visible = true
		raceFrame.Visible = true
		players.LocalPlayer.PlayerGui.Stats.Enabled = true
		players.LocalPlayer.PlayerGui.Type.Enabled = true
		players.LocalPlayer.PlayerGui.Music.Enabled = true
		raceContent.Visible = false
		raceContent.TypeBox:ReleaseFocus()
		raceContent.TypeBox.Text = ""
		for _, someConnection in next, connections do
			someConnection:Disconnect()
		end;
	end;

	table.insert(connections, raceFinish.OnClientEvent:Connect(Finish))
	
	local function TextUpdated()
		if (musicEnabled.Value) then
			local typeSoundClone = typeSound:Clone()
			typeSoundClone.Parent = script
			typeSoundClone:Play()
			debris:AddItem(typeSoundClone, 2)
		end;
		
		if (string.len(raceContent.TypeBox.Text) == 0) then
			raceContent.Placeholder.Visible = true
		else
			raceContent.Placeholder.Visible = false
		end;

		if (raceContent.TypeBox.Text == raceContent.DisplayedSentence.Value) then
			raceFinish:FireServer(raceContent.OtherPlayer.Value)
			Finish()
		end;
	end;

	table.insert(connections, raceContent.TypeBox:GetPropertyChangedSignal("Text"):Connect(TextUpdated))
	
	local function FocusLost()
		raceContent.TypeBox:CaptureFocus()
	end;

	table.insert(connections, raceContent.TypeBox.FocusLost:Connect(FocusLost))
end;

raceAccept.OnClientEvent:Connect(RaceAcceptClientEvent)