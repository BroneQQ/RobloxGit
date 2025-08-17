-- === ClickLogic v4 ===
-- Ten skrypt idzie do każdego jajka w ReplicatedStorage/Eggs

local eggModel = script.Parent
local clickDetector = eggModel:WaitForChild("ClickDetector")
local ServerStorage = game:GetService("ServerStorage")

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
    local oV = eggModel:WaitForChild("Owner")
    if not oV or oV.Value ~= playerWhoClicked then return end
    
    local pB = BRAINROT_MODEL_NAME_MAP[eggModel.Name]
    if not pB then return end
    
    local rI = math.random(1, #pB)
    local sBN = pB[rI]
    
    local eI = playerWhoClicked:WaitForChild("EggInventory")
    if not eI then return end
    
    local item = Instance.new("StringValue")
    item.Name = sBN
    item.Parent = eI
    
    local pD = playerWhoClicked:WaitForChild("PityData")
    if eggModel.Name == "Egg_Legendary" then
        pD.legendaryPity.Value, pD.epicPity.Value = 0, 0
    elseif eggModel.Name == "Egg_Epic" then
        pD.epicPity.Value = 0
    end
    
    eggModel:Destroy()
end

clickDetector.MouseClick:Connect(onEggClicked)
