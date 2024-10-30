-- // Services
local replicatedStorage = game:GetService("ReplicatedStorage");
local tweenService = game:GetService("TweenService");
local players = game:GetService("Players");
local debris = game:GetService("Debris");

-- // References
local stats = (script.Parent);
local localPlayer = (players.LocalPlayer);
localPlayer:WaitForChild("leaderstats")

-- // Modules
local statsEffect = require(script:WaitForChild("StatsEffect"));

-- // Tables
local ranks = require(replicatedStorage.Ranks);

local statValues = {};

-- // Functions & Events
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

for _, stat in next, localPlayer.leaderstats:GetChildren() do
	local frame = stats:FindFirstChild(stat.Name);
	if not (frame) then continue end;
	
	local function Enter()
		if (stats:FindFirstChild(stat.Name.. "Index")) then
			tweenService:Create(stats:FindFirstChild(stat.Name.. "Index"), TweenInfo.new(0.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Position = UDim2.fromScale(0.5, 0.35)
			}):Play()
		end;
		
		local uiStroke = Instance.new("UIStroke", frame)
		uiStroke.Thickness = 0
		tweenService:Create(uiStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Thickness = 2}):Play()
		local mouseLeaveConnection
		mouseLeaveConnection = frame.MouseLeave:Connect(function()
			mouseLeaveConnection:Disconnect()
			tweenService:Create(uiStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Thickness = 0}):Play()
			debris:AddItem(uiStroke, 0.15)
			if (stats:FindFirstChild(stat.Name.. "Index")) then
				tweenService:Create(stats:FindFirstChild(stat.Name.. "Index"), TweenInfo.new(0.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Position = UDim2.fromScale(0.5, -0.1)
				}):Play()
			end;
		end)
	end;

	frame.MouseEnter:Connect(Enter)
	
	if (stat:IsA("NumberValue") or stat:IsA("IntValue")) then
		if (frame) then
			frame.Value.Text = SimplifyNumber(stat.Value)
		end;
		
		statValues[stat.Name] = stat.Value
		stat:GetPropertyChangedSignal("Value"):Connect(function()
			if (frame) then
				frame.Value.Text = SimplifyNumber(stat.Value)
			end;
			
			local difference = statValues[stat.Name] - stat.Value
			statValues[stat.Name] = stat.Value
			difference = SimplifyNumber(difference)
			statsEffect.new(string.format("%s%d %s", tonumber(difference) > 0 and "-" or "+", math.abs(tonumber(difference)), stat.Name), tonumber(difference) > 0 and Color3.fromRGB(255, 0, 0))
		end)
	end;
	
	if (stat:IsA("StringValue")) then
		if (stats:FindFirstChild(stat.Name)) then
			for index, rank in next, ranks do
				if (stat.Value == rank[1]) then
					frame.Value.TextColor3 = rank[3]
					frame.Value.Text = string.format('<font face="GothamBlack">%s </font>', stat.Value).. string.format('<font color="rgb(0, 0, 0)">(%i/%i)</font>', index, #ranks)
					break
				end;
			end;
		end;
		
		stat:GetPropertyChangedSignal("Value"):Connect(function()
			if (stats:FindFirstChild(stat.Name)) then
				for index, rank in next, ranks do
					if (stat.Value == rank[1]) then
						frame.Value.TextColor3 = rank[3]
						frame.Value.Text = string.format('<font face="GothamBlack">%s </font>', stat.Value).. string.format('<font color="rgb(0, 0, 0)">(%i/%i)</font>', index, #ranks)
						break
					end;
				end;
			end;
		end)
	end;
end;