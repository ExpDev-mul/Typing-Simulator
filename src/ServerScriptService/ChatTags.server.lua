local chatService = require(game.ServerScriptService:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))
local marketPlaceService = game:GetService("MarketplaceService");
chatService.SpeakerAdded:Connect(function(playerName)
	local speaker = chatService:GetSpeaker(playerName)
	local player = game.Players[playerName]

	if marketPlaceService:UserOwnsGamePassAsync(player.UserId, 130177554) then
		speaker:SetExtraData("Tags", {{TagText = "ADMIN", TagColor = Color3.fromRGB(255, 255, 0)}})
	end
end)