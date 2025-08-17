# 🚨 Rozwiązywanie Problemów - Brainrot Simulator

## 🔴 KRYTYCZNE BŁĘDY

### DataStoreService: AccessForbidden
```
DataStoreService: AccessForbidden: Not authorized to access this resource
```

**PRZYCZYNA**: Brak dostępu do API Services  
**ROZWIĄZANIE**:
1. HOME → Game Settings
2. Security → **Włącz "Enable Studio Access to API Services"**
3. Zapisz i uruchom ponownie grę

---

### Infinite yield possible on ProximityPromptsGui
```
Infinite yield possible on 'Players.Player.PlayerGui:WaitForChild("ProximityPromptsGui")'
```

**PRZYCZYNA**: Brakuje ScreenGui o nazwie "ProximityPromptsGui"  
**ROZWIĄZANIE**:
1. StarterGui → Insert Object → ScreenGui
2. Zmień nazwę na **"ProximityPromptsGui"**
3. Dodaj strukturę UI zgodnie z instrukcją

---

## 🟡 CZĘSTE PROBLEMY

### Jajka nie spadają na taśmociąg

**Możliwe przyczyny**:
- Brak PlayerPlotTemplate w ServerStorage
- Brak ConveyorBelt w ServerStorage  
- ConveyorBelt nie ma SpawnPoint/EndPoint

**ROZWIĄZANIE**:
```lua
-- Sprawdź w Command Bar (F9):
print("PlotTemplate:", game.ServerStorage:FindFirstChild("PlayerPlotTemplate"))
print("ConveyorBelt:", game.ServerStorage:FindFirstChild("ConveyorBelt"))

local conveyor = game.ServerStorage:FindFirstChild("ConveyorBelt")
if conveyor then
    print("SpawnPoint:", conveyor:FindFirstChild("SpawnPoint"))
    print("EndPoint:", conveyor:FindFirstChild("EndPoint"))
end
```

---

### Nie można kliknąć jajek

**Możliwe przyczyny**:
- Brak ClickDetector w PrimaryPart jajka
- PrimaryPart nie ustawiony
- Jajko nie ma Owner value

**ROZWIĄZANIE**:
```lua
-- Sprawdź jajko w workspace:
for _, egg in ipairs(workspace:GetChildren()) do
    if egg.Name:find("Egg_") then
        print("Jajko:", egg.Name)
        print("PrimaryPart:", egg.PrimaryPart)
        print("ClickDetector:", egg.PrimaryPart and egg.PrimaryPart:FindFirstChild("ClickDetector"))
        print("Owner:", egg:FindFirstChild("Owner"))
    end
end
```

---

### Brainroty nie pojawiają się po inkubacji

**Możliwe przyczyny**:
- Brak modelu w ServerStorage/Brainrots
- Model nie ma PrimaryPart
- Błędna nazwa modelu
- Brak w BRAINROT_Y_OFFSETS

**ROZWIĄZANIE**:
1. Sprawdź czy model istnieje:
```lua
print("Brainroty:", game.ServerStorage.Brainrots:GetChildren())
```

2. Sprawdź PrimaryPart:
```lua
for _, model in ipairs(game.ServerStorage.Brainrots:GetChildren()) do
    print(model.Name, "PrimaryPart:", model.PrimaryPart)
end
```

3. Dodaj do BRAINROT_Y_OFFSETS w PlacementHandler

---

### Nie można ulepszać Brainrotów

**Możliwe przyczyny**:
- Brak Data folder w modelu
- Brak Level/Owner values
- InteractionScript nie został skopiowany

**ROZWIĄZANIE**:
```lua
-- Sprawdź Brainrota w workspace:
for _, model in ipairs(workspace:GetChildren()) do
    local data = model:FindFirstChild("Data")
    if data then
        print("Model:", model.Name)
        print("Level:", data:FindFirstChild("Level"))
        print("Owner:", data:FindFirstChild("Owner"))
        print("Script:", model:FindFirstChild("InteractionScript"))
    end
end
```

---

## 🟢 PROBLEMY KOSMETYCZNE

### Failed to load animation / MeshContentProvider failed

```
Failed to load animation rbxassetid://123456789
MeshContentProvider failed to process
```

**PRZYCZYNA**: Modele z Marketplace mają usunięte/nieprawidłowe animacje  
**ROZWIĄZANIE**: Usuń wszystkie obiekty typu Animation i Animate Script z modeli

```lua
-- Automatyczne czyszczenie animacji:
for _, model in ipairs(game.ServerStorage.Brainrots:GetChildren()) do
    for _, obj in ipairs(model:GetDescendants()) do
        if obj:IsA("Animation") or (obj:IsA("Script") and obj.Name == "Animate") then
            obj:Destroy()
            print("Usunięto:", obj.Name, "z", model.Name)
        end
    end
end
```

