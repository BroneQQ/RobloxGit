-- ProximityPromptsGui.lua
-- LocalScript for handling proximity prompts GUI

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create the GUI
local proximityPromptsGui = Instance.new("ScreenGui")
proximityPromptsGui.Name = "ProximityPromptsGui"
proximityPromptsGui.Parent = playerGui

-- Create a frame for prompts
local promptFrame = Instance.new("Frame")
promptFrame.Name = "PromptFrame"
promptFrame.Size = UDim2.new(0, 200, 0, 50)
promptFrame.Position = UDim2.new(0.5, -100, 0.8, 0)
promptFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
promptFrame.BackgroundTransparency = 0.5
promptFrame.BorderSizePixel = 0
promptFrame.Parent = proximityPromptsGui

-- Create text label
local promptText = Instance.new("TextLabel")
promptText.Name = "PromptText"
promptText.Size = UDim2.new(1, 0, 1, 0)
promptText.BackgroundTransparency = 1
promptText.Text = ""
promptText.TextColor3 = Color3.fromRGB(255, 255, 255)
promptText.TextScaled = true
promptText.Font = Enum.Font.GothamBold
promptText.Parent = promptFrame

-- Function to show prompt
local function showPrompt(text)
    promptText.Text = text
    promptFrame.Visible = true
end

-- Function to hide prompt
local function hidePrompt()
    promptFrame.Visible = false
    promptText.Text = ""
end

-- Connect to proximity prompts
local function onProximityPromptTriggered(prompt)
    -- Handle proximity prompt
    print("Proximity prompt triggered:", prompt.ObjectText)
end

-- Listen for proximity prompts
game.Workspace.ChildAdded:Connect(function(child)
    if child:IsA("ProximityPrompt") then
        child.Triggered:Connect(onProximityPromptTriggered)
    end
end)

-- Export functions
return {
    ShowPrompt = showPrompt,
    HidePrompt = hidePrompt
}
