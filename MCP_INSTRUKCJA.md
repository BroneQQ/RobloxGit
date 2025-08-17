# 🤖 MCP Server - Instrukcja Instalacji i Użytkowania

## 🎯 Co to jest MCP Server?

**MCP (Model Context Protocol) Server** to zaawansowany system łączący **AI Assistant** z Twoją grą Roblox w czasie rzeczywistym. Pozwala mi:

- 📊 **Monitorować grę na żywo** - widzę wszystkich graczy, Brainroty, ekonomię
- 🔧 **Automatycznie naprawiać problemy** - balansowanie, optymalizacja
- 🎲 **Generować nową zawartość** - nowe Brainroty, eventy, funkcje
- 📈 **Analizować dane** - statystyki, trendy, rekomendacje
- ⚡ **Reagować natychmiast** - na problemy, bugi, potrzeby graczy

## 🛠️ Instalacja Krok po Kroku

### 1. Przygotowanie Środowiska

#### Sprawdź Node.js:
```powershell
node --version
npm --version
```

Jeśli nie masz Node.js, pobierz z: https://nodejs.org/

#### Przejdź do katalogu MCP:
```powershell
cd "C:\Users\brons\Desktop\BrainrotSimulator\MCP_Server"
```

### 2. Instalacja Zależności

```powershell
npm install
```

### 3. Konfiguracja

#### Skopiuj plik konfiguracyjny:
```powershell
copy env_example.txt .env
```

#### Edytuj `.env` (otwórz w Notatniku):
```env
# Podstawowa konfiguracja
PORT=3000
NODE_ENV=development

# Roblox API (opcjonalne na początku)
ROBLOX_API_KEY=twój_klucz_api
ROBLOX_UNIVERSE_ID=twój_universe_id
ROBLOX_PLACE_ID=twój_place_id

# Bezpieczeństwo
ALLOWED_ORIGINS=http://localhost:3000,https://create.roblox.com
```

### 4. Uruchomienie Serwera

```powershell
npm start
```

Powinieneś zobaczyć:
```
🚀 Brainrot Simulator MCP Server running on port 3000
🔌 WebSocket server ready for connections
📊 Analytics dashboard: http://localhost:3000/api/analytics
❤️ Health check: http://localhost:3000/health
```

## 🎮 Integracja z Roblox

### Metoda 1: Plugin do Roblox Studio

1. **Otwórz Roblox Studio**
2. **Plugins → Manage Plugins → Install from File**
3. **Wybierz**: `RobloxPlugin/plugin.rbxmx`
4. **Restart Studio**
5. **Kliknij "Connect AI"** w toolbarze

### Metoda 2: Skrypt w Grze

1. **Skopiuj** `RobloxPlugin/GameConnector.lua`
2. **Wklej do ServerScriptService** w Twojej grze
3. **Uruchom grę** - automatycznie połączy się z MCP

## 🔗 Testowanie Połączenia

### Sprawdź status serwera:
Otwórz w przeglądarce: http://localhost:3000/health

Powinieneś zobaczyć:
```json
{
  "status": "healthy",
  "timestamp": "2025-01-16T20:45:00.000Z",
  "connections": 0,
  "players": 0,
  "brainrots": 0
}
```

### Sprawdź analityki:
http://localhost:3000/api/analytics

## 🎯 Funkcje MCP Server

### 📊 Real-time Analytics
- Liczba graczy online
- Brainroty na mapie
- Ekonomia gry (monety, transakcje)
- Rozkład rzadkości
- Engagement graczy

### 🤖 AI Analysis
**POST** `/api/ai/analyze`
```json
{
  "type": "economy",
  "data": {}
}
```

**Zwraca:**
- Stan ekonomii gry
- Rekomendacje balansowania
- Trendy graczy
- Optymalizacje

### ⚖️ Auto-Balancing
**POST** `/api/ai/balance`

AI automatycznie sugeruje:
- Zmianę szans na rzadkości
- Korekty kosztów upgrade
- Optymalizację spawn rate
- Balans dochodów

