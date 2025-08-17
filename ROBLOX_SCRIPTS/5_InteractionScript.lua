-- === InteractionScript v4.0 ===
-- SKOPIUJ TO DO: Każdego modelu Brainrota w ServerStorage/Brainrots jako Script
-- (Common_BrainrotA, Common_BrainrotB, Rare_BrainrotA, Epic_BrainrotA, Legendary_BrainrotA)

local brainrotModel = script.Parent
if not brainrotModel.PrimaryPart then
    warn("BŁĄD w "..brainrotModel.Name..": PrimaryPart nie ustawiony!")
    return
end

local primaryPart = brainrotModel.PrimaryPart
local dataFolder = brainrotModel:WaitForChild("Data")
local levelValue = dataFolder:WaitForChild("Level")
local ownerValue = dataFolder:WaitForChild("Owner")
local humanoid = brainrotModel:FindFirstChild("Humanoid")

-- Konfiguracja
local UPGRADE_COST_MULTIPLIER = 10
local MAX_LEVEL = 30
local GROWTH_INTERVAL = 5
local GROWTH_MULTIPLIER = 1.15
local INCOME_INTERVAL = 5
local COINS_PER_RARITY = {
    ["Common"] = 2,
    ["Rare"] = 5,
    ["Epic"] = 15,
    ["Legendary"] = 30
}
local SELL_PRICE_BASE = 10
local SELL_PRICE_PER_LEVEL = 5
local SELL_HOLD_DURATION = 2
local SELL_ACTIVATION_DISTANCE = 6

-- Sprzedaż
local prompt = Instance.new("ProximityPrompt", primaryPart)
prompt.ActionText = "Sprzedaj"
prompt.KeyboardKeyCode = Enum.KeyCode.E
prompt.HoldDuration = SELL_HOLD_DURATION
prompt.MaxActivationDistance = SELL_ACTIVATION_DISTANCE
prompt.RequiresLineOfSight = false
prompt.Enabled = true
prompt.Style = Enum.ProximityPromptStyle.Custom

local function updatePromptText()
    local sellPrice = SELL_PRICE_BASE + (levelValue.Value * SELL_PRICE_PER_LEVEL)
    prompt:SetAttribute("ObjectName", brainrotModel.Name)
    prompt:SetAttribute("ObjectLevel", levelValue.Value)
    prompt:SetAttribute("SellPrice", sellPrice)
end

levelValue.Changed:Connect(updatePromptText)
updatePromptText()

prompt.Triggered:Connect(function(p)
    if ownerValue.Value == p then
        local l = p:FindFirstChild("leaderstats")
        local c = l and l:FindFirstChild("Coins")
        if not c then return end
        
        local sP = SELL_PRICE_BASE + (levelValue.Value * SELL_PRICE_PER_LEVEL)
        c.Value = c.Value + sP
        brainrotModel:Destroy()
    end
end)

-- Wzrost
local function checkAndApplyGrowth(currentLevel)
    if humanoid and currentLevel > 0 and currentLevel % GROWTH_INTERVAL == 0 then
        local hD = humanoid:GetAppliedDescription()
        hD.HeadScale = hD.HeadScale * GROWTH_MULTIPLIER
        hD.BodyDepthScale = hD.BodyDepthScale * GROWTH_MULTIPLIER
        hD.BodyWidthScale = hD.BodyWidthScale * GROWTH_MULTIPLIER
        hD.BodyHeightScale = hD.BodyHeightScale * GROWTH_MULTIPLIER
        humanoid:ApplyDescription(hD)
    end
end

levelValue.Changed:Connect(checkAndApplyGrowth)

-- Ulepszanie
local clickDetector = Instance.new("ClickDetector", primaryPart)
clickDetector.MouseClick:Connect(function(p)
    if not ownerValue.Value or ownerValue.Value ~= p then return end
    
    local cL = levelValue.Value
    if cL >= MAX_LEVEL then return end
    
    local l = p:FindFirstChild("leaderstats")
    local c = l and l:FindFirstChild("Coins")
    if not c then return end
    
    local uC = (cL + 1) * UPGRADE_COST_MULTIPLIER
    if c.Value >= uC then
        c.Value = c.Value - uC
        levelValue.Value = levelValue.Value + 1
    end
end)

-- Dochód
task.spawn(function()
    if not ownerValue.Value then
        ownerValue.Changed:Wait()
    end
    
    local p = ownerValue.Value
    if not p then return end
    
    local l = p:WaitForChild("leaderstats")
    local c = l and l:FindFirstChild("Coins")
    if not c then return end
    
    local iA = 0
    local r = string.split(brainrotModel.Name, "_")[1]
    if COINS_PER_RARITY[r] then
        iA = COINS_PER_RARITY[r]
    end
    
    if iA > 0 then
        while brainrotModel.Parent do
            task.wait(INCOME_INTERVAL)
            if c then
                c.Value = c.Value + iA
            end
        end
    end
end)

