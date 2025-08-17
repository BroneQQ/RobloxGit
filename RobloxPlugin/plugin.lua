-- Brainrot Simulator AI Plugin
-- Connects Roblox Studio with MCP Server for real-time AI assistance

local plugin = plugin or getfenv(0).plugin
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- Configuration
local MCP_SERVER_URL = "http://localhost:3000"
local PLUGIN_NAME = "Brainrot AI Assistant"
local PLUGIN_DESCRIPTION = "AI-powered game management for Brainrot Simulator"

-- Plugin UI
local toolbar = plugin:CreateToolbar("Brainrot AI")
local connectButton = toolbar:CreateButton("Connect AI", "Connect to AI Assistant", "rbxasset://textures/StudioSharedUI/statusSuccess.png")
local analyticsButton = toolbar:CreateButton("Analytics", "View game analytics", "rbxasset://textures/StudioSharedUI/statusInfo.png")
local balanceButton = toolbar:CreateButton("Balance", "AI balance suggestions", "rbxasset://textures/StudioSharedUI/statusWarning.png")

-- State
local isConnected = false
local connectionStatus = "Disconnected"
local lastHeartbeat = 0
local gameAnalytics = {}

-- GUI Creation
local function createMainGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BrainrotAIGui"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
    mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🧠 Brainrot AI Assistant"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeButton
    
    -- Status Section
    local statusFrame = Instance.new("Frame")
    statusFrame.Name = "StatusFrame"
    statusFrame.Size = UDim2.new(1, -20, 0, 80)
    statusFrame.Position = UDim2.new(0, 10, 0, 50)
    statusFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    statusFrame.BorderSizePixel = 0
    statusFrame.Parent = mainFrame
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 8)
    statusCorner.Parent = statusFrame
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -10, 0.5, 0)
    statusLabel.Position = UDim2.new(0, 5, 0, 5)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Connection Status: " .. connectionStatus
    statusLabel.TextColor3 = isConnected and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = statusFrame
    
    local urlLabel = Instance.new("TextLabel")
    urlLabel.Name = "UrlLabel"
    urlLabel.Size = UDim2.new(1, -10, 0.5, 0)
    urlLabel.Position = UDim2.new(0, 5, 0.5, 0)
    urlLabel.BackgroundTransparency = 1
    urlLabel.Text = "Server: " .. MCP_SERVER_URL
    urlLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    urlLabel.TextScaled = true
    urlLabel.Font = Enum.Font.Gotham
    urlLabel.TextXAlignment = Enum.TextXAlignment.Left
    urlLabel.Parent = statusFrame
    
    -- Analytics Section
    local analyticsFrame = Instance.new("ScrollingFrame")
    analyticsFrame.Name = "AnalyticsFrame"
    analyticsFrame.Size = UDim2.new(1, -20, 0, 200)
    analyticsFrame.Position = UDim2.new(0, 10, 0, 140)
    analyticsFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    analyticsFrame.BorderSizePixel = 0
    analyticsFrame.ScrollBarThickness = 6
    analyticsFrame.Parent = mainFrame
    
    local analyticsCorner = Instance.new("UICorner")
    analyticsCorner.CornerRadius = UDim.new(0, 8)
    analyticsCorner.Parent = analyticsFrame
    
    local analyticsLayout = Instance.new("UIListLayout")
    analyticsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    analyticsLayout.Padding = UDim.new(0, 5)
    analyticsLayout.Parent = analyticsFrame
    
    -- Controls Section
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Name = "ControlsFrame"
    controlsFrame.Size = UDim2.new(1, -20, 0, 200)
    controlsFrame.Position = UDim2.new(0, 10, 0, 350)
    controlsFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    controlsFrame.BorderSizePixel = 0
    controlsFrame.Parent = mainFrame
    
    local controlsCorner = Instance.new("UICorner")
    controlsCorner.CornerRadius = UDim.new(0, 8)
    controlsCorner.Parent = controlsFrame
    
    local controlsLayout = Instance.new("UIListLayout")
    controlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    controlsLayout.Padding = UDim.new(0, 10)
    controlsLayout.FillDirection = Enum.FillDirection.Vertical
    controlsLayout.Parent = controlsFrame
    
    -- Control Buttons
    local function createControlButton(name, text, color, callback)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(1, -20, 0, 35)
        button.BackgroundColor3 = color
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextScaled = true
        button.Font = Enum.Font.GothamBold
        button.Parent = controlsFrame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        button.MouseButton1Click:Connect(callback)
        return button
    end
    
    createControlButton("ConnectButton", "🔌 Connect to AI", Color3.fromRGB(100, 200, 100), connectToMCP)
    createControlButton("AnalyzeButton", "📊 Analyze Game", Color3.fromRGB(100, 150, 200), analyzeGame)
    createControlButton("BalanceButton", "⚖️ Get Balance Suggestions", Color3.fromRGB(200, 150, 100), getBalanceSuggestions)
    createControlButton("GenerateButton", "🎲 Generate Content", Color3.fromRGB(150, 100, 200), generateContent)
    
    -- Event Handlers
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Make draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return screenGui, statusLabel, analyticsFrame
end