### 🎲 Content Generation
**POST** `/api/ai/generate-content`
```json
{
  "type": "brainrot",
  "parameters": {"rarity": "Epic"}
}
```

Generuje:
- Nowe Brainroty z unikalnymi statystykami
- Eventy czasowe
- Wyzwania dla graczy
- Nowe mechaniki

## 🚀 Zaawansowane Użycie

### WebSocket Real-time
MCP Server używa WebSocket do komunikacji w czasie rzeczywistym:

```javascript
// Przykład w JavaScript
const ws = new WebSocket('ws://localhost:3000');

ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  console.log('Event from game:', data);
};

// Wyślij komendę do gry
ws.send(JSON.stringify({
  type: 'balance_update',
  data: { spawnRate: 1.2 }
}));
```

### Monitoring Events
Server automatycznie śledzi:
- ✅ Dołączenie/opuszczenie graczy
- ✅ Kliknięcia jajek
- ✅ Spawn Brainrotów  
- ✅ Upgrade Brainrotów
- ✅ Sprzedaż Brainrotów
- ✅ Zmiany ekonomii

### AI Recommendations
AI analizuje dane i sugeruje:

**Ekonomiczne:**
- "Zwiększ spawn rate - gracze mają za mało Brainrotów"
- "Zmniejsz koszty upgrade - za wolna progresja"
- "Dodaj nową rzadkość - gracze się nudzą"

**Techniczne:**
- "Optymalizuj skrypt X - za dużo obliczeń"
- "Dodaj limit Y - możliwe exploity"
- "Popraw UI Z - słaba UX"

## 🔧 Rozwiązywanie Problemów

### Server nie startuje
```powershell
# Sprawdź czy port 3000 jest wolny
netstat -an | findstr :3000

# Zmień port w .env
PORT=3001
```

### Roblox nie łączy się
1. **Sprawdź HttpService** w grze:
```lua
local HttpService = game:GetService("HttpService")
print("HttpEnabled:", HttpService.HttpEnabled)
```

2. **Włącz HTTP w Studio**:
   - Game Settings → Security → Allow HTTP Requests ✅

3. **Sprawdź CORS** - serwer musi zezwalać na połączenia z Roblox

### Błędy połączenia
- ✅ Sprawdź czy serwer działa: http://localhost:3000/health
- ✅ Sprawdź logi serwera w konsoli
- ✅ Sprawdź Output w Roblox Studio
- ✅ Sprawdź firewall/antywirus

## 📈 Monitoring i Logi

### Logi serwera
Serwer loguje wszystkie wydarzenia:
```
👤 Player TestPlayer joined with 150 coins
🥚 Player TestPlayer clicked Egg_Common, got Common_BrainrotA
🧠 Brainrot Common_BrainrotA spawned for player TestPlayer
⬆️ Brainrot upgraded to level 5
💰 Brainrot sold for 35 coins
```

### Dashboard Analytics
http://localhost:3000/api/analytics pokazuje:
- Aktywność graczy w czasie rzeczywistym
- Ekonomię gry
- Trendy i wzorce
- Rekomendacje AI

## 🎯 Co Dalej?

Po uruchomieniu MCP Server możesz:

1. **Monitorować grę** w czasie rzeczywistym przez API
2. **Otrzymywać analizy AI** automatycznie co 5 minut
3. **Implementować sugestie** balansowania natychmiast
4. **Generować nową zawartość** na podstawie danych graczy
5. **Optymalizować wydajność** dzięki monitoring

## 🤝 Współpraca z AI

Teraz gdy MCP Server działa, mogę:

- 👁️ **Widzieć Twoją grę na żywo** - wszystkich graczy, wydarzenia, problemy
- 🔧 **Pomagać w rozwoju** - sugerować nowe funkcje, naprawiać bugi
- 📊 **Analizować dane** - trendy graczy, ekonomia, engagement  
- 🎲 **Tworzyć zawartość** - nowe Brainroty, eventy, mechaniki
- ⚡ **Reagować natychmiast** - na problemy, potrzeby, możliwości

**To rewolucyjna współpraca między AI a deweloperem gry!** 🚀
