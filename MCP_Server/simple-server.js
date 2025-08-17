// Prosty MCP Server bez zewnętrznych zależności
const http = require('http');
const url = require('url');

const PORT = 3000;

// Podstawowe dane gry
let gameData = {
    players: [],
    brainrots: [],
    events: [],
    analytics: {
        totalPlayers: 0,
        totalBrainrots: 0,
        totalCoins: 0,
        lastUpdate: new Date()
    }
};

// Serwer HTTP
const server = http.createServer((req, res) => {
    const parsedUrl = url.parse(req.url, true);
    const path = parsedUrl.pathname;
    const method = req.method;

    // CORS headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
    res.setHeader('Content-Type', 'application/json');

    // Handle preflight requests
    if (method === 'OPTIONS') {
        res.writeHead(200);
        res.end();
        return;
    }

    // Routes
    if (path === '/health' && method === 'GET') {
        res.writeHead(200);
        res.end(JSON.stringify({
            status: 'healthy',
            timestamp: new Date().toISOString(),
            connections: gameData.players.length,
            players: gameData.analytics.totalPlayers,
            brainrots: gameData.analytics.totalBrainrots
        }));
        return;
    }

    if (path === '/api/analytics' && method === 'GET') {
        res.writeHead(200);
        res.end(JSON.stringify({
            analytics: gameData.analytics,
            players: gameData.players,
            brainrots: gameData.brainrots,
            events: gameData.events.slice(-50) // Last 50 events
        }));
        return;
    }

    if (path === '/api/game-event' && method === 'POST') {
        let body = '';
        req.on('data', chunk => {
            body += chunk.toString();
        });
        req.on('end', () => {
            try {
                const event = JSON.parse(body);
                gameData.events.push({
                    ...event,
                    timestamp: new Date().toISOString()
                });

                // Update analytics based on event
                updateAnalytics(event);

                console.log(`📊 Game Event: ${event.type} - ${event.player || 'System'}`);
                
                res.writeHead(200);
                res.end(JSON.stringify({ success: true }));
            } catch (error) {
                res.writeHead(400);
                res.end(JSON.stringify({ error: 'Invalid JSON' }));
            }
        });
        return;
    }

    // Default 404
    res.writeHead(404);
    res.end(JSON.stringify({ error: 'Not found' }));
});

// Update analytics based on game events
function updateAnalytics(event) {
    switch(event.type) {
        case 'player_joined':
            gameData.analytics.totalPlayers++;
            gameData.players.push({
                name: event.player,
                joinTime: new Date().toISOString(),
                coins: event.coins || 100
            });
            break;
        case 'player_left':
            gameData.players = gameData.players.filter(p => p.name !== event.player);
            break;
        case 'brainrot_spawned':
            gameData.analytics.totalBrainrots++;
            gameData.brainrots.push({
                type: event.brainrotType,
                owner: event.player,
                level: 1,
                spawnTime: new Date().toISOString()
            });
            break;
        case 'coins_changed':
            const player = gameData.players.find(p => p.name === event.player);
            if (player) {
                player.coins = event.coins;
            }
            break;
    }
    gameData.analytics.lastUpdate = new Date();
}

// Start server
server.listen(PORT, () => {
    console.log('');
    console.log('========================================');
    console.log('   🧠 Brainrot Simulator MCP Server');
    console.log('========================================');
    console.log('');
    console.log(`🚀 Server running on port ${PORT}`);
    console.log(`🔗 Health check: http://localhost:${PORT}/health`);
    console.log(`📊 Analytics: http://localhost:${PORT}/api/analytics`);
    console.log('');
    console.log('💡 Server ready for Roblox connections!');
    console.log('');
});

// Graceful shutdown
process.on('SIGINT', () => {
    console.log('\n🛑 Server shutting down...');
    server.close(() => {
        console.log('✅ Server closed');
        process.exit(0);
    });
});

