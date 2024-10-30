-- // Services
local replicatedStorage = game:GetService("ReplicatedStorage");
local marketPlaceService = game:GetService("MarketplaceService");

-- // References
local grantSentences = (replicatedStorage:WaitForChild("GrantSentences"));
local TOKEN = ("kYvn08t9H3Yb2vOTWtON");
function GrantSentences(player, amount, token)
	if not (token == TOKEN) then
		player:Kick("Cheats detected.")
		return
	end;
	
	player.leaderstats.Sentences.Value += amount * (marketPlaceService:UserOwnsGamePassAsync(player.UserId, 91504123) and 2 or 1)
end;

grantSentences.OnServerEvent:Connect(GrantSentences)