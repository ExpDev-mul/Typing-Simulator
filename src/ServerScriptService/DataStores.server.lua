-- // Services
local dataStoreService = game:GetService("DataStoreService");
local replicatedStorage = game:GetService("ReplicatedStorage");
local dataStoreService = game:GetService("DataStoreService");
local players = game:GetService("Players");
local marketPlaceService = game:GetService("MarketplaceService");

-- // References
local localPlayer = players.LocalPlayer;
local rankBillboard = script:WaitForChild("RankBillboard");
local userBillboard = script:WaitForChild("UserBillboard");
local adminBillboard = script:WaitForChild("AdminBillboard");
local sentencesLeaderboard = workspace:WaitForChild("SentencesLeaderboard");

-- // Modules
local dataStore2 = require(replicatedStorage:WaitForChild("DataStore2"));

-- // Tables
local ranks = require(replicatedStorage.Ranks);

function GetRank(value)
	for index, validRank in next, ranks do
		if (value < validRank[2]) then
			return ranks[index - 1][1], ranks[index - 1][3]
		end;
	end;
	
	return ranks[#ranks][1], ranks[#ranks][3]
end;

function PlayerAdded(player)
	local playerData = dataStore2("_Data", player)
	playerData = playerData:Get() or {Sentences = 0, Wins = 0}
	
	-- // Inserting leaderstats folder
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"
	
	-- // Inserting stats
	local wins = Instance.new("NumberValue", leaderstats)
	wins.Name = "Wins"
	wins.Value = playerData[wins.Name]
	local sentences = Instance.new("NumberValue", leaderstats)
	sentences.Name = "Sentences"
	sentences.Value = playerData[sentences.Name]
	local rank = Instance.new("StringValue", leaderstats)
	rank.Name = "Rank"
	
	if not player.Character then
		player.CharacterAdded:Wait()	
	end;
	
	local rankBillboardClone = rankBillboard:Clone()
	rankBillboardClone.Parent = player.Character.HumanoidRootPart
	local userBillboardClone = userBillboard:Clone()
	userBillboardClone.Parent = player.Character.HumanoidRootPart
	userBillboardClone.User.Text = player.Name
	
	local rankName, rankColor = GetRank(sentences.Value)
	rank.Value = rankName
	rankBillboardClone.Rank.Text = "<i>".. rankName.. "</i>"
	rankBillboardClone.Rank.TextColor3 = rankColor
	
	local adminBillboardClone;
	if marketPlaceService:UserOwnsGamePassAsync(player.UserId, 130177554) then
		adminBillboardClone = adminBillboard:Clone()
		adminBillboardClone.Parent = player.Character.HumanoidRootPart
	end;
	
	player.CharacterAdded:Connect(function()
		rankName, rankColor = GetRank(sentences.Value)
		rankBillboardClone.Rank.Text = "<i>".. rankName.. "</i>"
		rankBillboardClone.Rank.TextColor3 = rankColor
		rankBillboardClone.Parent = player.Character.HumanoidRootPart
		
		userBillboardClone = userBillboard:Clone()
		userBillboardClone.Parent = player.Character.HumanoidRootPart
		userBillboardClone.User.Text = player.Name
		
		if marketPlaceService:UserOwnsGamePassAsync(player.UserId, 130177554) then
			adminBillboardClone = adminBillboard:Clone()
			adminBillboardClone.Parent = player.Character.HumanoidRootPart
		end;
	end)
	
	sentences:GetPropertyChangedSignal("Value"):Connect(function()
		local rankName, rankColor = GetRank(sentences.Value)
		rank.Value = rankName
		rankBillboardClone.Rank.Text = "<i>".. rankName.. "</i>"
		rankBillboardClone.Rank.TextColor3 = rankColor
	end)
end;

players.PlayerAdded:Connect(PlayerAdded)


function PlayerRemoved(player)
	local playerData = dataStore2("_Data", player)
	local toSave = {};
	
	-- // Saving leaderstats data
	local leaderstats = player:WaitForChild("leaderstats"):GetChildren();
	for _, leaderstat in next, leaderstats do
		toSave[leaderstat.Name] = leaderstat.Value
	end;
		
	playerData:Set(toSave)
	
	-- // Saving ordered data
	local orderedDataStore = dataStoreService:GetOrderedDataStore("_Sentences");
	orderedDataStore:SetAsync(player.UserId, toSave.Sentences)
end;

players.PlayerRemoving:Connect(PlayerRemoved)

function SimplifyNumber(x)
	local simplifiedValue = (x);
	local index
	while (true) do  
		simplifiedValue, index = string.gsub(simplifiedValue, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (index == 0) then
			break
		end
	end

	return (simplifiedValue);
end;

function SentencesLeaderboardUpdate()
	for _, someFrame in next, sentencesLeaderboard:WaitForChild("LeaderboardCanvas"):WaitForChild("Surface"):WaitForChild("Canvas"):GetChildren() do
		if not (someFrame:IsA("Frame")) then continue end;
		someFrame:Destroy()
	end;
	
	local orderedDataStore = dataStoreService:GetOrderedDataStore("_Sentences");
	local pages = orderedDataStore:GetSortedAsync(false, 25, 1, 10^19)
	pages = pages:GetCurrentPage()
	
	local minimalValue = (nil);
	local playerTemplate = sentencesLeaderboard:WaitForChild("PlayerTemplate");
	for rank, data in next, pages do
		if not (minimalValue) then
			minimalValue = data.Value
		end;
		
		local ptClone = playerTemplate:Clone();
		ptClone.Rank.Text = string.format("<i>#%i</i>", rank)
		ptClone.Username.Text = "<i>".. players:GetNameFromUserIdAsync(data.key).. "</i>"
		local rankName, rankColor = GetRank(data.value)
		ptClone.Value.Text = string.format("<i>%s (%s)</i>", SimplifyNumber(data.value), string.format('<font color="rgb(%i, %i, %i)">%s</font>', rankColor.R*255, rankColor.G*255, rankColor.B*255, rankName))
		ptClone.Parent = sentencesLeaderboard.LeaderboardCanvas.Surface.Canvas
	end;
	
	if (minimalValue) then
		for _, player in next, players:GetChildren() do
			if (player:WaitForChild("leaderstats"):WaitForChild("Sentences").Value > minimalValue) then
				orderedDataStore:SetAsync(player.UserId, player.leaderstats.Sentences.Value)
			end;
		end;
	end;
end;

SentencesLeaderboardUpdate()
while task.wait(80) do
	SentencesLeaderboardUpdate()
end;