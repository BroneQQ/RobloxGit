-- === InventoryManager v3.0 ===
-- SKOPIUJ TO DO: StarterGui/InventoryGui/InventoryManager jako LocalScript

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local eggInventory = player:WaitForChild("EggInventory")

local inventoryGui = script.Parent
local hotbar = inventoryGui:WaitForChild("EggHotbar")
local templateButton = hotbar:WaitForChild("EggButtonTemplate")

-- ⚠️ WAŻNE: WYPEŁNIJ TĘ MAPĘ ID obrazków z Roblox
-- Idź na create.roblox.com, wrzuć obrazki i skopiuj ID
local BRAINROT_IMAGE_IDS = {
    ["Common_BrainrotA"] = "rbxasset://textures/face.png", -- ZMIEŃ NA PRAWDZIWE ID!
    ["Common_BrainrotB"] = "rbxasset://textures/face.png", -- ZMIEŃ NA PRAWDZIWE ID!
    ["Rare_BrainrotA"] = "rbxasset://textures/face.png", -- ZMIEŃ NA PRAWDZIWE ID!
    ["Epic_BrainrotA"] = "rbxasset://textures/face.png", -- ZMIEŃ NA PRAWDZIWE ID!
    ["Legendary_BrainrotA"] = "rbxasset://textures/face.png" -- ZMIEŃ NA PRAWDZIWE ID!
    -- Dodaj tutaj wszystkie swoje Brainroty z odpowiednimi ID obrazków
    -- Format: "rbxassetid://1234567890"
}

local isPlacing, eggToPlaceName, placementGhost = false, nil, nil
local placeRequestEvent = ReplicatedStorage:WaitForChild("PlaceEggRequest")

-- System inwentarza
local MAX_HOTBAR_SLOTS = 9
local BASE_BACKPACK_SLOTS = 20  -- Podstawowe sloty backpack
local PREMIUM_BACKPACK_SLOTS = 10 -- Dodatkowe sloty za Robux
local ROBUX_BACKPACK_COST = 199  -- Koszt rozszerzenia w Robux

-- Sprawdź czy gracz ma premium backpack (GamePass)
local MarketplaceService = game:GetService("MarketplaceService")
local gamePassId = 123456789 -- ZMIEŃ NA PRAWDZIWE ID GAMEPASS

local function hasBackpackUpgrade()
    local success, hasGamePass = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamePassId)
    end)
    return success and hasGamePass
end

local function getTotalBackpackSlots()
    local baseSlots = BASE_BACKPACK_SLOTS
    if hasBackpackUpgrade() then
        return baseSlots + PREMIUM_BACKPACK_SLOTS
    end
    return baseSlots
end

