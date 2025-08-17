-- GameConnector.lua
-- Dodaj ten skrypt do ServerScriptService w Twojej grze Roblox
-- Łączy grę z MCP Server w czasie rzeczywistym

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Konfiguracja
local MCP_SERVER_URL = "http://localhost:3000"
local HEARTBEAT_INTERVAL = 30
local BATCH_SIZE = 10

-- Stan połączenia
local isConnected = false
local lastHeartbeat = 0
local eventQueue = {}
local playerData = {}

-- Funkcje pomocnicze
local function makeRequest(endpoint, method, data)
    method = method or "GET"
    
    local success, response = pcall(function()
        if method == "GET" then
            return HttpService:GetAsync(MCP_SERVER_URL .. endpoint)
        else
            return HttpService:PostAsync(
                MCP_SERVER_URL .. endpoint, 
                HttpService:JSONEncode(data or {}), 
                Enum.HttpContentType.ApplicationJson
            )
        end
    end)
    
    if success then
        local decoded = pcall(function()
            return HttpService:JSONDecode(response)
        end)
        return true, decoded and HttpService:JSONDecode(response) or response
    else
        warn("MCP Request failed: " .. tostring(response))
        return false, response
    end
end

local function queueEvent(eventType, data)
    table.insert(eventQueue, {
        type = eventType,
        data = data,
        timestamp = os.time()
    })
    
    -- Limit queue size
    if #eventQueue > 100 then
        table.remove(eventQueue, 1)
    end
end

