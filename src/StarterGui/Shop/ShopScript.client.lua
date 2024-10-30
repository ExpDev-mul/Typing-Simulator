-->> Services
local tweenService = game:GetService("TweenService");
local marketPlaceService = game:GetService("MarketplaceService");

-->> References
local shop = script.Parent;
local x2Sentences = shop:WaitForChild("X2Sentences");
local x2Time = shop:WaitForChild("X2Time");
local adminCommands = shop:WaitForChild("AdminCommands");
local nukeServer = shop:WaitForChild("NukeServer");

-->> Functions & Events
x2Sentences.MouseEnter:Connect(function()
	tweenService:Create(x2Sentences.UIGradient, TweenInfo.new(0.2, Enum.EasingStyle.Circular), {Offset = Vector2.new(0, 0.5)}):Play()
end)

x2Sentences.MouseLeave:Connect(function()
	tweenService:Create(x2Sentences.UIGradient, TweenInfo.new(0.2, Enum.EasingStyle.Circular), {Offset = Vector2.zero}):Play()
end)

x2Sentences.MouseButton1Down:Connect(function()
	tweenService:Create(x2Sentences.UIGradient, TweenInfo.new(0.2, Enum.EasingStyle.Circular), {Offset = Vector2.new(0, 1)}):Play()
end)

x2Sentences.MouseButton1Click:Connect(function()
	tweenService:Create(x2Sentences.UIGradient, TweenInfo.new(0.2, Enum.EasingStyle.Circular), {Offset = Vector2.zero}):Play()
	marketPlaceService:PromptGamePassPurchase(game.Players.LocalPlayer, 91504123)
end)



x2Time.MouseEnter:Connect(function()
	tweenService:Create(x2Time.UIGradient, TweenInfo.new(0.2, Enum.EasingStyle.Circular), {Offset = Vector2.new(0, 0.5)}):Play()
end)

x2Time.MouseLeave:Connect(function()
	tweenService:Create(x2Time.UIGradient, TweenInfo.new(0.2, Enum.EasingStyle.Circular), {Offset = Vector2.zero}):Play()
end)

x2Time.MouseButton1Down:Connect(function()
	tweenService:Create(x2Time.UIGradient, TweenInfo.new(0.2, Enum.EasingStyle.Circular), {Offset = Vector2.new(0, 1)}):Play()
end)

x2Time.MouseButton1Click:Connect(function()
	tweenService:Create(x2Time.UIGradient, TweenInfo.new(0.2, Enum.EasingStyle.Circular), {Offset = Vector2.zero}):Play()
	marketPlaceService:PromptGamePassPurchase(game.Players.LocalPlayer, 91500953)
end)



adminCommands.MouseEnter:Connect(function()
	tweenService:Create(adminCommands.UIGradient, TweenInfo.new(0.2, Enum.EasingStyle.Circular), {Offset = Vector2.new(0, 0.5)}):Play()
end)

adminCommands.MouseLeave:Connect(function()
	tweenService:Create(adminCommands.UIGradient, TweenInfo.new(0.2, Enum.EasingStyle.Circular), {Offset = Vector2.zero}):Play()
end)

adminCommands.MouseButton1Down:Connect(function()
	tweenService:Create(adminCommands.UIGradient, TweenInfo.new(0.2, Enum.EasingStyle.Circular), {Offset = Vector2.new(0, 1)}):Play()
end)

adminCommands.MouseButton1Click:Connect(function()
	tweenService:Create(adminCommands.UIGradient, TweenInfo.new(0.2, Enum.EasingStyle.Circular), {Offset = Vector2.zero}):Play()
	marketPlaceService:PromptGamePassPurchase(game.Players.LocalPlayer, 130177554)
end)



nukeServer.MouseEnter:Connect(function()
	tweenService:Create(nukeServer.UIGradient, TweenInfo.new(0.2, Enum.EasingStyle.Circular), {Offset = Vector2.new(0, 0.5)}):Play()
end)

nukeServer.MouseLeave:Connect(function()
	tweenService:Create(nukeServer.UIGradient, TweenInfo.new(0.2, Enum.EasingStyle.Circular), {Offset = Vector2.zero}):Play()
end)

nukeServer.MouseButton1Down:Connect(function()
	tweenService:Create(nukeServer.UIGradient, TweenInfo.new(0.2, Enum.EasingStyle.Circular), {Offset = Vector2.new(0, 1)}):Play()
end)

nukeServer.MouseButton1Click:Connect(function()
	tweenService:Create(nukeServer.UIGradient, TweenInfo.new(0.2, Enum.EasingStyle.Circular), {Offset = Vector2.zero}):Play()
	marketPlaceService:PromptProductPurchase(game.Players.LocalPlayer, 1368743040)
end)