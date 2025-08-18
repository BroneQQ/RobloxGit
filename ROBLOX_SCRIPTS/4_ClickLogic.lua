-- === ClickLogic v4 ===
-- SKOPIUJ TO DO: Każdego jajka w ReplicatedStorage/Eggs jako Script
-- (Egg_Common, Egg_Rare, Egg_Epic, Egg_Legendary)

local eggModel = script.Parent
local clickDetector = eggModel:WaitForChild("ClickDetector")
local ServerStorage = game:GetService("ServerStorage")

print("🥚 ClickLogic uruchomiony dla:", eggModel.Name, "w:", eggModel.Parent and eggModel.Parent.Name or "BRAK PARENT")

-- Budowanie puli losowania
local BRAINROT_MODEL_NAME_MAP = {}
local BrainrotsFolder = ServerStorage:WaitForChild("Brainrots")

for _, bm in ipairs(BrainrotsFolder:GetChildren()) do
    local p = string.split(bm.Name, "_")
    local r = p[1]
    if r then
        local eN = "Egg_" .. r
        if not BRAINROT_MODEL_NAME_MAP[eN] then
            BRAINROT_MODEL_NAME_MAP[eN] = {}
        end
        table.insert(BRAINROT_MODEL_NAME_MAP[eN], bm.Name)
    end
end

local function onEggClicked(playerWhoClicked)
    print("🖱️ Kliknięto jajko:", eggModel.Name, "przez gracza:", playerWhoClicked.Name)

    local oV = eggModel:FindFirstChild("Owner")
    if not oV then
        print("⚠️ Jajko nie ma Owner - sprawdzam dzieci jajka:")
        for _, child in ipairs(eggModel:GetChildren()) do
            print("  -", child.Name, child.ClassName)
        end
        return
    end

    print("✅ Owner znaleziony:", oV.Value and oV.Value.Name or "NIL")

    if oV.Value ~= playerWhoClicked then
        print("❌ Jajko należy do innego gracza:", oV.Value and oV.Value.Name or "BRAK")
        return
    end

    local pB = BRAINROT_MODEL_NAME_MAP[eggModel.Name]
    if not pB then return end

    local rI = math.random(1, #pB)
    local sBN = pB[rI]

    local eI = playerWhoClicked:WaitForChild("EggInventory")
    if not eI then return end

    -- System poziomów backpack
    local currentEggs = #eI:GetChildren()
    local baseSlots = 29 -- 9 hotbar + 20 backpack
    local backpackLevel = 0

    if playerWhoClicked:FindFirstChild("BackpackLevel") then
        backpackLevel = playerWhoClicked.BackpackLevel.Value
    end

    -- Każdy poziom daje +10 slotów (max 7 poziomów = 99 slotów total)
    local maxSlots = baseSlots + (backpackLevel * 10)
    local maxLevel = 7 -- Maksymalny poziom (99 slotów)

    print("📊 Inwentarz gracza:", currentEggs .. "/" .. maxSlots, "Poziom:", backpackLevel .. "/" .. maxLevel)
    print("🔍 Sprawdzam limit: currentEggs=" .. currentEggs .. " >= maxSlots=" .. maxSlots .. " ?")

    if currentEggs >= maxSlots then
        print("🚫 LIMIT OSIĄGNIĘTY! Nie można dodać więcej jajek")

        if backpackLevel < maxLevel then
            -- Można kupić kolejny upgrade
            local nextLevel = backpackLevel + 1
            local cost = 199 + (nextLevel - 1) * 50 -- Rosnące ceny: 199, 249, 299, 349, 399, 449, 499

            print("💎 Pokazuję prompt upgrade do poziomu", nextLevel, "za", cost, "Robux")

            -- Wyślij event do klienta żeby pokazał GUI
            local remoteEvent = game.ReplicatedStorage:FindFirstChild("ShowBackpackUpgradePrompt")
            if remoteEvent then
                print("✅ RemoteEvent znaleziony - wysyłam prompt")
                remoteEvent:FireClient(playerWhoClicked, {
                    currentLevel = backpackLevel,
                    nextLevel = nextLevel,
                    currentSlots = maxSlots,
                    nextSlots = baseSlots + (nextLevel * 10),
                    extraSlots = 10,
                    cost = cost,
                    maxLevel = maxLevel
                })
            else
                warn("❌ RemoteEvent 'ShowBackpackUpgradePrompt' nie znaleziony!")
                warn("❌ Sprawdź czy GamePassHandler.lua jest uruchomiony w ServerScriptService")
            end
        else
            print("⚠️ MAKSYMALNY POZIOM osiągnięty! (99 slotów)")

            -- Pokaż info o maksymalnym poziomie
            local remoteEvent = game.ReplicatedStorage:FindFirstChild("ShowBackpackUpgradePrompt")
            if remoteEvent then
                print("✅ Wysyłam info o maksymalnym poziomie")
                remoteEvent:FireClient(playerWhoClicked, {
                    type = "max_level",
                    message = "Osiągnąłeś maksymalny poziom backpack! (99 slotów)"
                })
            else
                warn("❌ RemoteEvent 'ShowBackpackUpgradePrompt' nie znaleziony!")
            end
        end

        return -- NIE dodawaj jajka
    end

    local item = Instance.new("StringValue")
    item.Name = sBN
    item.Parent = eI

    print("✅ Dodano jajko:", sBN, "do inwentarza gracza:", playerWhoClicked.Name)

    local pD = playerWhoClicked:WaitForChild("PityData")
    if eggModel.Name == "Egg_Legendary" then
        pD.legendaryPity.Value, pD.epicPity.Value = 0, 0
    elseif eggModel.Name == "Egg_Epic" then
        pD.epicPity.Value = 0
    end

    eggModel:Destroy()
end

-- Poczekaj aż jajko będzie w workspace (nie w ReplicatedStorage)
local function waitForWorkspaceEgg()
    while eggModel.Parent ~= workspace do
        wait(0.1)
    end
    print("✅ Jajko teraz w workspace, podłączam ClickDetector")
end

-- Uruchom w osobnym wątku
spawn(function()
    waitForWorkspaceEgg()
    clickDetector.MouseClick:Connect(onEggClicked)
    print("🎯 ClickDetector podłączony dla:", eggModel.Name)
end)