local function sendQueuedEvents()
    if #eventQueue == 0 or not isConnected then return end
    
    local batch = {}
    local batchSize = math.min(BATCH_SIZE, #eventQueue)
    
    for i = 1, batchSize do
        table.insert(batch, eventQueue[i])
    end
    
    local success, response = makeRequest("/api/events/batch", "POST", {
        events = batch,
        gameId = game.PlaceId,
        timestamp = os.time()
    })
    
    if success then
        -- Remove sent events from queue
        for i = 1, batchSize do
            table.remove(eventQueue, 1)
        end
        print("📤 Sent " .. batchSize .. " events to MCP Server")
    else
        warn("Failed to send events: " .. tostring(response))
    end
end

-- Połączenie z MCP
local function connectToMCP()
    print("🔌 Connecting to MCP Server...")
    
    local success, response = makeRequest("/health")
    
    if success then
        isConnected = true
        lastHeartbeat = tick()
        print("✅ Connected to MCP Server!")
        
        -- Wyślij początkowy stan gry
        sendInitialGameState()
        
        return true
    else
        isConnected = false
        warn("❌ Failed to connect to MCP Server: " .. tostring(response))
        return false
    end
end

local function sendInitialGameState()
    local gameState = {
        placeId = game.PlaceId,
        players = {},
        brainrots = {},
        config = {
            maxBrainrotsPerPlayer = 40,
            spawnRate = 5,
            rarityChances = {
                Common = 80,
                Rare = 20
            }
        }
    }
    
    -- Zbierz dane graczy
    for _, player in ipairs(Players:GetPlayers()) do
        local data = collectPlayerData(player)
        if data then
            table.insert(gameState.players, data)
        end
    end
    
    -- Policz Brainroty w workspace
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Data") then
            local data = obj:FindFirstChild("Data")
            local owner = data:FindFirstChild("Owner")
            local level = data:FindFirstChild("Level")
            
            if owner and owner.Value and level then
                table.insert(gameState.brainrots, {
                    id = obj:GetDebugId(),
                    name = obj.Name,
                    playerId = tostring(owner.Value.UserId),
                    level = level.Value,
                    position = obj:GetPrimaryPartCFrame().Position
                })
            end
        end
    end
    
    makeRequest("/api/game-state/initial", "POST", gameState)
end

local function collectPlayerData(player)
    if not player or not player.Parent then return nil end
    
    local leaderstats = player:FindFirstChild("leaderstats")
    local pityData = player:FindFirstChild("PityData")
    local eggInventory = player:FindFirstChild("EggInventory")
    
    return {
        playerId = tostring(player.UserId),
        playerName = player.Name,
        coins = leaderstats and leaderstats.Coins.Value or 0,
        pityData = {
            epic = pityData and pityData.epicPity.Value or 0,
            legendary = pityData and pityData.legendaryPity.Value or 0
        },
        eggInventory = eggInventory and #eggInventory:GetChildren() or 0,
        joinTime = playerData[player.UserId] and playerData[player.UserId].joinTime or os.time()
    }
end

-- Event Handlers
local function onPlayerJoined(player)
    playerData[player.UserId] = {
        joinTime = os.time(),
        lastUpdate = os.time()
    }
    
    -- Czekaj na załadowanie danych
    wait(2)
    
    local data = collectPlayerData(player)
    if data then
        queueEvent("player_joined", data)
    end
    
    print("👤 Player " .. player.Name .. " joined - data queued for MCP")
end

local function onPlayerLeft(player)
    local data = collectPlayerData(player)
    if data then
        queueEvent("player_left", data)
    end
    
    playerData[player.UserId] = nil
    print("👋 Player " .. player.Name .. " left - data queued for MCP")
end

local function monitorEggClicks()
    -- Monitor jajka w workspace
    workspace.ChildAdded:Connect(function(child)
        if child.Name:find("Egg_") and child:FindFirstChild("Owner") then
            local owner = child:FindFirstChild("Owner")
            
            -- Monitor kliknięcia
            local clickDetector = child:FindFirstChild("ClickDetector")
            if clickDetector then
                clickDetector.MouseClick:Connect(function(playerWhoClicked)
                    if owner.Value == playerWhoClicked then
                        queueEvent("egg_clicked", {
                            playerId = tostring(playerWhoClicked.UserId),
                            eggType = child.Name,
                            position = child:GetPrimaryPartCFrame().Position,
                            timestamp = os.time()
                        })
                    end
                end)
            end
        end
    end)
end

local function monitorBrainrotSpawns()
    workspace.ChildAdded:Connect(function(child)
        if child:IsA("Model") and child:FindFirstChild("Data") then
            wait(0.1) -- Czekaj na pełne załadowanie
            
            local data = child:FindFirstChild("Data")
            local owner = data:FindFirstChild("Owner")
            local level = data:FindFirstChild("Level")
            
            if owner and owner.Value and level then
                queueEvent("brainrot_spawned", {
                    playerId = tostring(owner.Value.UserId),
                    brainrotId = child:GetDebugId(),
                    brainrotType = child.Name,
                    level = level.Value,
                    position = child:GetPrimaryPartCFrame().Position,
                    timestamp = os.time()
                })
                
                -- Monitor upgrade events
                level.Changed:Connect(function(newLevel)
                    queueEvent("brainrot_upgraded", {
                        playerId = tostring(owner.Value.UserId),
                        brainrotId = child:GetDebugId(),
                        brainrotType = child.Name,
                        newLevel = newLevel,
                        oldLevel = newLevel - 1,
                        timestamp = os.time()
                    })
                end)
                
                -- Monitor sprzedaż (gdy model jest usuwany)
                child.AncestryChanged:Connect(function()
                    if not child.Parent then
                        queueEvent("brainrot_sold", {
                            playerId = tostring(owner.Value.UserId),
                            brainrotId = child:GetDebugId(),
                            brainrotType = child.Name,
                            level = level.Value,
                            timestamp = os.time()
                        })
                    end
                end)
            end
        end
    end)
end

-- Główna pętla
local function mainLoop()
    while true do
        wait(5) -- Co 5 sekund
        
        -- Sprawdź połączenie
        if tick() - lastHeartbeat > HEARTBEAT_INTERVAL then
            if not connectToMCP() then
                wait(10) -- Czekaj przed ponowną próbą
                continue
            end
        end
        
        -- Wyślij wydarzenia z kolejki
        if isConnected then
            sendQueuedEvents()
        end
        
        -- Wyślij aktualizacje danych graczy
        if isConnected and #Players:GetPlayers() > 0 then
            local updates = {}
            for _, player in ipairs(Players:GetPlayers()) do
                local data = collectPlayerData(player)
                if data then
                    table.insert(updates, data)
                end
            end
            
            if #updates > 0 then
                makeRequest("/api/players/update", "POST", {
                    players = updates,
                    timestamp = os.time()
                })
            end
        end
    end
end

-- Inicjalizacja
print("🧠 Brainrot Simulator MCP Connector starting...")

-- Połącz event handlery
Players.PlayerAdded:Connect(onPlayerJoined)
Players.PlayerRemoving:Connect(onPlayerLeft)

-- Rozpocznij monitoring
monitorEggClicks()
monitorBrainrotSpawns()

-- Połącz z MCP Server
connectToMCP()

-- Uruchom główną pętlę
spawn(mainLoop)

print("✅ MCP Connector initialized and running!")
print("🔗 Server URL: " .. MCP_SERVER_URL)
print("📊 Events will be sent in batches of " .. BATCH_SIZE)
