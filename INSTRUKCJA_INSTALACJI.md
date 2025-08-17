# 🚀 Brainrot Simulator - Instrukcja Instalacji

## 📋 Wymagania
- Roblox Studio
- Dostęp do API Services (KRYTYCZNE!)

## 🔧 Krok po Kroku

### 1. Ustawienia Gry (NAJPIERW!)
1. Otwórz Roblox Studio
2. HOME → **Game Settings**
3. **Security** → Włącz **"Enable Studio Access to API Services"**
4. **Zapisz ustawienia**

⚠️ **BEZ TEGO KROKU GRA NIE BĘDZIE DZIAŁAĆ!**

### 2. Struktura w Explorer

#### ReplicatedStorage
```
📂 Eggs
├── 📦 Egg_Common
│   └── 📜 ClickLogic (Script)
├── 📦 Egg_Rare  
│   └── 📜 ClickLogic (Script)
├── 📦 Egg_Epic
│   └── 📜 ClickLogic (Script)
├── 📦 Egg_Legendary
│   └── 📜 ClickLogic (Script)
└── ⚡ PlaceEggRequest (RemoteEvent)
```

#### ServerScriptService
```
📜 WorldManager (Script)
📜 PlacementHandler (Script)
```

#### ServerStorage
```
📂 Brainrots
├── 📦 Common_BrainrotA
│   ├── 📜 InteractionScript (Script)
│   └── 📂 Data
│       ├── 🔢 Level (IntValue)
│       └── 👤 Owner (ObjectValue)
├── 📦 Common_BrainrotB (+ InteractionScript + Data)
├── 📦 Rare_BrainrotA (+ InteractionScript + Data)
├── 📦 Epic_BrainrotA (+ InteractionScript + Data)
└── 📦 Legendary_BrainrotA (+ InteractionScript + Data)
📦 PlayerPlotTemplate
📦 ConveyorBelt
```

#### StarterGui
```
📂 InventoryGui (ScreenGui)
├── 📜 InventoryManager (LocalScript)
└── 📦 EggHotbar (Frame)
    ├── 📜 UIGridLayout
    └── 👆 EggButtonTemplate (TextButton, Visible=false)
        ├── 🖼️ EggIcon (ImageLabel)
        └── 📦 TextContainer (Frame)
            ├── 📜 EggNameLabel (TextLabel)
            └── 📜 SlotNumberLabel (TextLabel)

📂 ProximityPromptsGui (ScreenGui)
└── 🖼️ CustomSellPrompt (BillboardGui, Enabled=false)
    └── 📦 Background (Frame)
        ├── 📜 UICorner
        ├── 📦 ProgressFill (Frame)
        │   └── 📜 UICorner
        ├── 📜 InfoText (TextLabel)
        └── 📜 ActionText (TextLabel)
```

#### StarterPlayer → StarterPlayerScripts
```
📜 CustomPromptHandler (LocalScript)
```

### 3. Kopiowanie Skryptów

1. **WorldManager.lua** → ServerScriptService/WorldManager
2. **PlacementHandler.lua** → ServerScriptService/PlacementHandler  
3. **ClickLogic.lua** → Do każdego jajka w ReplicatedStorage/Eggs
4. **InteractionScript.lua** → Do każdego Brainrota w ServerStorage/Brainrots
5. **InventoryManager.lua** → StarterGui/InventoryGui/InventoryManager
6. **CustomPromptHandler.lua** → StarterPlayerScripts/CustomPromptHandler

### 4. Konfiguracja Modeli

#### Każdy Model Brainrota MUSI mieć:
- ✅ **PrimaryPart** ustawiony
- ✅ Folder **"Data"** zawierający:
  - IntValue **"Level"** (wartość 1)
  - ObjectValue **"Owner"** (wartość nil)
- ✅ **InteractionScript** w środku

#### Każde Jajko MUSI mieć:
- ✅ **PrimaryPart** ustawiony
- ✅ **ClickDetector** w PrimaryPart
- ✅ **ClickLogic** script w środku

### 5. Wymagane Uzupełnienia

#### PlacementHandler.lua - Linia 20
```lua
local BRAINROT_Y_OFFSETS = {
    ["Common_BrainrotA"] = 2.5,
    ["Common_BrainrotB"] = 3.0,
    ["Rare_BrainrotA"] = 2.8,
    ["Epic_BrainrotA"] = 3.2,
    ["Legendary_BrainrotA"] = 4.0
    -- DODAJ WSZYSTKIE SWOJE MODELE!
}
```

#### InventoryManager.lua - Linia 16
```lua
local BRAINROT_IMAGE_IDS = {
    ["Common_BrainrotA"] = "rbxassetid://TWOJE_ID",
    ["Common_BrainrotB"] = "rbxassetid://TWOJE_ID",
    ["Rare_BrainrotA"] = "rbxassetid://TWOJE_ID",
    -- DODAJ WSZYSTKIE SWOJE MODELE Z ID OBRAZKÓW!
}
```

### 6. Testowanie

1. **Uruchom grę** w Studio
2. **Sprawdź Output** - nie powinno być błędów
3. **Sprawdź czy**:
   - Gracz dostaje działkę i taśmociąg
   - Jajka spadają co 5 sekund
   - Można kliknąć jajko i dostać Brainrota do ekwipunku
   - Można posadzić Brainrota (1-9 lub klik)
   - Brainrot inkubuje się i pojawia
   - Można ulepszać i sprzedawać

## 🚨 Częste Problemy

### "DataStoreService: AccessForbidden"
**Rozwiązanie**: Włącz API Services w ustawieniach gry!

### "Infinite yield possible on ProximityPromptsGui"
**Rozwiązanie**: Stwórz ScreenGui o nazwie "ProximityPromptsGui" w StarterGui

### "PrimaryPart nie ustawiony"
**Rozwiązanie**: Ustaw PrimaryPart dla każdego modelu

### Jajka nie spadają
**Rozwiązanie**: Sprawdź czy PlayerPlotTemplate i ConveyorBelt istnieją w ServerStorage

### Brainroty nie pojawiają się po inkubacji
**Rozwiązanie**: Sprawdź BRAINROT_Y_OFFSETS i upewnij się że modele mają PrimaryPart

## ✅ Gotowe!

Jeśli wszystko działa poprawnie, powinieneś mieć w pełni funkcjonalną grę typu Brainrot Simulator!
