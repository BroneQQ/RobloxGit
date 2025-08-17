/**
 * Brainrot Simulator MCP Server
 * Connects AI Assistant with Roblox game for real-time management
 */

import express from 'express';
import cors from 'cors';
import { WebSocketServer } from 'ws';
import http from 'http';
import dotenv from 'dotenv';
import helmet from 'helmet';
import cron from 'node-cron';
import { RateLimiterMemory } from 'rate-limiter-flexible';

// Load environment variables
dotenv.config();

const app = express();
const server = http.createServer(app);
const wss = new WebSocketServer({ server });

// Configuration
const PORT = process.env.PORT || 3000;
const ROBLOX_API_BASE = 'https://apis.roblox.com';

// Rate limiting
const rateLimiter = new RateLimiterMemory({
    keyBy: (req) => req.ip,
    points: 100, // Number of requests
    duration: 60, // Per 60 seconds
});

// Middleware
app.use(helmet());
app.use(cors({
    origin: process.env.ALLOWED_ORIGINS?.split(',') || ['http://localhost:3000'],
    credentials: true
}));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Rate limiting middleware
app.use(async (req, res, next) => {
    try {
        await rateLimiter.consume(req.ip);
        next();
    } catch (rejRes) {
        res.status(429).json({ error: 'Too many requests' });
    }
});

// In-memory storage for game data (replace with database in production)
let gameData = {
    players: new Map(),
    brainrots: new Map(),
    economy: {
        totalCoins: 0,
        averageLevel: 1,
        rarityDistribution: {}
    },
    analytics: {
        sessionsToday: 0,
        eggsClicked: 0,
        brainrotsSpawned: 0,
        upgradesPerformed: 0
    }
};

// WebSocket connections (for real-time communication)
const connections = new Set();

wss.on('connection', (ws) => {
    connections.add(ws);
    console.log('🔌 New WebSocket connection established');
    
    ws.on('message', async (message) => {
        try {
            const data = JSON.parse(message);
            await handleWebSocketMessage(ws, data);
        } catch (error) {
            ws.send(JSON.stringify({ error: 'Invalid message format' }));
        }
    });
    
    ws.on('close', () => {
        connections.delete(ws);
        console.log('🔌 WebSocket connection closed');
    });
});

// Broadcast to all connected clients
function broadcast(data) {
    const message = JSON.stringify(data);
    connections.forEach(ws => {
        if (ws.readyState === ws.OPEN) {
            ws.send(message);
        }
    });
}

// Handle WebSocket messages
async function handleWebSocketMessage(ws, data) {
    switch (data.type) {
        case 'player_joined':
            await handlePlayerJoined(data.payload);
            break;
        case 'egg_clicked':
            await handleEggClicked(data.payload);
            break;
        case 'brainrot_spawned':
            await handleBrainrotSpawned(data.payload);
            break;
        case 'brainrot_upgraded':
            await handleBrainrotUpgraded(data.payload);
            break;
        case 'brainrot_sold':
            await handleBrainrotSold(data.payload);
            break;
        default:
            ws.send(JSON.stringify({ error: 'Unknown message type' }));
    }
}

// Event handlers
async function handlePlayerJoined(data) {
    const { playerId, playerName, coins, pityData } = data;
    
    gameData.players.set(playerId, {
        name: playerName,
        coins: coins,
        pityData: pityData,
        joinTime: new Date(),
        brainrotsOwned: 0
    });
    
    gameData.analytics.sessionsToday++;
    
    broadcast({
        type: 'player_update',
        data: { playerId, playerName, status: 'joined' }
    });
    
    console.log(`👤 Player ${playerName} joined with ${coins} coins`);
}

async function handleEggClicked(data) {
    const { playerId, eggType, brainrotReceived } = data;
    
    gameData.analytics.eggsClicked++;
    
    // Update rarity distribution
    if (!gameData.economy.rarityDistribution[eggType]) {
        gameData.economy.rarityDistribution[eggType] = 0;
    }
    gameData.economy.rarityDistribution[eggType]++;
    
    broadcast({
        type: 'egg_clicked',
        data: { playerId, eggType, brainrotReceived }
    });
    
    console.log(`🥚 Player ${playerId} clicked ${eggType}, got ${brainrotReceived}`);
}

