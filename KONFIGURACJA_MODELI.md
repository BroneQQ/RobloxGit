# 🎨 Konfiguracja Modeli - Brainrot Simulator

## 📦 Wymagania dla Modeli Brainrotów

### Struktura Modelu
Każdy model Brainrota w `ServerStorage/Brainrots` MUSI mieć:

```
📦 [Rarity]_[Name] (np. Common_BrainrotA)
├── 🧱 [Parts] - części modelu
├── 👤 Humanoid (opcjonalne, dla wzrostu)
├── 📂 Data
│   ├── 🔢 Level (IntValue, wartość: 1)
│   └── 👤 Owner (ObjectValue, wartość: nil)
└── 📜 InteractionScript (Script)
```

### ⚙️ Ustawienia PrimaryPart
**KRYTYCZNE**: Każdy model MUSI mieć ustawiony PrimaryPart!

1. Wybierz model w Explorer
2. W Properties znajdź **PrimaryPart**
3. Ustaw na główną część modelu (zwykle tułów/korpus)

### 📏 Wysokości Spawnu (Y Offsets)

W `PlacementHandler.lua` uzupełnij tabelę:

```lua
local BRAINROT_Y_OFFSETS = {
    -- Common Brainroty
    ["Common_BrainrotA"] = 2.5,
    ["Common_BrainrotB"] = 3.0,
    ["Common_BrainrotC"] = 2.8,
    
    -- Rare Brainroty  
    ["Rare_BrainrotA"] = 3.2,
    ["Rare_BrainrotB"] = 2.9,
    
    -- Epic Brainroty
    ["Epic_BrainrotA"] = 3.5,
    ["Epic_BrainrotB"] = 4.0,
    
    -- Legendary Brainroty
    ["Legendary_BrainrotA"] = 4.5,
    ["Legendary_BrainrotB"] = 5.0
}
```

**Jak ustalić wysokość**:
1. Postaw model na baseplate
2. Sprawdź jak wysoko nad ziemią powinien być
3. Dodaj tę wartość do tabeli

## 🥚 Wymagania dla Modeli Jajek

### Struktura Jajka
Każde jajko w `ReplicatedStorage/Eggs` MUSI mieć:

```
📦 Egg_[Rarity] (np. Egg_Common)
├── 🧱 [Parts] - części jajka
├── 🖱️ ClickDetector (w PrimaryPart!)
└── 📜 ClickLogic (Script)
```

### Naming Convention
- `Egg_Common` - dla Common Brainrotów
- `Egg_Rare` - dla Rare Brainrotów  
- `Egg_Epic` - dla Epic Brainrotów
- `Egg_Legendary` - dla Legendary Brainrotów

## 🖼️ Obrazki dla UI

W `InventoryManager.lua` uzupełnij:

```lua
local BRAINROT_IMAGE_IDS = {
    -- Common
    ["Common_BrainrotA"] = "rbxassetid://1234567890",
    ["Common_BrainrotB"] = "rbxassetid://1234567891",
    
    -- Rare
    ["Rare_BrainrotA"] = "rbxassetid://1234567892",
    
    -- Epic  
    ["Epic_BrainrotA"] = "rbxassetid://1234567893",
    
    -- Legendary
    ["Legendary_BrainrotA"] = "rbxassetid://1234567894"
}
```

**Jak zdobyć ID obrazka**:
1. Wrzuć obrazek na Roblox (Create → Decals)
2. Skopiuj ID z URL (np. rbxassetid://123456789)
3. Lub użyj rbxasset://textures/face.png dla testów

## 🏗️ Szablony Świata

### PlayerPlotTemplate
Model działki gracza w `ServerStorage`:
- Musi mieć PrimaryPart
- Rozmiar około 100x100 studs
- Może zawierać dekoracje, ogrodzenia itp.

### ConveyorBelt  
Model taśmociągu w `ServerStorage`:
- Musi mieć PrimaryPart
- Musi zawierać **SpawnPoint** (Part) - gdzie spadają jajka
- Musi zawierać **EndPoint** (Part) - gdzie jajka znikają
- Długość około 40 studs

## 🔧 Automatyzacja Tworzenia

### Script do szybkiego dodawania Data folderów:

```lua
-- Uruchom w Command Bar (F9)
for _, model in ipairs(game.ServerStorage.Brainrots:GetChildren()) do
    if model:IsA("Model") then
        local dataFolder = Instance.new("Folder")
        dataFolder.Name = "Data"
        dataFolder.Parent = model
        
        local level = Instance.new("IntValue")
        level.Name = "Level"
        level.Value = 1
        level.Parent = dataFolder
        
        local owner = Instance.new("ObjectValue")
        owner.Name = "Owner"
        owner.Parent = dataFolder
        
        print("Dodano Data folder do:", model.Name)
    end
end
```

### Script do dodawania ClickDetectorów:

```lua
-- Uruchom w Command Bar dla jajek
for _, egg in ipairs(game.ReplicatedStorage.Eggs:GetChildren()) do
    if egg:IsA("Model") and egg.PrimaryPart then
        local cd = Instance.new("ClickDetector")
        cd.Parent = egg.PrimaryPart
        print("Dodano ClickDetector do:", egg.Name)
    end
end
```

## ✅ Checklist Modeli

### Przed uruchomieniem gry sprawdź:

**Brainroty** (ServerStorage/Brainrots):
- [ ] Każdy model ma PrimaryPart
- [ ] Każdy model ma folder Data z Level i Owner
- [ ] Każdy model ma InteractionScript
- [ ] Wszystkie modele są w BRAINROT_Y_OFFSETS
- [ ] Wszystkie modele są w BRAINROT_IMAGE_IDS

**Jajka** (ReplicatedStorage/Eggs):
- [ ] Każde jajko ma PrimaryPart
- [ ] Każde jajko ma ClickDetector w PrimaryPart
- [ ] Każde jajko ma ClickLogic script
- [ ] Nazwy to Egg_[Rarity]

**Szablony** (ServerStorage):
- [ ] PlayerPlotTemplate ma PrimaryPart
- [ ] ConveyorBelt ma PrimaryPart, SpawnPoint i EndPoint

## 🎯 Testowanie Modeli

1. **Uruchom grę** w Studio
2. **Poczekaj 5 sekund** - powinno spaść jajko
3. **Kliknij jajko** - powinien pojawić się w ekwipunku
4. **Wciśnij 1** - powinien się aktywować tryb sadzenia
5. **Kliknij na działce** - jajko powinno się posadzić i inkubować
6. **Po inkubacji** - powinien pojawić się Brainrot
7. **Kliknij Brainrota** - powinien się ulepszyć za monety
8. **Przytrzymaj E** - powinien się sprzedać

Jeśli któryś krok nie działa, sprawdź odpowiedni model i jego konfigurację!
