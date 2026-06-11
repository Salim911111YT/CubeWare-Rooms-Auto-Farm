local noti_data = {
	["Title"] = "Auto Farm Rooms",
	["Text"] = "Default Text",
}

local is_safe = false

local function sendNotification()
	game:GetService("StarterGui"):SetCore("SendNotification", noti_data)
end

pcall(function()
	if not game:GetService("RunService"):IsClient() then
		noti_data["Text"] = "You cannot run this on the server!"
		task.wait()
		sendNotification()
		return
	end

	if game:GetService("ReplicatedStorage") then
		local repStore = game:GetService("ReplicatedStorage")

		if not repStore:FindFirstChild("Values") then
			noti_data["Text"] = "[CUBEWARE]: Isn't a nex / jskin rooms fangame. (Error Code: 200)"
			sendNotification()
			return
		end

		if not repStore:WaitForChild("Values"):FindFirstChild("LastDoor") then
			noti_data["Text"] = "[CUBEWARE]: Couldn't find 'LastDoor' in 'Values' in 'ReplicatedStorage'"
			sendNotification()
			return
		end
	end

	is_safe = true
end)

repeat task.wait() until is_safe == true

local plr = game.Players.LocalPlayer
local door = game:GetService("ReplicatedStorage").Values["LastDoor"]

local prompt : ProximityPrompt = nil

local active = false

game:GetService("UserInputService").InputBegan:Connect(function(key, gsp)
	if gsp then return end
	if key.KeyCode == Enum.KeyCode.P then
		active = not active

		noti_data["Text"] = (active == true and "Enabled!" or active == false and "Disabled!")
		sendNotification()
	end
end)

noti_data["Text"] = "Up and running! Press 'P' to get started!"
sendNotification()

while task.wait() do
	if active == false then continue end

	pcall(function()
		door.Value.Door.CanCollide = false
		door.Value.Door.Transparency = 1

			
		for _, v in pairs(door.Value:GetDescendants()) do
			if v == door.Value.Door.Parent then continue end
			if v == door.Value.Door then continue end
		end

		plr.Character.PrimaryPart.CFrame = door.Value.Door.CFrame

		prompt = door.Value.Door:FindFirstChildOfClass("ProximityPrompt")
		task.wait()
		prompt.HoldDuration = 0
		prompt.Enabled = true
		prompt.MaxActivationDistance = 100;
		prompt.RequiresLineOfSight = false

		prompt:InputHoldBegin()
		task.wait(0.1)
		prompt:InputHoldEnd()
	end)
end
