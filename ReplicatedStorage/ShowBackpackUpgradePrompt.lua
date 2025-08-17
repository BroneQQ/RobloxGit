-- ShowBackpackUpgradePrompt.lua
-- RemoteEvent for showing backpack upgrade prompt

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create the RemoteEvent
local ShowBackpackUpgradePrompt = Instance.new("RemoteEvent")
ShowBackpackUpgradePrompt.Name = "ShowBackpackUpgradePrompt"
ShowBackpackUpgradePrompt.Parent = ReplicatedStorage

return ShowBackpackUpgradePrompt
