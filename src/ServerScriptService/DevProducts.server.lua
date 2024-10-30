-->> Services
local marketPlaceService = game:GetService("MarketplaceService");
local players = game:GetService("Players");

local replicatedStorage = game:GetService("ReplicatedStorage");

local nukeOngoing = false

local nukes = {}
function NukeServer(player)
	if nukeOngoing then
		table.insert(nukes, player)	
		return
	end;
	
	nukeOngoing = true
	replicatedStorage:WaitForChild("IsNuked").Value = true
	task.wait(27)
	nukeOngoing = false
	replicatedStorage:WaitForChild("IsNuked").Value = false
	if nukes[1] then
		task.wait(3)
		local newPlayer = nukes[1]
		table.remove(nukes, 1)
		NukeServer(newPlayer)
	end;
end;

local products = {
	[1368743040] = function(player)
		NukeServer(player)
	end,
}

function ProcessReceipt(info)
		for _, player in next, players:GetChildren() do
			if player.UserId == info.PlayerId then
				task.spawn(function()
					products[info.ProductId](player)
				end)
			
				return Enum.ProductPurchaseDecision.PurchaseGranted
			end;
		end;
	
	return Enum.ProductPurchaseDecision.NotProcessedYet
end;

marketPlaceService.ProcessReceipt = ProcessReceipt