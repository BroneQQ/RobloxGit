# Instrukcja ponownego połączenia z Rojo i Git

## Stan obecny
✅ Działający system z:
- WorldManager (system jajek, działki, transportery)
- InventoryManager (system inwentarza)
- GamePassHandler (system backpack upgrade)
- PlacementHandler
- Wszystkie GUI i RemoteEvent

## Pliki zapisane
- `BrainrotSimulator_working.rbxl` - działający projekt
- `ServerScriptService/WorldManager_working.lua` - kopia zapasowa WorldManager
- `ROBLOX_SCRIPTS/` - wszystkie oryginalne pliki z wczoraj

## Krok 1: Przygotowanie do Rojo
1. **Zapisz projekt w Roblox Studio** jako `BrainrotSimulator_working.rbxl`
2. **Sprawdź czy wszystkie skrypty działają** przed połączeniem z Rojo

## Krok 2: Konfiguracja Rojo
1. **Utwórz `default.project.json`:**
```json
{
  "name": "BrainrotSimulator",
  "tree": {
    "$className": "DataModel",
    "ReplicatedStorage": {
      "$path": "ReplicatedStorage"
    },
    "ServerScriptService": {
      "$path": "ServerScriptService"
    },
    "ServerStorage": {
      "$path": "ServerStorage"
    },
    "StarterGui": {
      "$path": "StarterGui"
    },
    "StarterPlayerScripts": {
      "$path": "StarterPlayerScripts"
    }
  }
}
```

## Krok 3: Uruchomienie Rojo
1. **Uruchom Rojo server:** `.\start_rojo_default_port.bat`
2. **W Roblox Studio:** Połącz plugin Rojo z `localhost:34872`
3. **Poczekaj na synchronizację**

## Krok 4: Git
1. **Dodaj pliki do Git:**
```bash
git add .
git commit -m "Working system with eggs, inventory, and backpack upgrades"
git push origin master
```

## Jeśli coś się zepsuje
1. **Otwórz `BrainrotSimulator_working.rbxl`** - działająca kopia
2. **Skopiuj kod z `WorldManager_working.lua`** do WorldManager w Roblox Studio
3. **Sprawdź czy wszystkie skrypty są w odpowiednich miejscach**

## Ważne uwagi
- **Nie usuwaj modeli** z ServerStorage (PlayerPlotTemplate, ConveyorBelt)
- **Nie usuwaj folderu Eggs** z ReplicatedStorage
- **Sprawdź PrimaryPart** w modelach przed uruchomieniem
- **Upewnij się, że wszystkie RemoteEvent są na miejscu**

## Struktura plików
```
ServerScriptService/
├── WorldManager.lua (główny system)
├── PlacementHandler.lua
└── GamePassHandler.lua

StarterGui/
├── InventoryGui/
│   └── InventoryManager.lua
└── BackpackPromptGUI.lua

ReplicatedStorage/
├── Eggs/ (modele jajek)
├── ShowBackpackUpgradePrompt (RemoteEvent)
└── PurchaseBackpackUpgrade (RemoteEvent)
```
