-- === InventoryManager v3.0 ===
-- Ten skrypt idzie do StarterGui/InventoryGui jako LocalScript

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

-- WYPEŁNIJ TĘ MAPĘ ID obrazków z Roblox
local BRAINROT_IMAGE_IDS = {
    ["Common_BrainrotA"] = "rbxasset://textures/face.png", -- Przykład
    ["Common_BrainrotB"] = "rbxasset://textures/face.png", -- Przykład
    ["Rare_BrainrotA"] = "rbxasset://textures/face.png", -- Przykład
    ["Epic_BrainrotA"] = "rbxasset://textures/face.png", -- Przykład
    ["Legendary_BrainrotA"] = "rbxasset://textures/face.png" -- Przykład
    -- Dodaj tutaj wszystkie swoje Brainroty z odpowiednimi ID obrazków
}

local isPlacing, eggToPlaceName, placementGhost = false, nil, nil
local placeRequestEvent = ReplicatedStorage:WaitForChild("PlaceEggRequest")

function refreshHotbar()
    for _, c in ipairs(hotbar:GetChildren()) do
        if c:IsA("TextButton") and c.Name ~= "EggButtonTemplate" then
            c:Destroy()
        end
    end
    
    local cnt = 0
    for _, e in ipairs(eggInventory:GetChildren()) do
        cnt = cnt + 1
        local nB = templateButton:Clone()
        nB.Name = e.Name
        
        local eN, sN = nB:FindFirstChild("EggNameLabel"), nB:FindFirstChild("SlotNumberLabel")
        if eN then
            eN.Text = string.split(e.Name, "_")[2] or e.Name
        end
        if sN then
            sN.Text = tostring(cnt)
        end
        
        local eI = nB:FindFirstChild("EggIcon")
        if eI then
            eI.Image = BRAINROT_IMAGE_IDS[e.Name] or ""
        end
        
        nB.Visible, nB.Parent = true, hotbar
        nB.MouseButton1Click:Connect(function()
            if not isPlacing then
                isPlacing, eggToPlaceName = true, e.Name
            end
        end)
    end
    
    hotbar.Visible = (cnt > 0)
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

UserInputService.InputBegan:Connect(function(i, g)
    if g then return end
    if i.UserInputType ~= Enum.UserInputType.Keyboard then return end
    
    local v = i.KeyCode.Value
    local n = nil
    
    if v >= 49 and v <= 57 then
        n = v - 48
    elseif v >= 97 and v <= 105 then
        n = v - 96
    end
    
    if n then
        local b
        for _, c in ipairs(hotbar:GetChildren()) do
            if c:IsA("TextButton") and c.Visible then
                local l = c:FindFirstChild("SlotNumberLabel")
                if l and l.Text == tostring(n) then
                    b = c
                    break
                end
            end
        end
        
        if b then
            if not isPlacing then
                isPlacing, eggToPlaceName = true, b.Name
            else
                cancelPlacing()
            end
        end
    end
end)

RunService.RenderStepped:Connect(updateGhost)