async function handleBrainrotSpawned(data) {
    const { playerId, brainrotId, brainrotType, position } = data;
    
    gameData.brainrots.set(brainrotId, {
        playerId: playerId,
        type: brainrotType,
        level: 1,
        position: position,
        spawnTime: new Date(),
        totalIncome: 0
    });
    
    gameData.analytics.brainrotsSpawned++;
    
    // Update player brainrot count
    const player = gameData.players.get(playerId);
    if (player) {
        player.brainrotsOwned++;
    }
    
    broadcast({
        type: 'brainrot_spawned',
        data: { playerId, brainrotId, brainrotType }
    });
    
    console.log(`🧠 Brainrot ${brainrotType} spawned for player ${playerId}`);
}

async function handleBrainrotUpgraded(data) {
    const { playerId, brainrotId, newLevel, costPaid } = data;
    
    const brainrot = gameData.brainrots.get(brainrotId);
    if (brainrot) {
        brainrot.level = newLevel;
    }
    
    const player = gameData.players.get(playerId);
    if (player) {
        player.coins -= costPaid;
    }
    
    gameData.analytics.upgradesPerformed++;
    gameData.economy.totalCoins -= costPaid;
    
    broadcast({
        type: 'brainrot_upgraded',
        data: { playerId, brainrotId, newLevel, costPaid }
    });
    
    console.log(`⬆️ Brainrot ${brainrotId} upgraded to level ${newLevel}`);
}

async function handleBrainrotSold(data) {
    const { playerId, brainrotId, sellPrice } = data;
    
    gameData.brainrots.delete(brainrotId);
    
    const player = gameData.players.get(playerId);
    if (player) {
        player.coins += sellPrice;
        player.brainrotsOwned--;
    }
    
    gameData.economy.totalCoins += sellPrice;
    
    broadcast({
        type: 'brainrot_sold',
        data: { playerId, brainrotId, sellPrice }
    });
    
    console.log(`💰 Brainrot ${brainrotId} sold for ${sellPrice} coins`);
}

// REST API Endpoints

// Health check
app.get('/health', (req, res) => {
    res.json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        connections: connections.size,
        players: gameData.players.size,
        brainrots: gameData.brainrots.size
    });
});

// Get game analytics
app.get('/api/analytics', (req, res) => {
    res.json({
        analytics: gameData.analytics,
        economy: gameData.economy,
        players: gameData.players.size,
        brainrots: gameData.brainrots.size
    });
});

// Get player data
app.get('/api/players/:playerId', (req, res) => {
    const player = gameData.players.get(req.params.playerId);
    if (!player) {
        return res.status(404).json({ error: 'Player not found' });
    }
    res.json(player);
});

// Get all players
app.get('/api/players', (req, res) => {
    const players = Array.from(gameData.players.entries()).map(([id, data]) => ({
        id,
        ...data
    }));
    res.json(players);
});

// Handle game events from Roblox
app.post('/api/game-event', (req, res) => {
    try {
        const { type, data, gameId, timestamp, events } = req.body;
        
        // Handle batch events
        if (events && Array.isArray(events)) {
            console.log(`📦 Processing ${events.length} batch events`);
            
            for (const event of events) {
                processGameEvent(event.type, event.data);
            }
            
            res.json({ 
                success: true, 
                processed: events.length,
                message: `Processed ${events.length} events`
            });
            return;
        }
        
        // Handle single event
        if (type && data) {
            processGameEvent(type, data);
            console.log(`📡 Processed single event: ${type}`);
            
            res.json({ 
                success: true, 
                type: type,
                message: 'Event processed successfully'
            });
            return;
        }
        
        // Handle connection establishment
        if (type === 'connection_established') {
            console.log(`🎮 Game connected: PlaceId ${gameId}`);
            
            res.json({ 
                success: true, 
                message: 'Connection established',
                serverTime: new Date().toISOString()
            });
            return;
        }
        
        res.status(400).json({ error: 'Invalid event format' });
        
    } catch (error) {
        console.error('Game event error:', error);
        res.status(500).json({ error: 'Failed to process event' });
    }
});

// Process individual game events
function processGameEvent(type, data) {
    switch (type) {
        case 'player_joined':
            handlePlayerJoined(data);
            break;
        case 'player_left':
            handlePlayerLeft(data);
            break;
        case 'egg_clicked':
            handleEggClicked(data);
            break;
        case 'brainrot_spawned':
            handleBrainrotSpawned(data);
            break;
        case 'brainrot_upgraded':
            handleBrainrotUpgraded(data);
            break;
        case 'brainrot_sold':
            handleBrainrotSold(data);
            break;
        default:
            console.log(`⚠️ Unknown event type: ${type}`);
    }
}