function refreshHotbar()
    print("--- Rozpoczęto odświeżanie hotbaru ---")

    -- Usuń WSZYSTKIE stare przyciski (oprócz template)
    local childrenToRemove = {}
    for _, c in ipairs(hotbar:GetChildren()) do
        if c:IsA("TextButton") and c.Name ~= "EggButtonTemplate" then
            table.insert(childrenToRemove, c)
        elseif c:IsA("UIGridLayout") or c:IsA("UIListLayout") then
            -- Zostaw layout objects
        else
            -- Usuń inne niepotrzebne obiekty
            if c.Name ~= "EggButtonTemplate" and not c:IsA("UIBase") then
                table.insert(childrenToRemove, c)
            end
        end
    end

    -- Usuń wszystkie znalezione obiekty
    for _, obj in ipairs(childrenToRemove) do
        print("🗑️ Usuwam stary obiekt:", obj.Name, obj.ClassName)
        obj:Destroy()
    end

    -- Poczekaj na usunięcie
    wait(0.1)

    local allEggs = {}
    for _, e in ipairs(eggInventory:GetChildren()) do
        table.insert(allEggs, e)
    end

    -- Sortuj jajka alfabetycznie dla stałej kolejności
    table.sort(allEggs, function(a, b) return a.Name < b.Name end)

    print("🥚 Znaleziono jajka:", #allEggs)
    for i, egg in ipairs(allEggs) do
        print("  " .. i .. ":", egg.Name)
    end

    -- Sprawdź czy template istnieje
    if not templateButton or not templateButton.Parent then
        print("❌ BŁĄD: EggButtonTemplate nie istnieje lub został usunięty!")
        return
    end

    -- Twórz przyciski tylko dla pierwszych 9 jajek
    for i = 1, math.min(#allEggs, MAX_HOTBAR_SLOTS) do
        local e = allEggs[i]
        local nB = templateButton:Clone()
        nB.Name = "HotbarSlot_" .. i -- Unikalna nazwa
        nB:SetAttribute("EggName", e.Name) -- Zapisz prawdziwą nazwę jajka
        nB:SetAttribute("SlotNumber", i) -- Zapisz numer slotu

        print("🥚 Tworzę przycisk", i, "dla:", e.Name)

        -- Ustaw tekst przycisku - po prostu numer slotu
        nB.Text = tostring(i)
        nB.TextScaled = true
        nB.Font = Enum.Font.GothamBold
        nB.TextColor3 = Color3.new(1, 1, 1)

        -- Spróbuj znaleźć elementy UI (jeśli istnieją)
        local eN = nB:FindFirstChild("EggNameLabel")
        local sN = nB:FindFirstChild("SlotNumberLabel")
        local eI = nB:FindFirstChild("EggIcon")

        if eN then
            eN.Text = string.split(e.Name, "_")[2] or e.Name
            print("📝 Ustawiono nazwę:", eN.Text)
        end

        if sN then
            sN.Text = tostring(i)
            print("📊 Ustawiono numer slotu:", i)
        end

        if eI then
            local imageId = BRAINROT_IMAGE_IDS[e.Name]
            if imageId and imageId ~= "" then
                eI.Image = imageId
            else
                eI.Image = "rbxasset://textures/face.png"
            end
        end

        nB.Visible = true
        nB.Parent = hotbar

        -- Dodaj obsługę kliknięcia
        nB.MouseButton1Click:Connect(function()
            local eggName = nB:GetAttribute("EggName")
            print("🖱️ Kliknięto slot", i, ":", eggName)
            if not isPlacing then
                isPlacing, eggToPlaceName = true, eggName
                print("🎮 Rozpoczęto sadzenie:", eggName)
            else
                cancelPlacing()
                print("❌ Anulowano sadzenie")
            end
        end)
    end

    local totalEggs = #allEggs
    local hotbarEggs = math.min(totalEggs, MAX_HOTBAR_SLOTS)
    local backpackEggs = math.max(0, totalEggs - MAX_HOTBAR_SLOTS)
    local maxBackpackSlots = getTotalBackpackSlots()
    local maxTotalSlots = MAX_HOTBAR_SLOTS + maxBackpackSlots
    local hasUpgrade = hasBackpackUpgrade()

    -- Ukryj hotbar gdy brak jajek
    if totalEggs == 0 then
        hotbar.Visible = false
        print("🔒 Hotbar ukryty - brak jajek")
    else
        hotbar.Visible = true
        print("👁️ Hotbar widoczny - jajka:", hotbarEggs)
    end

    print("--- Zakończono odświeżanie hotbaru ---")
    print("📊 Hotbar slots:", hotbarEggs .. "/" .. MAX_HOTBAR_SLOTS)
    print("🎒 Backpack slots:", backpackEggs .. "/" .. maxBackpackSlots)
    print("💎 Premium backpack:", hasUpgrade and "ACTIVE" or "AVAILABLE (+10 slots for " .. ROBUX_BACKPACK_COST .. " Robux)")
    print("🥚 Total eggs:", totalEggs .. "/" .. maxTotalSlots)

    -- Sprawdź czy gracz przekroczył limit
    if totalEggs > maxTotalSlots then
        print("⚠️ WARNING: Gracz ma więcej jajek niż slotów! Nadmiar:", totalEggs - maxTotalSlots)
        print("💡 Sugestia: Kup premium backpack lub sprzedaj niektóre jajka")
        print("🔑 NACIŚNIJ F2 aby otworzyć sklep GamePass!")
    end
end

function updateGhost()
    if isPlacing and eggToPlaceName then
        if not placementGhost then
            local r = string.split(eggToPlaceName, "_")[1]
            local t = ReplicatedStorage.Eggs:FindFirstChild("Egg_" .. r)
            if t then
                placementGhost = t:Clone()
                placementGhost.Parent = workspace
                for _, p in ipairs(placementGhost:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.Transparency, p.CanCollide, p.Anchored, p.CanQuery = 0.5, false, true, false
                    end
                end
            end
        end

        if placementGhost and mouse.Target then
            placementGhost:SetPrimaryPartCFrame(CFrame.new(mouse.Hit.Position))
        end
    end
end

function cancelPlacing()
    if isPlacing then
        isPlacing, eggToPlaceName = false, nil
    end
    if placementGhost then
        placementGhost:Destroy()
        placementGhost = nil
    end
end

eggInventory.ChildAdded:Connect(refreshHotbar)
eggInventory.ChildRemoved:Connect(refreshHotbar)

templateButton.Visible = false

-- Funkcja debugowania hotbara
local function debugHotbar()
    print("🔍 === DEBUG HOTBAR ===")
    print("Hotbar visible:", hotbar.Visible)
    print("Hotbar children count:", #hotbar:GetChildren())
    for _, child in ipairs(hotbar:GetChildren()) do
        if child:IsA("TextButton") then
            print("  Button:", child.Name, "Visible:", child.Visible, "SlotNumber:", child:GetAttribute("SlotNumber"))
        end
    end
    print("========================")
end

-- Dodaj klawisze F1 i F2
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- F1 - Debug Hotbar
    if input.KeyCode == Enum.KeyCode.F1 then
        debugHotbar()
        return
    end

    -- F2 - Otwórz GamePass Shop
    if input.KeyCode == Enum.KeyCode.F2 then
        print("🛒 Otwieranie GamePass Shop...")
        local showBackpackPromptEvent = game.ReplicatedStorage:FindFirstChild("ShowBackpackUpgradePrompt")
        if showBackpackPromptEvent then
            local player = game.Players.LocalPlayer
            local backpackLevel = player:FindFirstChild("BackpackLevel")
            local currentLevel = backpackLevel and backpackLevel.Value or 0

            if currentLevel < 7 then -- Jeśli nie maksymalny poziom
                local nextLevel = currentLevel + 1
                local cost = 199 + (nextLevel - 1) * 50
                local baseSlots = 29
                local currentSlots = baseSlots + (currentLevel * 10)
                local nextSlots = baseSlots + (nextLevel * 10)

                -- Symuluj event z serwera (LocalScript nie może FireClient)
                showBackpackPromptEvent.OnClientEvent:Fire({
                    currentLevel = currentLevel,
                    nextLevel = nextLevel,
                    currentSlots = currentSlots,
                    nextSlots = nextSlots,
                    extraSlots = 10,
                    cost = cost,
                    maxLevel = 7
                })
                print("💎 Pokazano GamePass prompt")
            else
                print("🏆 Masz już maksymalny poziom!")
            end
        else
            warn("❌ GamePass system nie znaleziony!")
        end
        return
    end
end)

refreshHotbar()

mouse.Button1Down:Connect(function()
    if isPlacing and eggToPlaceName and mouse.Target then
        local p = workspace:FindFirstChild(player.Name.."_Plot")
        if p and mouse.Target:IsDescendantOf(p) then
            placeRequestEvent:FireServer(eggToPlaceName, mouse.Hit.Position)
            cancelPlacing()
        end
    end
end)

mouse.Button2Down:Connect(function()
    cancelPlacing()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

    local keyCode = input.KeyCode
    local slotNumber = nil

    -- Sprawdź klawisze 1-9 (główna klawiatura)
    if keyCode == Enum.KeyCode.One then slotNumber = 1
    elseif keyCode == Enum.KeyCode.Two then slotNumber = 2
    elseif keyCode == Enum.KeyCode.Three then slotNumber = 3
    elseif keyCode == Enum.KeyCode.Four then slotNumber = 4
    elseif keyCode == Enum.KeyCode.Five then slotNumber = 5
    elseif keyCode == Enum.KeyCode.Six then slotNumber = 6
    elseif keyCode == Enum.KeyCode.Seven then slotNumber = 7
    elseif keyCode == Enum.KeyCode.Eight then slotNumber = 8
    elseif keyCode == Enum.KeyCode.Nine then slotNumber = 9
    -- Sprawdź klawisze numeryczne (numpad)
    elseif keyCode == Enum.KeyCode.KeypadOne then slotNumber = 1
    elseif keyCode == Enum.KeyCode.KeypadTwo then slotNumber = 2
    elseif keyCode == Enum.KeyCode.KeypadThree then slotNumber = 3
    elseif keyCode == Enum.KeyCode.KeypadFour then slotNumber = 4
    elseif keyCode == Enum.KeyCode.KeypadFive then slotNumber = 5
    elseif keyCode == Enum.KeyCode.KeypadSix then slotNumber = 6
    elseif keyCode == Enum.KeyCode.KeypadSeven then slotNumber = 7
    elseif keyCode == Enum.KeyCode.KeypadEight then slotNumber = 8
    elseif keyCode == Enum.KeyCode.KeypadNine then slotNumber = 9
    end

    if slotNumber then
        print("🎯 Naciśnięto klawisz:", slotNumber)

        local targetButton = nil
        for _, child in ipairs(hotbar:GetChildren()) do
            if child:IsA("TextButton") and child.Visible and child.Name:find("HotbarSlot_") then
                local slotNum = child:GetAttribute("SlotNumber")
                print("🔍 Sprawdzam przycisk:", child.Name, "SlotNumber:", slotNum or "BRAK")
                if slotNum == slotNumber then
                    targetButton = child
                    print("✅ ZNALEZIONO dopasowanie!")
                    break
                end
            end
        end

        if targetButton then
            local eggName = targetButton:GetAttribute("EggName")
            print("✅ Znaleziono przycisk dla slotu", slotNumber, ":", eggName)
            if not isPlacing then
                isPlacing, eggToPlaceName = true, eggName
                print("🎮 Rozpoczęto sadzenie:", eggName)
            else
                cancelPlacing()
                print("❌ Anulowano sadzenie")
            end
        else
            print("❌ Nie znaleziono przycisku dla slotu", slotNumber)
        end
    end
end)

RunService.RenderStepped:Connect(updateGhost)

-- Funkcje backpack
local function canAddEgg()
    local totalEggs = #eggInventory:GetChildren()
    local maxSlots = MAX_HOTBAR_SLOTS + getTotalBackpackSlots()
    return totalEggs < maxSlots
end

local function promptBackpackUpgrade()
    if not hasBackpackUpgrade() then
        print("💎 Backpack pełny! Kup rozszerzenie za " .. ROBUX_BACKPACK_COST .. " Robux")

        -- Można dodać GUI prompt tutaj
        local success, errorMessage = pcall(function()
            MarketplaceService:PromptGamePassPurchase(player, gamePassId)
        end)

        if not success then
            print("❌ Błąd przy otwieraniu sklepu:", errorMessage)
        end
    end
end

-- Event handler dla GamePass purchase
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(playerWhoPrompted, gamePassIdPrompted, wasPurchased)
    if playerWhoPrompted == player and gamePassIdPrompted == gamePassId then
        if wasPurchased then
            print("🎉 Premium Backpack kupiony! +10 dodatkowych slotów!")
            refreshHotbar() -- Odśwież UI żeby pokazać nowe sloty
        else
            print("❌ Zakup anulowany")
        end
    end
end)

-- Funkcja sprawdzająca czy można dodać jajko (do użycia przez inne skrypty)
_G.CanAddEggToInventory = canAddEgg
_G.PromptBackpackUpgrade = promptBackpackUpgrade

print("✅ Inventory Manager loaded with backpack system")
print("📊 Max slots: " .. (MAX_HOTBAR_SLOTS + getTotalBackpackSlots()))
print("💎 Premium backpack:", hasBackpackUpgrade() and "OWNED" or "AVAILABLE")
