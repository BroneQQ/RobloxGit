-- === PlacementHandler v3.0 ===
-- SKOPIUJ TO DO: ServerScriptService > PlacementHandler (Script)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local placeRequestEvent = ReplicatedStorage:WaitForChild("PlaceEggRequest")

-- Konfiguracja
local MAX_BRAINROTS_PER_PLAYER = 40
local INCUBATION_TIMES = {
    ["Egg_Common"] = 5,
    ["Egg_Rare"] = 15,
    ["Egg_Epic"] = 30,
    ["Egg_Legendary"] = 45
}

-- ⚠️ WAŻNE: WYPEŁNIJ TĘ TABELĘ dla wszystkich swoich modeli Brainrotów!
local BRAINROT_Y_OFFSETS = {
    ["Common_BrainrotA"] = 2.5,
    ["Common_BrainrotB"] = 3,
    ["Rare_BrainrotA"] = 2.8,
    ["Epic_BrainrotA"] = 3.2,
    ["Legendary_BrainrotA"] = 4.0
    -- DODAJ WSZYSTKIE SWOJE MODELE TUTAJ!
}

-- Inkubacja
local function startIncubation(placedEgg, player, incubationTime, specificBrainrotName)
    local finalSpawnCFrame = placedEgg:GetPrimaryPartCFrame()
    
    local billboardGui = Instance.new("BillboardGui", placedEgg)
    billboardGui.Size = UDim2.new(0, 80, 0, 30)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel", billboardGui)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextScaled = true
    
    for i = incubationTime, 0, -1 do
        if not placedEgg.Parent then return end
        textLabel.Text = tostring(i)
        task.wait(1)
    end
    
    placedEgg:Destroy()
    
    local brainrotTemplate = ServerStorage.Brainrots:FindFirstChild(specificBrainrotName)
    if brainrotTemplate then
        local newBrainrot = brainrotTemplate:Clone()
        local yOffsetValue = BRAINROT_Y_OFFSETS[specificBrainrotName] or 2
        local verticalOffset = CFrame.new(0, yOffsetValue, 0)
        newBrainrot:SetPrimaryPartCFrame(finalSpawnCFrame * verticalOffset)
        newBrainrot.PrimaryPart.Anchored = true
        
        local dataFolder = newBrainrot:WaitForChild("Data")
        dataFolder.Owner.Value = player
        dataFolder.Level.Value = 1
        
        newBrainrot.Parent = workspace
    end
end

-- Obsługa prośby
local function onPlaceRequest(player, specificBrainrotName, position)
    local brainrotsOwned = 0
    for _, m in ipairs(workspace:GetChildren()) do
        if m:IsA("Model") then
            local d = m:FindFirstChild("Data")
            if d then
                local o = d:FindFirstChild("Owner")
                if o and o.Value == player then
                    brainrotsOwned = brainrotsOwned + 1
                end
            end
        end
    end
    
    if brainrotsOwned >= MAX_BRAINROTS_PER_PLAYER then return end
    
    local eggInventory = player:FindFirstChild("EggInventory")
    if not eggInventory then return end
    
    local eggItem = eggInventory:FindFirstChild(specificBrainrotName)
    if not eggItem then return end
    
    local playerPlot = workspace:FindFirstChild(player.Name.."_Plot")
    if not playerPlot or (position - playerPlot.PrimaryPart.Position).Magnitude > 200 then return end
    
    eggItem:Destroy()
    
    local rarity = string.split(specificBrainrotName, "_")[1]
    local eggType = "Egg_" .. rarity
    local eggTemplate = ReplicatedStorage.Eggs:FindFirstChild(eggType)
    if not eggTemplate then return end
    
    local eggToPlace = eggTemplate:Clone()
    eggToPlace:SetPrimaryPartCFrame(CFrame.new(position))
    eggToPlace.PrimaryPart.Anchored = true
    eggToPlace.Parent = workspace
    
    local incubationTime = INCUBATION_TIMES[eggType]
    if incubationTime then
        task.spawn(startIncubation, eggToPlace, player, incubationTime, specificBrainrotName)
    end
end

placeRequestEvent.OnServerEvent:Connect(onPlaceRequest)

