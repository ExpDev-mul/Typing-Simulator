-- // Services
local players = game:GetService("Players");
local replicatedStorage = game:GetService("ReplicatedStorage");
local marketPlaceService = game:GetService("MarketplaceService");

-- // References
local raceFinish = replicatedStorage:WaitForChild("RaceFinish");

function RaceFinish(player, requestedPlayer)
	player.leaderstats.Sentences.Value += 5 * (marketPlaceService:UserOwnsGamePassAsync(player.UserId, 91504123) and 2 or 1)
	player.leaderstats.Wins.Value += 1
	player:FindFirstChild("InRace"):Destroy()
	requestedPlayer = players:FindFirstChild(requestedPlayer);
	if (requestedPlayer) then
		raceFinish:FireClient(requestedPlayer)
		requestedPlayer:FindFirstChild("InRace"):Destroy()
	end;
end;

raceFinish.OnServerEvent:Connect(RaceFinish)