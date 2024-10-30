-- // Services
local tweenService = game:GetService("TweenService");
local debris = game:GetService("Debris");

-- // References
local notificationFrame = script:WaitForChild("NotificationFrame");
local back = script.Parent:WaitForChild("Back");
local notifications = {}
function notifications.new(text)
	if not string.find(text, "%.") then
		text = string.format("%s.", text)
	end;
	
	task.spawn(function()
		local notificationsFrameClone = notificationFrame:Clone();
		notificationsFrameClone.Parent = back
		notificationsFrameClone.NotificationText.Text = text
		tweenService:Create(notificationsFrameClone, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
		tweenService:Create(notificationsFrameClone.NotificationText, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
		debris:AddItem(notificationsFrameClone, 5)
		task.delay(2, function()
			tweenService:Create(notificationsFrameClone, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
			tweenService:Create(notificationsFrameClone.NotificationText, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
			task.wait(0.5)
			notificationsFrameClone:Destroy()
		end)
	end)
end;

return notifications