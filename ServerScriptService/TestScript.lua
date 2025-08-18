-- TestScript.lua
-- Simple test script to verify script execution

print("=== TEST SCRIPT STARTED ===")
print("Current time: " .. os.date())

-- Create a simple test part
local workspace = game.Workspace
local testPart = Instance.new("Part")
testPart.Name = "TestPart"
testPart.Size = Vector3.new(5, 5, 5)
testPart.Position = Vector3.new(0, 10, 0)
testPart.Anchored = true
testPart.Material = Enum.Material.Neon
testPart.BrickColor = BrickColor.new("Really red")
testPart.Parent = workspace

print("TestPart created at position: " .. tostring(testPart.Position))
print("=== TEST SCRIPT COMPLETED ===")