// Handle player left event
async function handlePlayerLeft(data) {
    const { playerId, playerName } = data;
    
    if (gameData.players.has(playerId)) {
        gameData.players.delete(playerId);
        
        broadcast({
            type: 'player_update',
            data: { playerId, playerName, status: 'left' }
        });
        
        console.log(`👋 Player ${playerName} left the game`);
    }
}

// Update players endpoint to handle POST requests
app.post('/api/players', (req, res) => {
    try {
        const { players, timestamp } = req.body;
        
        if (players && Array.isArray(players)) {
            // Update player data
            for (const playerData of players) {
                const { playerId } = playerData;
                if (gameData.players.has(playerId)) {
                    const existingPlayer = gameData.players.get(playerId);
                    gameData.players.set(playerId, {
                        ...existingPlayer,
                        ...playerData,
                        lastUpdate: new Date()
                    });
                }
            }
            
            console.log(`📊 Updated data for ${players.length} players`);
            
            res.json({ 
                success: true, 
                updated: players.length,
                message: 'Player data updated'
            });
        } else {
            res.status(400).json({ error: 'Invalid players data format' });
        }
        
    } catch (error) {
        console.error('Player update error:', error);
        res.status(500).json({ error: 'Failed to update player data' });
    }
});

// AI Analysis endpoint
app.post('/api/ai/analyze', async (req, res) => {
    try {
        const { type, data } = req.body;
        
        let analysis = {};
        
        switch (type) {
            case 'economy':
                analysis = analyzeEconomy();
                break;
            case 'player_behavior':
                analysis = analyzePlayerBehavior();
                break;
            case 'balance_suggestions':
                analysis = generateBalanceSuggestions();
                break;
            default:
                return res.status(400).json({ error: 'Unknown analysis type' });
        }
        
        res.json({
            type,
            analysis,
            timestamp: new Date().toISOString()
        });
        
    } catch (error) {
        console.error('AI Analysis error:', error);
        res.status(500).json({ error: 'Analysis failed' });
    }
});

// AI-powered economy balancing
app.post('/api/ai/balance', async (req, res) => {
    try {
        const suggestions = generateBalanceSuggestions();
        
        // Broadcast balance suggestions to game
        broadcast({
            type: 'balance_update',
            data: suggestions
        });
        
        res.json({
            message: 'Balance suggestions sent to game',
            suggestions
        });
        
    } catch (error) {
        console.error('Balance error:', error);
        res.status(500).json({ error: 'Balance update failed' });
    }
});

// Generate new content (Brainrots, events, etc.)
app.post('/api/ai/generate-content', async (req, res) => {
    try {
        const { type, parameters } = req.body;
        
        let content = {};
        
        switch (type) {
            case 'brainrot':
                content = generateNewBrainrot(parameters);
                break;
            case 'event':
                content = generateGameEvent(parameters);
                break;
            default:
                return res.status(400).json({ error: 'Unknown content type' });
        }
        
        res.json({
            type,
            content,
            timestamp: new Date().toISOString()
        });
        
    } catch (error) {
        console.error('Content generation error:', error);
        res.status(500).json({ error: 'Content generation failed' });
    }
});

// AI Analysis Functions
function analyzeEconomy() {
    const totalPlayers = gameData.players.size;
    const totalBrainrots = gameData.brainrots.size;
    const avgBrainrotsPerPlayer = totalPlayers > 0 ? totalBrainrots / totalPlayers : 0;
    
    return {
        playerCount: totalPlayers,
        totalBrainrots: totalBrainrots,
        averageBrainrotsPerPlayer: avgBrainrotsPerPlayer,
        economyHealth: avgBrainrotsPerPlayer > 5 ? 'healthy' : 'needs_boost',
        rarityDistribution: gameData.economy.rarityDistribution,
        recommendations: generateEconomyRecommendations(avgBrainrotsPerPlayer)
    };
}

function analyzePlayerBehavior() {
    const players = Array.from(gameData.players.values());
    
    return {
        averageSessionTime: calculateAverageSessionTime(players),
        retentionRate: calculateRetentionRate(players),
        spendingPatterns: analyzeSpendingPatterns(players),
        engagementLevel: calculateEngagementLevel()
    };
}

function generateBalanceSuggestions() {
    const analysis = analyzeEconomy();
    const suggestions = [];
    
    if (analysis.economyHealth === 'needs_boost') {
        suggestions.push({
            type: 'spawn_rate_increase',
            value: 1.2,
            reason: 'Low brainrot count per player'
        });
    }
    
    // Check rarity distribution
    const rarities = analysis.rarityDistribution;
    const commonPercent = (rarities.Egg_Common || 0) / gameData.analytics.eggsClicked;
    
    if (commonPercent > 0.9) {
        suggestions.push({
            type: 'pity_adjustment',
            value: { epic: 40, legendary: 150 },
            reason: 'Too many common drops'
        });
    }
    
    return suggestions;
}

