-- === GamePassHandler v1.0 ===
-- SKOPIUJ TO DO: ServerScriptService > GamePassHandler (Script)

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- WAŻNE: ZMIEŃ NA PRAWDZIWE ID GAMEPASS'ÓW!
-- System 7 poziomów backpack upgrade
local BACKPACK_GAMEPASS_IDS = {
    [1] = 123456789, -- Poziom 1: +10 slotów (39 total) - 199 Robux
    [2] = 123456790, -- Poziom 2: +10 slotów (49 total) - 249 Robux
    [3] = 123456791, -- Poziom 3: +10 slotów (59 total) - 299 Robux
    [4] = 123456792, -- Poziom 4: +10 slotów (69 total) - 349 Robux
    [5] = 123456793, -- Poziom 5: +10 slotów (79 total) - 399 Robux
    [6] = 123456794, -- Poziom 6: +10 slotów (89 total) - 449 Robux
    [7] = 123456795  -- Poziom 7: +10 slotów (99 total) - 499 Robux
}

-- Koszty dla każdego poziomu
local BACKPACK_COSTS = {
    [1] = 199, [2] = 249, [3] = 299, [4] = 349,
    [5] = 399, [6] = 449, [7] = 499
}

-- Stwórz RemoteEvent dla prompt GUI
local showBackpackPromptEvent = Instance.new("RemoteEvent")
showBackpackPromptEvent.Name = "ShowBackpackUpgradePrompt"
showBackpackPromptEvent.Parent = ReplicatedStorage

local purchaseBackpackEvent = Instance.new("RemoteEvent")
purchaseBackpackEvent.Name = "PurchaseBackpackUpgrade"
purchaseBackpackEvent.Parent = ReplicatedStorage

-- Funkcja sprawdzająca najwyższy poziom GamePass gracza
local function checkHighestGamePassLevel(player)
    local highestLevel = 0

    for level = 1, 7 do
        local gamePassId = BACKPACK_GAMEPASS_IDS[level]
        if gamePassId then
            local success, hasGamePass = pcall(function()
                return MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamePassId)
            end)

            if success and hasGamePass then
                highestLevel = level
            end
        end
    end

    return highestLevel
end

-- Funkcja aktywująca poziom Backpack
local function activateBackpackLevel(player, level)
    if player:FindFirstChild("BackpackLevel") then
        player.BackpackLevel.Value = level
        local totalSlots = 29 + (level * 10)

        print("✅ Backpack Level", level, "aktywowany dla gracza:", player.Name, "(" .. totalSlots .. " slotów)")

        -- Wyślij update do klienta
        showBackpackPromptEvent:FireClient(player, {
            type = "level_activated",
            level = level,
            totalSlots = totalSlots,
            message = "Backpack Level " .. level .. " aktywowany! (" .. totalSlots .. " slotów)"
        })

        return true
    end
    return false
end

-- Event handler dla próby zakupu
purchaseBackpackEvent.OnServerEvent:Connect(function(player, targetLevel)
    targetLevel = targetLevel or 1
    print("💎 Gracz", player.Name, "próbuje kupić Backpack Level", targetLevel)

    -- Sprawdź czy może kupić ten poziom
    local currentLevel = player.BackpackLevel.Value
    if targetLevel <= currentLevel then
        print("⚠️ Gracz już ma ten poziom lub wyższy")
        return
    end

    if targetLevel > 7 then
        print("⚠️ Nieprawidłowy poziom")
        return
    end

    local gamePassId = BACKPACK_GAMEPASS_IDS[targetLevel]
    if not gamePassId then
        print("⚠️ Brak GamePass ID dla poziomu", targetLevel)
        return
    end

    -- Otwórz prompt zakupu
    local success, errorMessage = pcall(function()
        MarketplaceService:PromptGamePassPurchase(player, gamePassId)
    end)

    if not success then
        warn("❌ Błąd przy otwieraniu sklepu:", errorMessage)
        showBackpackPromptEvent:FireClient(player, {
            type = "error",
            message = "Błąd przy otwieraniu sklepu. Spróbuj ponownie."
        })
    end
end)

-- Event handler dla zakończenia zakupu
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, wasPurchased)
    -- Znajdź który poziom został kupiony
    local purchasedLevel = nil
    for level, id in pairs(BACKPACK_GAMEPASS_IDS) do
        if id == gamePassId then
            purchasedLevel = level
            break
        end
    end

    if purchasedLevel then
        if wasPurchased then
            print("🎉 Gracz", player.Name, "kupił Backpack Level", purchasedLevel .. "!")
            activateBackpackLevel(player, purchasedLevel)
        else
            print("❌ Gracz", player.Name, "anulował zakup Backpack Level", purchasedLevel)
            showBackpackPromptEvent:FireClient(player, {
                type = "cancelled",
                message = "Zakup anulowany"
            })
        end
    end
end)

-- Sprawdź GamePass przy dołączeniu gracza
Players.PlayerAdded:Connect(function(player)
    -- Poczekaj na załadowanie danych
    player:WaitForChild("BackpackLevel")

    -- Sprawdź czy gracz ma GamePassy (może kupił wcześniej)
    wait(2) -- Poczekaj na pełne załadowanie

    local currentLevel = player.BackpackLevel.Value
    local highestOwnedLevel = checkHighestGamePassLevel(player)

    if highestOwnedLevel > currentLevel then
        print("🔍 Gracz", player.Name, "ma GamePass Level", highestOwnedLevel, "- aktywuję")
        activateBackpackLevel(player, highestOwnedLevel)
    end
end)

print("✅ GamePassHandler załadowany")
print("🎮 System 7 poziomów Backpack Upgrade")
print("📊 Poziomy: 29→39→49→59→69→79→89→99 slotów")
print("💰 Ceny: 199, 249, 299, 349, 399, 449, 499 Robux")
