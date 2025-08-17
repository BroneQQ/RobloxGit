# Konfiguracja Cursor AI z Rojo

## Szybki start

1. **Uruchom serwer Rojo**:
   ```bash
   start_rojo.bat
   ```

2. **Zainstaluj plugin Rojo w Roblox Studio**:
   - Otwórz Roblox Studio
   - View → Plugins → Manage Plugins
   - Wyszukaj "Rojo" i zainstaluj

3. **Połącz plugin z serwerem**:
   - W pluginie Rojo kliknij "Connect"
   - Wprowadź: `http://localhost:34872`
   - Kliknij "Connect"

4. **Edytuj kod w Cursorze**:
   - Wszystkie zmiany w plikach `.lua` automatycznie synchronizują się z Roblox Studio

## Struktura projektu

```
BrainrotSimulator/
├── default.project.json          # Konfiguracja Rojo
├── start_rojo.bat               # Uruchomienie serwera
├── test_rojo_connection.bat     # Test połączenia
├── .vscode/settings.json        # Konfiguracja Cursor/VS Code
├── ReplicatedStorage/           # Synchronizowane z ReplicatedStorage
│   ├── ClickLogic.lua
│   └── Eggs/
├── ServerScriptService/         # Synchronizowane z ServerScriptService
│   ├── PlacementHandler.lua
│   └── WorldManager.lua
├── ServerStorage/               # Synchronizowane z ServerStorage
│   └── InteractionScript.lua
├── StarterGui/                  # Synchronizowane z StarterGui
│   └── InventoryManager.lua
└── StarterPlayerScripts/        # Synchronizowane z StarterPlayerScripts
    └── CustomPromptHandler.lua
```

## Korzyści z Cursor AI

### 1. Inteligentne autouzupełnianie
- Cursor AI rozumie kontekst Roblox API
- Sugeruje odpowiednie metody i właściwości
- Automatycznie importuje moduły

### 2. Debugowanie
- Lepsze narzędzia do debugowania kodu Lua
- Integracja z Roblox Studio
- Możliwość ustawiania breakpointów

### 3. Refaktoryzacja
- Bezpieczne zmiany nazw funkcji i zmiennych
- Automatyczne aktualizacje referencji
- Lepsze zarządzanie kodem

### 4. Kontrola wersji
- Integracja z Git
- Śledzenie zmian w kodzie
- Możliwość cofania zmian

## Przykłady użycia Cursor AI

### Edycja skryptu
```lua
-- W Cursorze możesz edytować plik ServerScriptService/WorldManager.lua
-- Zmiany automatycznie pojawią się w Roblox Studio

local function createWorld()
    -- Cursor AI pomoże Ci z autouzupełnianiem
    local world = Instance.new("Part")
    world.Name = "World"
    world.Position = Vector3.new(0, 0, 0)
    world.Size = Vector3.new(100, 1, 100)
    world.Anchored = true
    world.Parent = workspace
end
```

### Tworzenie nowego modułu
```lua
-- Utwórz nowy plik w ReplicatedStorage/NewModule.lua
-- Cursor AI pomoże Ci z strukturą modułu

local NewModule = {}

function NewModule.new()
    local self = {}
    -- Implementacja
    return self
end

return NewModule
```

## Rozwiązywanie problemów

### Problem: Cursor AI nie rozpoznaje Roblox API
- Sprawdź czy plik `.vscode/settings.json` jest poprawny
- Uruchom ponownie Cursor
- Sprawdź czy wtyczka Lua Language Server jest zainstalowana

### Problem: Synchronizacja nie działa
- Sprawdź czy serwer Rojo jest uruchomiony
- Sprawdź połączenie w pluginie Rojo
- Sprawdź czy pliki są w odpowiednich katalogach

### Problem: Błędy składni
- Użyj `Ctrl+Shift+P` → "Format Document" w Cursorze
- Sprawdź czy używasz Lua 5.1 składni
- Sprawdź logi w Roblox Studio

## Przydatne skróty klawiszowe

- `Ctrl+Space` - Autouzupełnianie
- `Ctrl+Shift+P` - Command Palette
- `F12` - Przejdź do definicji
- `Shift+F12` - Znajdź wszystkie referencje
- `Ctrl+Shift+F` - Wyszukaj w plikach
- `Ctrl+D` - Wybierz następne wystąpienie

## Wtyczki dla Cursor AI

Zalecane wtyczki dla lepszej pracy z Lua:
- Lua Language Server
- Lua Debug
- Roblox Lua Support
- Error Lens
- GitLens
