-- === WorldManager v2.1 ===
-- SKOPIUJ TO DO: ServerScriptService > WorldManager (Script)

local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local playerDataStore = DataStoreService:GetDataStore("PlayerBrainrotData_V2") -- Nowa wersja na wszelki wypadek

-- Szablony
local plotTemplate = ServerStorage:WaitForChild("PlayerPlotTemplate")
local conveyorTemplate = ServerStorage:WaitForChild("ConveyorBelt")
local eggFolder = ReplicatedStorage:WaitForChild("Eggs")

-- Konfiguracja
local PLOT_SPACING = 600
local EGG_Y_OFFSET = 1.2
local SPAWN_RATE = 5
local TRAVEL_TIME = 15
local EPIC_PITY_THRESHOLD = 50
local LEGENDARY_PITY_THRESHOLD = 200
local RARITY_CHANCES = {
    ["Egg_Common"] = 80,
    ["Egg_Rare"] = 20
}
local plotCounter = 0

-- Funkcje pomocnicze
local function getRandomBasicEggName()
    local r = math.random(1, 100)
    local c = 0
    for n, h in pairs(RARITY_CHANCES) do
        c = c + h
        if r <= c then
            return n
        end
    end
end

local function spawnEggForPlayer(player)
    if not player or not player.Parent then return end
    
    local pC = workspace:FindFirstChild(player.Name.."_Conveyor")
    if not pC then return end
    
    local sP, eP = pC:FindFirstChild("SpawnPoint"), pC:FindFirstChild("EndPoint")
    if not sP or not eP then return end
    
    local pD = player:WaitForChild("PityData")
    local ep, lp = pD.epicPity, pD.legendaryPity
    local cN
    
    if lp.Value >= LEGENDARY_PITY_THRESHOLD then
        cN = "Egg_Legendary"
        lp.Value, ep.Value = 0, 0
    elseif ep.Value >= EPIC_PITY_THRESHOLD then
        cN = "Egg_Epic"
        ep.Value = 0
    else
        cN = getRandomBasicEggName()
        ep.Value, lp.Value = ep.Value + 1, lp.Value + 1
    end
    
    local eT = eggFolder:FindFirstChild(cN)
    if eT then
        local nE = eT:Clone()
        local oV = Instance.new("ObjectValue", nE)
        oV.Name, oV.Value = "Owner", player
        
        local sCF = sP.CFrame * CFrame.new(0, EGG_Y_OFFSET, 0)
        nE:SetPrimaryPartCFrame(sCF)
        nE.Parent = workspace
        
        local ePos = eP.Position
        local gCF = CFrame.new(ePos.X, sCF.Position.Y, ePos.Z)
        local tI, g = TweenInfo.new(TRAVEL_TIME, Enum.EasingStyle.Linear), {CFrame = gCF}
        local tS = game:GetService("TweenService")
        local tw = tS:Create(nE.PrimaryPart, tI, g)
        tw:Play()
        
        game:GetService("Debris"):AddItem(nE, TRAVEL_TIME)
    end
end

local function playerSpawnLoop(player)
    while player.Parent == Players do
        task.wait(SPAWN_RATE)
        spawnEggForPlayer(player)
    end
end

