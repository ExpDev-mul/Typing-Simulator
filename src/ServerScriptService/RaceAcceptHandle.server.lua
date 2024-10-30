-- // Services
local players = game:GetService("Players");
local replicatedStorage = game:GetService("ReplicatedStorage");

-- // References
local raceAccept = replicatedStorage:WaitForChild("RaceAccept");
function AddInRaceValue(player)
	local inRace = Instance.new("BoolValue", player);
	inRace.Name = "InRace"
end;

function RaceAccept(player, requestedPlayer, randomizedSentence)
	requestedPlayer = players:FindFirstChild(requestedPlayer);
	if (requestedPlayer) then
		if not (requestedPlayer:FindFirstChild("InRace")) then
			AddInRaceValue(player)
			AddInRaceValue(requestedPlayer)
			raceAccept:FireClient(requestedPlayer, player.Name, randomizedSentence)
		end;
	end;
end;

raceAccept.OnServerEvent:Connect(RaceAccept)