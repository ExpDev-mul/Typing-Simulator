-- // Services
local tweenService = game:GetService("TweenService");

-- // References
local tutorialMain = (script.Parent);

-- // Modules
local tutorialModule = require(script:WaitForChild("TutorialModule"));

-- // Functions & Events
local connections = {};

function TweenOff()
	tweenService:Create(tutorialMain, TweenInfo.new(0.35, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(0.5, -0.2)
	}):Play()
	
	for _, someConnection in next, connections do
		someConnection:Disconnect()
	end;
end;

table.insert(connections, tutorialMain.No.MouseButton1Down:Connect(TweenOff))

function Yes()
	TweenOff()
	tutorialModule.new(tutorialMain.Parent.TutorialText):ApplyModifications()
end;

table.insert(connections, tutorialMain.Yes.MouseButton1Down:Connect(Yes))