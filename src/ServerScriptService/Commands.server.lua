local players = game:GetService("Players");
local marketPlaceService = game:GetService("MarketplaceService");

function FindClosestPlayer(name)
	local maxPlayer = nil
	local maxScore = -math.huge
	for _, player in next, players:GetChildren() do
		local currentScore = 0
		for x = 1, math.min(string.len(player.Name), string.len(name)) do
			local c1 = string.sub(name, x, x)
			local c2 = string.sub(player.Name, x, x)
			if c1 == c2 then
				currentScore += 2
				continue
			end;
			
			if c1:lower() == c2:lower() then
				currentScore += 1
				continue
			end;
		end;
		
		if currentScore >= maxScore then
			maxScore = currentScore
			maxPlayer = player
		end;
	end;
	
	return maxPlayer
end;

players.PlayerAdded:Connect(function(player)
	if marketPlaceService:UserOwnsGamePassAsync(player.UserId, 130177554) then
		player.Chatted:Connect(function(message)
			local command = string.split(message, " ")
			if string.lower(command[1]) == ";fire" then
				if string.lower(command[2]) == "me" then
					Instance.new("Fire", player.Character.HumanoidRootPart)
					return
				end;
				
				local player2 = FindClosestPlayer(command[2])
				if player2 then
					Instance.new("Fire", player2.Character.HumanoidRootPart)
				end;
			end;
			
			if string.lower(command[1]) == ";sparkles" then
				Instance.new("Sparkles", player.Character.HumanoidRootPart)
			end;
			
			if string.lower(command[1]) == ";walkspeed" then
				player.Character.Humanoid.WalkSpeed = tonumber(command[2])
			end;
			
			if string.lower(command[1]) == ";jumppower" then
				player.Character.Humanoid.JumpPower = tonumber(command[2])
			end;
		end)
	end;
end)