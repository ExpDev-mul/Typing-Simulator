-- // Services
local replicatedStorage = game:GetService("ReplicatedStorage");
local tweenService = game:GetService("TweenService");
local players = game:GetService("Players");

-- // References
local indexTemplate = script:WaitForChild("IndexTemplate");
local canvas = script.Parent:WaitForChild("Canvas");

local localPlayer = (players.LocalPlayer);
local leaderstats = (localPlayer:WaitForChild("leaderstats"));

-- // Modules
local ranks = require(replicatedStorage:WaitForChild("Ranks"));

-- // Functions & Events
function AddIndex()
	for i = 1, #ranks do
		local someRank = (ranks[i]);
		local itClone = indexTemplate:Clone();
		itClone.RankName.Text = someRank[1]
		itClone.RankName.TextColor3 = someRank[3]
		if (i == #ranks) then
			itClone.Range.Text = string.format("> %i", someRank[2])
		else
			itClone.Range.Text = string.format("%i-%i", someRank[2], ranks[i+1][2]-1)
		end;
		
		itClone.Min.Value = someRank[2]
		itClone.Parent = canvas
	end;
end;

AddIndex()

function SentenceChanged()
	for _, rankFrame in next, canvas:GetChildren() do
		if (rankFrame:IsA("Frame")) then
			if (players.LocalPlayer.leaderstats.Sentences.Value < rankFrame.Min.Value) then
				rankFrame.BackgroundTransparency = 0.25
			else
				rankFrame.BackgroundTransparency = 0
			end;
		end;
	end;
end;

leaderstats:WaitForChild("Sentences"):GetPropertyChangedSignal("Value"):Connect(SentenceChanged)
SentenceChanged()