-- Logika dołączania gracza
Players.PlayerAdded:Connect(function(player)
    local leaderstats = Instance.new("Folder", player)
    leaderstats.Name = "leaderstats"
    local coins = Instance.new("IntValue", leaderstats)
    coins.Name = "Coins"
    
    local pityData = Instance.new("Folder", player)
    pityData.Name = "PityData"
    local epicPity = Instance.new("IntValue", pityData)
    epicPity.Name = "epicPity"
    local legendaryPity = Instance.new("IntValue", pityData)
    legendaryPity.Name = "legendaryPity"
    
    local eggInventory = Instance.new("Folder", player)
    eggInventory.Name = "EggInventory"
    
    -- Dodaj poziom Backpack Upgrade (0 = podstawowy, 1-7 = upgrade'y)
    local backpackLevel = Instance.new("IntValue", player)
    backpackLevel.Name = "BackpackLevel"
    backpackLevel.Value = 0 -- 0 = 29 slotów, 1 = 39, 2 = 49, ..., 7 = 99

    local playerUserId = "Player_" .. player.UserId
    local success, data = pcall(function()
        return playerDataStore:GetAsync(playerUserId)
    end)
    
    if success then
        if data then
            -- Dane istnieją - wczytaj je
            coins.Value = data.Coins or 100
            epicPity.Value = data.Pity_Epic or 0
            legendaryPity.Value = data.Pity_Legendary or 0
            backpackLevel.Value = data.BackpackLevel or 0
            
            if data.EggInventory then
                for _, eggName in ipairs(data.EggInventory) do
                    Instance.new("StringValue", eggInventory).Name = eggName
                end
            end
            
            print("📊 Wczytano dane gracza:", player.Name, "Backpack Level:", backpackLevel.Value)
        else
            -- Dane nie istnieją (nowy gracz) - ustaw domyślne
            coins.Value = 100
            epicPity.Value = 0
            legendaryPity.Value = 0
            backpackLevel.Value = 0
            print("🆕 Nowy gracz:", player.Name, "- ustawiono domyślne dane")
        end
    else
        -- Błąd DataStore - ustaw domyślne i pokaż ostrzeżenie
        coins.Value = 100
        epicPity.Value = 0
        legendaryPity.Value = 0
        backpackLevel.Value = 0
        warn("❌ DataStore Error dla gracza:", player.Name)
        warn("❌ Błąd:", tostring(data))
        warn("❌ Sprawdź API Services w Game Settings!")
        print("⚠️ Używam domyślnych danych dla gracza:", player.Name)
    end

    plotCounter = plotCounter + 1
    local newPlot = plotTemplate:Clone()
    newPlot.Name = player.Name .. "_Plot"
    local plotPosition = Vector3.new(plotCounter * PLOT_SPACING, 5, 0)
    newPlot:SetPrimaryPartCFrame(CFrame.new(plotPosition))
    newPlot.Parent = workspace

    local newConveyor = conveyorTemplate:Clone()
    newConveyor.Name = player.Name .. "_Conveyor"
    local conveyorOffset = CFrame.new(-40, 1.25, 0)
    newConveyor:SetPrimaryPartCFrame(newPlot.PrimaryPart.CFrame * conveyorOffset)
    newConveyor.Parent = workspace

    player.CharacterAdded:Connect(function(character)
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = newPlot.PrimaryPart.CFrame * CFrame.new(0, 10, 0)
    end)
    
    task.spawn(playerSpawnLoop, player)
end)

-- Logika zapisu
Players.PlayerRemoving:Connect(function(player)
    local playerUserId = "Player_" .. player.UserId
    local dataToSave = {
        Coins = player.leaderstats.Coins.Value,
        Pity_Epic = player.PityData.epicPity.Value,
        Pity_Legendary = player.PityData.legendaryPity.Value,
        BackpackLevel = player.BackpackLevel.Value,
        EggInventory = {}
    }
    
    for _, eggItem in ipairs(player.EggInventory:GetChildren()) do
        table.insert(dataToSave.EggInventory, eggItem.Name)
    end
    
    local success, err = pcall(function()
        playerDataStore:SetAsync(playerUserId, dataToSave)
    end)
    
    if success then
        print("💾 Zapisano dane gracza:", player.Name)
        print("💰 Coins:", dataToSave.Coins, "BackpackLevel:", dataToSave.BackpackLevel, "Jajka:", #dataToSave.EggInventory)
    else
        warn("❌ DataStore SAVE Error dla gracza:", player.Name)
        warn("❌ Błąd:", tostring(err))
        warn("❌ Sprawdź API Services w Game Settings!")
        
        -- Próbuj ponownie po 2 sekundach
        wait(2)
        local retrySuccess = pcall(function()
            playerDataStore:SetAsync(playerUserId, dataToSave)
        end)
        
        if retrySuccess then
            print("✅ Ponowny zapis udany dla gracza:", player.Name)
        else
            warn("💀 Ostateczny błąd zapisu dla gracza:", player.Name)
        end
    end
end)