function generateNewBrainrot(parameters) {
    const rarities = ['Common', 'Rare', 'Epic', 'Legendary'];
    const themes = ['Sigma', 'Skibidi', 'Ohio', 'Gyatt', 'Rizz', 'Mewing'];
    
    return {
        name: `${themes[Math.floor(Math.random() * themes.length)]}_Brainrot${Date.now()}`,
        rarity: parameters.rarity || rarities[Math.floor(Math.random() * rarities.length)],
        stats: {
            baseIncome: Math.floor(Math.random() * 10) + 1,
            upgradeCost: Math.floor(Math.random() * 50) + 10,
            maxLevel: 30
        },
        description: `AI-generated ${parameters.rarity || 'random'} Brainrot`
    };
}

function generateGameEvent(parameters) {
    const events = [
        {
            name: 'Double Income Hour',
            type: 'income_boost',
            multiplier: 2,
            duration: 3600000 // 1 hour
        },
        {
            name: 'Rare Drop Boost',
            type: 'drop_rate_boost',
            affectedRarities: ['Rare', 'Epic'],
            multiplier: 1.5,
            duration: 1800000 // 30 minutes
        },
        {
            name: 'Upgrade Discount',
            type: 'cost_reduction',
            reduction: 0.5,
            duration: 2700000 // 45 minutes
        }
    ];
    
    return events[Math.floor(Math.random() * events.length)];
}

// Helper functions
function calculateAverageSessionTime(players) {
    if (players.length === 0) return 0;
    
    const now = new Date();
    const totalTime = players.reduce((sum, player) => {
        return sum + (now - player.joinTime);
    }, 0);
    
    return totalTime / players.length / 1000 / 60; // minutes
}

function calculateRetentionRate(players) {
    // Simplified retention calculation
    const activeThreshold = 300000; // 5 minutes
    const now = new Date();
    
    const activePlayers = players.filter(player => {
        return (now - player.joinTime) > activeThreshold;
    });
    
    return players.length > 0 ? activePlayers.length / players.length : 0;
}

function analyzeSpendingPatterns(players) {
    return {
        averageCoinsSpent: gameData.analytics.upgradesPerformed * 15, // rough estimate
        upgradeFrequency: gameData.analytics.upgradesPerformed / Math.max(players.length, 1),
        economicActivity: gameData.analytics.upgradesPerformed > 10 ? 'high' : 'low'
    };
}

function calculateEngagementLevel() {
    const actions = gameData.analytics.eggsClicked + gameData.analytics.upgradesPerformed;
    const players = gameData.players.size;
    
    const actionsPerPlayer = players > 0 ? actions / players : 0;
    
    if (actionsPerPlayer > 20) return 'high';
    if (actionsPerPlayer > 10) return 'medium';
    return 'low';
}

function generateEconomyRecommendations(avgBrainrots) {
    const recommendations = [];
    
    if (avgBrainrots < 3) {
        recommendations.push('Increase egg spawn rate to boost early game progression');
        recommendations.push('Consider reducing incubation times for Common eggs');
    }
    
    if (avgBrainrots > 35) {
        recommendations.push('Players approaching limit - consider increasing max Brainrots');
        recommendations.push('Add more expensive upgrade tiers');
    }
    
    return recommendations;
}

// Scheduled tasks
cron.schedule('*/5 * * * *', () => {
    console.log('🔄 Running scheduled analytics update...');
    
    // Calculate and broadcast analytics
    const analytics = analyzeEconomy();
    broadcast({
        type: 'analytics_update',
        data: analytics
    });
});

// Error handling
app.use((error, req, res, next) => {
    console.error('Server error:', error);
    res.status(500).json({ error: 'Internal server error' });
});

// Start server
server.listen(PORT, () => {
    console.log(`🚀 Brainrot Simulator MCP Server running on port ${PORT}`);
    console.log(`🔌 WebSocket server ready for connections`);
    console.log(`📊 Analytics dashboard: http://localhost:${PORT}/api/analytics`);
    console.log(`❤️ Health check: http://localhost:${PORT}/health`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
    console.log('🛑 Shutting down gracefully...');
    server.close(() => {
        console.log('✅ Server closed');
        process.exit(0);
    });
});