-- HTTP Request Helper
local function makeRequest(endpoint, method, data)
    method = method or "GET"
    
    local success, response = pcall(function()
        if method == "GET" then
            return HttpService:GetAsync(MCP_SERVER_URL .. endpoint)
        else
            return HttpService:PostAsync(MCP_SERVER_URL .. endpoint, HttpService:JSONEncode(data or {}), Enum.HttpContentType.ApplicationJson)
        end
    end)
    
    if success then
        local decoded = HttpService:JSONDecode(response)
        return true, decoded
    else
        warn("HTTP Request failed: " .. tostring(response))
        return false, response
    end
end

-- MCP Connection Functions
function connectToMCP()
    print("🔌 Attempting to connect to MCP Server...")
    
    local success, response = makeRequest("/health")
    
    if success then
        isConnected = true
        connectionStatus = "Connected ✅"
        lastHeartbeat = tick()
        print("✅ Successfully connected to MCP Server!")
        
        -- Start heartbeat
        startHeartbeat()
        
        -- Send initial game state
        sendGameState()
        
    else
        isConnected = false
        connectionStatus = "Connection Failed ❌"
        print("❌ Failed to connect to MCP Server: " .. tostring(response))
    end
    
    updateUI()
end

function startHeartbeat()
    if isConnected then
        spawn(function()
            while isConnected do
                wait(30) -- Every 30 seconds
                
                local success, response = makeRequest("/health")
                
                if success then
                    lastHeartbeat = tick()
                else
                    isConnected = false
                    connectionStatus = "Connection Lost ❌"
                    updateUI()
                    break
                end
            end
        end)
    end
end

function sendGameState()
    if not isConnected then return end
    
    local gameState = {
        players = {},
        brainrots = {},
        analytics = {
            totalPlayers = #Players:GetPlayers(),
            totalBrainrots = 0,
            timestamp = os.time()
        }
    }
    
    -- Collect player data
    for _, player in ipairs(Players:GetPlayers()) do
        local playerData = {
            playerId = tostring(player.UserId),
            playerName = player.Name,
            coins = player.leaderstats and player.leaderstats.Coins.Value or 0,
            pityData = {
                epic = player.PityData and player.PityData.epicPity.Value or 0,
                legendary = player.PityData and player.PityData.legendaryPity.Value or 0
            }
        }
        table.insert(gameState.players, playerData)
    end
    
    -- Count brainrots in workspace
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Data") then
            gameState.analytics.totalBrainrots = gameState.analytics.totalBrainrots + 1
        end
    end
    
    makeRequest("/api/game-state", "POST", gameState)
end

function analyzeGame()
    if not isConnected then
        print("❌ Not connected to MCP Server")
        return
    end
    
    print("📊 Requesting game analysis...")
    
    local success, response = makeRequest("/api/ai/analyze", "POST", {
        type = "economy",
        data = {}
    })
    
    if success then
        gameAnalytics = response.analysis
        print("✅ Analysis complete!")
        updateAnalyticsDisplay()
    else
        print("❌ Analysis failed: " .. tostring(response))
    end
end

function getBalanceSuggestions()
    if not isConnected then
        print("❌ Not connected to MCP Server")
        return
    end
    
    print("⚖️ Getting AI balance suggestions...")
    
    local success, response = makeRequest("/api/ai/balance", "POST", {})
    
    if success then
        print("✅ Balance suggestions received!")
        print("Suggestions:")
        for _, suggestion in ipairs(response.suggestions) do
            print("- " .. suggestion.type .. ": " .. tostring(suggestion.value) .. " (" .. suggestion.reason .. ")")
        end
    else
        print("❌ Balance request failed: " .. tostring(response))
    end
