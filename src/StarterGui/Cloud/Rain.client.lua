-->> References
local cloud = script.Parent;
cloud.Parent = workspace
local camera = workspace.CurrentCamera;

-->> Functions & Events
function Rain(droplets)
	cloud.CFrame = camera.CFrame*CFrame.new(0, 7, -cloud.Size.Z/2)
	for i = 1, droplets do
		local newDroplet = Instance.new("Part")
		newDroplet.Size = Vector3.new(0.05, 1, 0.05)
		newDroplet.Position = cloud.Position + cloud.CFrame.LookVector*math.random(-cloud.Size.Z/2, cloud.Size.Z/2) + cloud.CFrame.RightVector*math.random(-cloud.Size.X/2, cloud.Size.X/2)
		newDroplet.Orientation = cloud.Orientation
		newDroplet.Material = Enum.Material.Neon
		newDroplet.Color = Color3.fromRGB(255, 255, 255)
		newDroplet.Transparency = 0.85
		newDroplet.CastShadow = false
		newDroplet.CanCollide = false
		newDroplet.Parent = workspace.CameraFiltered
		newDroplet.Velocity = cloud.CFrame.UpVector*-math.random(50, 100) + Vector3.new(math.random(0, 50), 0, math.random(0, 50))
		task.delay(0.5, function()
			newDroplet:Destroy()
		end)
	end;
end;

while task.wait(0.1) do
	Rain(cloud.Size.X +cloud.Size.Z/2/15)
end;