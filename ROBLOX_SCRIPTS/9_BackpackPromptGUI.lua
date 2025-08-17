-- === BackpackPromptGUI v1.0 ===
-- SKOPIUJ TO DO: StarterPlayerScripts > BackpackPromptGUI (LocalScript)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for RemoteEvents
local showBackpackPromptEvent = ReplicatedStorage:WaitForChild("ShowBackpackUpgradePrompt")
local purchaseBackpackEvent = ReplicatedStorage:WaitForChild("PurchaseBackpackUpgrade")

-- Stwórz GUI
local function createBackpackPromptGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BackpackPromptGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Parent = screenGui
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(1, 0.8, 0)
    stroke.Thickness = 3
    stroke.Parent = mainFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🎒 BACKPACK UPGRADE!"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Description
    local description = Instance.new("TextLabel")
    description.Name = "Description"
    description.Size = UDim2.new(1, -40, 0, 80)
    description.Position = UDim2.new(0, 20, 0, 60)
    description.BackgroundTransparency = 1
    description.Text = "Osiągnąłeś limit inwentarza!\nKup następny poziom i otrzymaj +10 dodatkowych slotów!"
    description.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    description.TextScaled = true
    description.Font = Enum.Font.Gotham
    description.TextWrapped = true
    description.Parent = mainFrame
    
    -- Stats Frame
    local statsFrame = Instance.new("Frame")
    statsFrame.Name = "StatsFrame"
    statsFrame.Size = UDim2.new(1, -40, 0, 60)
    statsFrame.Position = UDim2.new(0, 20, 0, 150)
    statsFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    statsFrame.BorderSizePixel = 0
    statsFrame.Parent = mainFrame
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 8)
    statsCorner.Parent = statsFrame
    
    local statsText = Instance.new("TextLabel")
    statsText.Name = "StatsText"
    statsText.Size = UDim2.new(1, -20, 1, 0)
    statsText.Position = UDim2.new(0, 10, 0, 0)
    statsText.BackgroundTransparency = 1
    statsText.Text = "Poziom 0: 29 slotów\nPoziom 1: 39 slotów (+10)"
    statsText.TextColor3 = Color3.new(0.8, 1, 0.8)
    statsText.TextScaled = true
    statsText.Font = Enum.Font.GothamMedium
    statsText.Parent = statsFrame
    
    -- Buy Button
    local buyButton = Instance.new("TextButton")
    buyButton.Name = "BuyButton"
    buyButton.Size = UDim2.new(0, 150, 0, 40)
    buyButton.Position = UDim2.new(0.5, -75, 0, 230)
    buyButton.BackgroundColor3 = Color3.new(0, 0.8, 0)
    buyButton.BorderSizePixel = 0
    buyButton.Text = "💎 KUP ZA 199 ROBUX"
    buyButton.TextColor3 = Color3.new(1, 1, 1)
    buyButton.TextScaled = true
    buyButton.Font = Enum.Font.GothamBold
    buyButton.Parent = mainFrame
    
    local buyCorner = Instance.new("UICorner")
    buyCorner.CornerRadius = UDim.new(0, 8)
    buyCorner.Parent = buyButton
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 10)
    closeButton.BackgroundColor3 = Color3.new(0.8, 0, 0)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 15)
    closeCorner.Parent = closeButton
    
    return screenGui, mainFrame, buyButton, closeButton, statsText, title, description
end

-- Stwórz GUI
local gui, mainFrame, buyButton, closeButton, statsText, title, description = createBackpackPromptGUI()

-- Zmienna przechowująca dane aktualnego upgrade'u
local currentUpgradeData = nil

-- Funkcje animacji
local function showGUI()
    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 400, 0, 300),
        Position = UDim2.new(0.5, -200, 0.5, -150)
    })
    tween:Play()
end

local function hideGUI()
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tween:Play()
    
    tween.Completed:Connect(function()
        mainFrame.Visible = false
    end)
end

-- Event handlers
buyButton.MouseButton1Click:Connect(function()
    if currentUpgradeData and currentUpgradeData.nextLevel then
        print("💎 Gracz klika 'Kup Level", currentUpgradeData.nextLevel .. "'")
        purchaseBackpackEvent:FireServer(currentUpgradeData.nextLevel)
        hideGUI()
    end
end)

closeButton.MouseButton1Click:Connect(function()
    print("❌ Gracz zamyka prompt")
    hideGUI()
end)

-- Obsługa eventów z serwera
showBackpackPromptEvent.OnClientEvent:Connect(function(data)
    if data.type == "level_activated" then
        print("🎉", data.message)
        -- Można dodać notification GUI
    elseif data.type == "error" then
        print("❌", data.message)
    elseif data.type == "cancelled" then
        print("⚠️", data.message)
    elseif data.type == "max_level" then
        -- Pokaż info o maksymalnym poziomie
        title.Text = "🏆 MAKSYMALNY POZIOM!"
        description.Text = data.message
        statsText.Text = "Gratulacje! Masz już 99 slotów!"
        buyButton.Visible = false
        showGUI()
        print("🏆 Maksymalny poziom osiągnięty")
    else
        -- Pokaż prompt zakupu kolejnego poziomu
        currentUpgradeData = data
        
        if data.currentLevel and data.nextLevel and data.cost then
            title.Text = "🎒 BACKPACK UPGRADE!"
            description.Text = "Osiągnąłeś limit inwentarza!\nKup następny poziom i otrzymaj +10 dodatkowych slotów!"
            
            statsText.Text = string.format(
                "Poziom %d: %d slotów\nPoziom %d: %d slotów (+%d)",
                data.currentLevel,
                data.currentSlots,
                data.nextLevel,
                data.nextSlots,
                data.extraSlots or 10
            )
            
            buyButton.Text = string.format("💎 POZIOM %d ZA %d ROBUX", data.nextLevel, data.cost)
            buyButton.Visible = true
        end
        
        showGUI()
        print("💎 Pokazano prompt Backpack Level", data.nextLevel or "?")
    end
end)

print("✅ BackpackPromptGUI załadowane")
