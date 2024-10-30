-- // Services
local players = game:GetService("Players");
local replicatedStorage = game:GetService("ReplicatedStorage");

-- // References
local raceRequest = replicatedStorage:WaitForChild("RaceRequest");
function RaceRequest(player, requestedPlayer)
	requestedPlayer = players:FindFirstChild(requestedPlayer);
	if (requestedPlayer) then
		if not (requestedPlayer:FindFirstChild("InRace")) then
			raceRequest:FireClient(requestedPlayer, player.Name)
		end;
	end;
end;

raceRequest.OnServerEvent:Connect(RaceRequest)