end

function generateContent()
    if not isConnected then
        print("❌ Not connected to MCP Server")
        return
    end
    
    print("🎲 Generating new content...")
    
    local success, response = makeRequest("/api/ai/generate-content", "POST", {
        type = "brainrot",
        parameters = { rarity = "Rare" }
    })
    
    if success then
        local content = response.content
        print("✅ Generated new Brainrot:")
        print("Name: " .. content.name)
        print("Rarity: " .. content.rarity)
        print("Base Income: " .. content.stats.baseIncome)
        print("Upgrade Cost: " .. content.stats.upgradeCost)
    else
        print("❌ Content generation failed: " .. tostring(response))
    end
end

-- UI Update Functions
local currentGui = nil
local statusLabel = nil
local analyticsFrame = nil

function updateUI()
    if statusLabel then
        statusLabel.Text = "Connection Status: " .. connectionStatus
        statusLabel.TextColor3 = isConnected and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    end
end

function updateAnalyticsDisplay()
    if not analyticsFrame or not gameAnalytics then return end
    
    -- Clear existing analytics
    for _, child in ipairs(analyticsFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    -- Add analytics labels
    local function createAnalyticsLabel(text, value)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 25)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. tostring(value)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = analyticsFrame
    end
    
    if gameAnalytics.playerCount then
        createAnalyticsLabel("👥 Players", gameAnalytics.playerCount)
    end
    if gameAnalytics.totalBrainrots then
        createAnalyticsLabel("🧠 Total Brainrots", gameAnalytics.totalBrainrots)
    end
    if gameAnalytics.averageBrainrotsPerPlayer then
        createAnalyticsLabel("📊 Avg per Player", math.floor(gameAnalytics.averageBrainrotsPerPlayer * 100) / 100)
    end
    if gameAnalytics.economyHealth then
        createAnalyticsLabel("💰 Economy", gameAnalytics.economyHealth)
    end
    
    if gameAnalytics.recommendations then
        for i, rec in ipairs(gameAnalytics.recommendations) do
            createAnalyticsLabel("💡 Tip " .. i, rec)
        end
    end
end

-- Event Monitoring
local function monitorGameEvents()
    -- Monitor player joins
    Players.PlayerAdded:Connect(function(player)
        if isConnected then
            wait(1) -- Wait for leaderstats to load
            
            local playerData = {
                playerId = tostring(player.UserId),
                playerName = player.Name,
                coins = player.leaderstats and player.leaderstats.Coins.Value or 100,
                pityData = {
                    epic = player.PityData and player.PityData.epicPity.Value or 0,
                    legendary = player.PityData and player.PityData.legendaryPity.Value or 0
                }
            }
            
            makeRequest("/api/events/player-joined", "POST", playerData)
        end
    end)
    
    -- Monitor workspace for new brainrots
    workspace.ChildAdded:Connect(function(child)
        if isConnected and child:IsA("Model") and child:FindFirstChild("Data") then
            local data = child:FindFirstChild("Data")
            local owner = data:FindFirstChild("Owner")
            
            if owner and owner.Value then
                local eventData = {
                    playerId = tostring(owner.Value.UserId),
                    brainrotId = child:GetDebugId(),
                    brainrotType = child.Name,
                    position = child:GetPrimaryPartCFrame().Position
                }
                
                makeRequest("/api/events/brainrot-spawned", "POST", eventData)
            end
        end
    end)
end

-- Plugin Button Handlers
connectButton.Click:Connect(function()
    if not currentGui then
        currentGui, statusLabel, analyticsFrame = createMainGui()
        currentGui.Parent = game:GetService("CoreGui")
    end
    connectToMCP()
end)

analyticsButton.Click:Connect(function()
    if not currentGui then
        currentGui, statusLabel, analyticsFrame = createMainGui()
        currentGui.Parent = game:GetService("CoreGui")
    end
    analyzeGame()
end)

balanceButton.Click:Connect(function()
    getBalanceSuggestions()
end)

-- Initialize
print("🧠 Brainrot Simulator AI Plugin loaded!")
print("🔌 Click 'Connect AI' to establish connection with MCP Server")

-- Start monitoring game events
monitorGameEvents()
