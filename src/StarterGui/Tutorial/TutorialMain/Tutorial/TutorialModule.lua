-- // Services
local userInputService = game:GetService("UserInputService");
local tweenService = game:GetService("TweenService");
local debris = game:GetService("Debris");

local tutorial = {}
tutorial.__index = tutorial

function tutorial.new(tutorialText)
	return setmetatable({
		TutorialText = tutorialText;
		InScene = false;
		Current = 1;
	}, tutorial)
end;

function tutorial:GetEvents()
	return {
		[1] = function()
			self.Blur = Instance.new("BlurEffect");
			self.Blur.Size = 0
			self.Blur.Parent = workspace.CurrentCamera
			tweenService:Create(self.Blur, TweenInfo.new(0.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Size = 25
			}):Play()
			
			self.InScene = true
			self.TutorialText.Text = ""
			local textGoal = "Welcome to the tutorial! (Click to Continue)"
			local currentLetter = (1);
			repeat task.wait(1/string.len(textGoal)/2)
				currentLetter += 1
				self.TutorialText.Text = string.sub(textGoal, 1, currentLetter)
				self.TutorialText.Parent.LayerText.Text = string.sub(textGoal, 1, currentLetter)
			until not (self.Current == 1) or (currentLetter == string.len(textGoal)) or not (self.InScene)
			self.InScene = false
			self.TutorialText.Text = textGoal
			self.TutorialText.Parent.LayerText.Text = textGoal
		end,

		[2] = function()
			self.InScene = true
			self.TutorialText.Text = ""
			local textGoal = "In the bottom middle, you have this box where you can write sentences. (Click to Continue)"
			local currentLetter = (1);
			repeat task.wait(1/string.len(textGoal)/2)
				currentLetter += 1
				self.TutorialText.Text = string.sub(textGoal, 1, currentLetter)
				self.TutorialText.Parent.LayerText.Text = string.sub(textGoal, 1, currentLetter)
			until not (self.Current == 2) or (currentLetter == string.len(textGoal)) or not (self.InScene)
			self.InScene = false
			self.TutorialText.Text = textGoal
			self.TutorialText.Parent.LayerText.Text = textGoal
		end,
		
		[3] = function()
			self.InScene = true
			self.TutorialText.Text = ""
			local textGoal = "You have to type the sentence requested there with full grammar, before the timer expires, otherwise the sentence will be changed. (Click to Continue)"
			local currentLetter = (1);
			repeat task.wait(1/string.len(textGoal)/2)
				currentLetter += 1
				self.TutorialText.Text = string.sub(textGoal, 1, currentLetter)
				self.TutorialText.Parent.LayerText.Text = string.sub(textGoal, 1, currentLetter)
			until not (self.Current == 3) or (currentLetter == string.len(textGoal)) or not (self.InScene)
			self.InScene = false
			self.TutorialText.Text = textGoal
			self.TutorialText.Parent.LayerText.Text = textGoal
		end,
		
		[4] = function()
			self.InScene = true
			self.TutorialText.Text = ""
			local textGoal = "You earn sentences per completion of 1 sentence, which will eventually rank you up! (Click to Continue)"
			local currentLetter = (1);
			repeat task.wait(1/string.len(textGoal)/2)
				currentLetter += 1
				self.TutorialText.Text = string.sub(textGoal, 1, currentLetter)
				self.TutorialText.Parent.LayerText.Text = string.sub(textGoal, 1, currentLetter)
			until not (self.Current == 4) or (currentLetter == string.len(textGoal)) or not (self.InScene)
			self.InScene = false
			self.TutorialText.Text = textGoal
			self.TutorialText.Parent.LayerText.Text = textGoal
		end,
		
		[5] = function()
			self.InScene = true
			self.TutorialText.Text = ""
			local textGoal = "The higher your rank is, the less time you will have to complete a sentence. (Click to Continue)"
			local currentLetter = (1);
			repeat task.wait(1/string.len(textGoal)/2)
				currentLetter += 1
				self.TutorialText.Text = string.sub(textGoal, 1, currentLetter)
				self.TutorialText.Parent.LayerText.Text = string.sub(textGoal, 1, currentLetter)
			until not (self.Current == 5) or (currentLetter == string.len(textGoal)) or not (self.InScene)
			self.InScene = false
			self.TutorialText.Text = textGoal
			self.TutorialText.Parent.LayerText.Text = textGoal
		end,
		
		[6] = function()
			self.InScene = true
			self.TutorialText.Text = ""
			local textGoal = "You can also type race against other players, in the left arrow icon right to the music button, and earn 5 sentences per win. (Click to Continue)"
			local currentLetter = (1);
			repeat task.wait(1/string.len(textGoal)/2)
				currentLetter += 1
				self.TutorialText.Text = string.sub(textGoal, 1, currentLetter)
				self.TutorialText.Parent.LayerText.Text = string.sub(textGoal, 1, currentLetter)
			until not (self.Current == 6) or (currentLetter == string.len(textGoal)) or not (self.InScene)
			self.InScene = false
			self.TutorialText.Text = textGoal
			self.TutorialText.Parent.LayerText.Text = textGoal
		end,
		
		[7] = function()
			self.InScene = true
			self.TutorialText.Text = ""
			local textGoal = "Well.. that was it. Good luck! (Click to Continue)"
			local currentLetter = (1);
			repeat task.wait(1/string.len(textGoal)/2)
				currentLetter += 1
				self.TutorialText.Text = string.sub(textGoal, 1, currentLetter)
				self.TutorialText.Parent.LayerText.Text = string.sub(textGoal, 1, currentLetter)
			until not (self.Current == 7) or (currentLetter == string.len(textGoal)) or not (self.InScene)
			self.InScene = false
			self.TutorialText.Text = textGoal
			self.TutorialText.Parent.LayerText.Text = textGoal
		end,
		
		[8] = function()
			tweenService:Create(self.TutorialText, TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
			tweenService:Create(self.TutorialText.Parent.LayerText, TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
			tweenService:Create(self.Blur, TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Size = 0
			}):Play()
			
			debris:AddItem(self.Blur, 1)
			task.wait(1)
			self.TutorialText.Parent:Destroy()
		end,
	}
end;

function tutorial:ApplyModifications()
	local events = self:GetEvents();
	events[1]()
	local connections = {};
	local function InputBegan(input, isGpe)
		if not (isGpe) and (input.UserInputType == Enum.UserInputType.MouseButton1) then
			if (self.InScene) then
				self.InScene = false
			else
				self.Current += 1
				events[self.Current]()
				if (self.Current >= #events) then
					for _, someConnection in next, connections do
						someConnection:Disconnect()
					end;
				end;
			end;
		end;
	end;
	
	table.insert(connections, userInputService.InputBegan:Connect(InputBegan))
end;

return tutorial