-- WorldSetup.lua
-- Script to create basic world objects

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create basic world objects
local function createWorld()
    local workspace = game.Workspace

    print("Starting world setup...")

    -- Check if ground already exists
    if workspace:FindFirstChild("Ground") then
        print("Ground already exists, skipping...")
    else
        -- Create ground
        local ground = Instance.new("Part")
        ground.Name = "Ground"
        ground.Size = Vector3.new(100, 1, 100)
        ground.Position = Vector3.new(0, -0.5, 0)
        ground.Anchored = true
        ground.Material = Enum.Material.Grass
        ground.Parent = workspace
        print("Ground created successfully!")
    end

    -- Check if transporter already exists
    if workspace:FindFirstChild("Transporter") then
        print("Transporter already exists, skipping...")
    else
        -- Create transporter
        local transporter = Instance.new("Part")
        transporter.Name = "Transporter"
        transporter.Size = Vector3.new(4, 1, 4)
        transporter.Position = Vector3.new(0, 0.5, 50)
        transporter.Anchored = true
        transporter.Material = Enum.Material.Neon
        transporter.BrickColor = BrickColor.new("Really blue")
        transporter.Parent = workspace

        -- Add ProximityPrompt to transporter
        local prompt = Instance.new("ProximityPrompt")
        prompt.ObjectText = "Transporter"
        prompt.ActionText = "Use"
        prompt.MaxActivationDistance = 8
        prompt.Parent = transporter
        print("Transporter created successfully!")
    end

    -- Check if trees already exist
    if workspace:FindFirstChild("Tree1") then
        print("Tree1 already exists, skipping...")
    else
        -- Create some decorative objects
        local tree1 = Instance.new("Part")
        tree1.Name = "Tree1"
        tree1.Size = Vector3.new(2, 10, 2)
        tree1.Position = Vector3.new(20, 5, 20)
        tree1.Anchored = true
        tree1.Material = Enum.Material.Wood
        tree1.BrickColor = BrickColor.new("Brown")
        tree1.Parent = workspace
        print("Tree1 created successfully!")
    end

    if workspace:FindFirstChild("Tree2") then
        print("Tree2 already exists, skipping...")
    else
        local tree2 = Instance.new("Part")
        tree2.Name = "Tree2"
        tree2.Size = Vector3.new(2, 8, 2)
        tree2.Position = Vector3.new(-20, 4, -20)
        tree2.Anchored = true
        tree2.Material = Enum.Material.Wood
        tree2.BrickColor = BrickColor.new("Brown")
        tree2.Parent = workspace
        print("Tree2 created successfully!")
    end

    print("World setup completed!")
    print("Objects in workspace:")
    for _, child in pairs(workspace:GetChildren()) do
        if child:IsA("BasePart") then
            print("  - " .. child.Name .. " at " .. tostring(child.Position))
        end
    end
end

-- Run world setup automatically when script runs
createWorld()

-- Return the function so it can be used with require() if needed
return createWorld
