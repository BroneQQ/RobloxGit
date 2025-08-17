# 🧠 Brainrot Simulator MCP Server

## 🚀 Szybki Start

1. **Uruchom serwer**:
   ```bash
   npm start
   ```

2. **Sprawdź status**:
   - Otwórz: http://localhost:3000/health

3. **Połącz z Roblox**:
   - Użyj Plugin w Roblox Studio
   - Lub dodaj GameConnector.lua do gry

## 📊 API Endpoints

### Health Check
```
GET /health
```

### Analytics
```
GET /api/analytics
```

### AI Analysis
```
POST /api/ai/analyze
{
  "type": "economy",
  "data": {}
}
```

### Balance Suggestions
```
POST /api/ai/balance
```

### Generate Content
```
POST /api/ai/generate-content
{
  "type": "brainrot",
  "parameters": {"rarity": "Epic"}
}
```

## 🔌 WebSocket Events

### From Roblox to MCP:
- `player_joined`
- `egg_clicked`
- `brainrot_spawned`
- `brainrot_upgraded`
- `brainrot_sold`

### From MCP to Roblox:
- `balance_update`
- `analytics_update`
- `content_generated`
- `ai_recommendation`

## 🛠️ Development

### Install dependencies:
```bash
npm install
```

### Run in development mode:
```bash
npm run dev
```

### Configuration:
Copy `.env.example` to `.env` and configure as needed.

## 📈 Monitoring

The server provides real-time monitoring of:
- Player activity
- Game economy
- Brainrot statistics
- Performance metrics
- AI recommendations

## 🤖 AI Features

- **Economy Analysis**: Automatic balance suggestions
- **Content Generation**: New Brainrots and events
- **Player Behavior**: Engagement and retention analysis
- **Performance Optimization**: Code and system improvements