---

### Obrazki nie wyświetlają się w UI

**PRZYCZYNA**: Błędne ID obrazków lub brak w BRAINROT_IMAGE_IDS  
**ROZWIĄZANIE**:
1. Sprawdź ID obrazka na stronie Roblox
2. Upewnij się że format to "rbxassetid://NUMER"
3. Dodaj wszystkie modele do tabeli w InventoryManager

---

## 🔧 NARZĘDZIA DIAGNOSTYCZNE

### Command Bar Scripts (F9 → Command Bar)

**Sprawdź wszystkich graczy i ich dane**:
```lua
for _, player in ipairs(game.Players:GetPlayers()) do
    print("=== GRACZ:", player.Name, "===")
    print("Monety:", player.leaderstats.Coins.Value)
    print("Epic Pity:", player.PityData.epicPity.Value)
    print("Legendary Pity:", player.PityData.legendaryPity.Value)
    print("Jajka w ekwipunku:", #player.EggInventory:GetChildren())
    
    local brainrotsOwned = 0
    for _, model in ipairs(workspace:GetChildren()) do
        local data = model:FindFirstChild("Data")
        if data and data:FindFirstChild("Owner") and data.Owner.Value == player then
            brainrotsOwned = brainrotsOwned + 1
        end
    end
    print("Brainroty na mapie:", brainrotsOwned)
end
```

**Sprawdź strukturę gry**:
```lua
print("=== STRUKTURA GRY ===")
print("ReplicatedStorage/Eggs:", #game.ReplicatedStorage.Eggs:GetChildren())
print("ServerStorage/Brainrots:", #game.ServerStorage.Brainrots:GetChildren())
print("PlaceEggRequest:", game.ReplicatedStorage:FindFirstChild("PlaceEggRequest"))
print("PlayerPlotTemplate:", game.ServerStorage:FindFirstChild("PlayerPlotTemplate"))
print("ConveyorBelt:", game.ServerStorage:FindFirstChild("ConveyorBelt"))
```

**Wymuś spawn jajka**:
```lua
-- Zastąp "NazwaGracza" swoją nazwą
local player = game.Players:FindFirstChild("NazwaGracza")
if player then
    local conveyor = workspace:FindFirstChild(player.Name.."_Conveyor")
    if conveyor then
        local spawnPoint = conveyor:FindFirstChild("SpawnPoint")
        local egg = game.ReplicatedStorage.Eggs.Egg_Common:Clone()
        local owner = Instance.new("ObjectValue", egg)
        owner.Name = "Owner"
        owner.Value = player
        egg:SetPrimaryPartCFrame(spawnPoint.CFrame * CFrame.new(0, 1.2, 0))
        egg.Parent = workspace
        print("Wymuszono spawn jajka!")
    end
end
```

---

## 📞 Ostateczne Rozwiązania

### Reset danych gracza
```lua
-- W Command Bar - USUWA WSZYSTKIE DANE!
local dataStore = game:GetService("DataStoreService"):GetDataStore("PlayerBrainrotData_V2")
local playerUserId = "Player_" .. game.Players.LocalPlayer.UserId
dataStore:RemoveAsync(playerUserId)
print("Zresetowano dane gracza")
```

### Wyczyść workspace z Brainrotów
```lua
-- Usuń wszystkie Brainroty z mapy
for _, model in ipairs(workspace:GetChildren()) do
    if model:FindFirstChild("Data") then
        model:Destroy()
    end
end
print("Wyczyszczono wszystkie Brainroty")
```

### Restart całej gry
1. Zatrzymaj grę (Stop)
2. Usuń wszystkie modele graczy z workspace
3. Sprawdź Output pod kątem błędów
4. Uruchom ponownie (Play)

---

## 📋 Checklist Rozwiązywania Problemów

Gdy coś nie działa, sprawdź w kolejności:

1. **[ ]** Output - czy są błędy?
2. **[ ]** API Services - czy włączone?
3. **[ ]** Struktura - czy wszystkie obiekty istnieją?
4. **[ ]** PrimaryPart - czy ustawiony dla wszystkich modeli?
5. **[ ]** Skrypty - czy skopiowane do właściwych miejsc?
6. **[ ]** Konfiguracja - czy uzupełnione tabele?
7. **[ ]** Nazwy - czy zgodne z konwencją?

Jeśli wszystko sprawdzone, a problem nadal istnieje - sprawdź Output pod kątem konkretnych błędów i użyj narzędzi diagnostycznych powyżej.
