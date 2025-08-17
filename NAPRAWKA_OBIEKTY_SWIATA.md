# 🌍 Naprawka obiektów świata

## 🚨 Problem
Po połączeniu z Rojo nie widać trawy, transportera ani innych obiektów świata.

## ✅ Rozwiązanie krok po kroku

### Krok 1: Sprawdź czy serwer Rojo działa
```bash
# Uruchom serwer na nowym porcie
.\start_rojo_port_34873.bat
```

### Krok 2: Połącz plugin Rojo w Roblox Studio
1. W Roblox Studio, w pluginie Rojo kliknij **"Connect"**
2. Wprowadź adres: `http://localhost:34873`
3. Kliknij **"Connect"**

### Krok 3: Sprawdź czy pliki się synchronizują
- Sprawdź czy w ServerScriptService pojawił się `WorldSetup.lua`
- Sprawdź czy w ReplicatedStorage są pliki `Plants.lua` i `ShowBackpackUpgradePrompt.lua`

### Krok 4: Uruchom skrypt WorldSetup
1. W Roblox Studio, przejdź do **ServerScriptService**
2. Znajdź skrypt `WorldSetup.lua`
3. **Kliknij prawym przyciskiem myszy** na skrypt
4. Wybierz **"Run Script"**
5. Sprawdź Output - powinny pojawić się komunikaty:
   ```
   Starting world setup...
   Ground created successfully!
   Transporter created successfully!
   Tree1 created successfully!
   Tree2 created successfully!
   World setup completed!
   ```

### Krok 5: Sprawdź obiekty w Workspace
1. W Roblox Studio, przejdź do **Workspace**
2. Sprawdź czy pojawiły się obiekty:
   - **Ground** - zielona trawa
   - **Transporter** - niebieski transporter
   - **Tree1** i **Tree2** - brązowe drzewa

## 🔧 Jeśli obiekty nadal się nie pojawiają:

### Problem: Skrypt nie uruchamia się
- Sprawdź czy `WorldSetup.lua` jest w ServerScriptService
- Uruchom skrypt ręcznie (prawy klik → Run Script)
- Sprawdź Output w Roblox Studio

### Problem: Obiekty są niewidoczne
- Sprawdź czy obiekty są w Workspace
- Sprawdź czy nie są ukryte (Hidden = false)
- Sprawdź czy pozycje są poprawne

### Problem: Synchronizacja nie działa
- Sprawdź połączenie z serwerem Rojo
- Spróbuj ponownie połączyć się z serwerem
- Sprawdź czy wszystkie pliki są w odpowiednich katalogach

## 📋 Lista obiektów do sprawdzenia:

### ✅ Obiekty w Workspace:
- **Ground** - pozycja (0, -0.5, 0), rozmiar (100, 1, 100), materiał Grass
- **Transporter** - pozycja (0, 0.5, 50), rozmiar (4, 1, 4), kolor niebieski
- **Tree1** - pozycja (20, 5, 20), rozmiar (2, 10, 2), materiał Wood
- **Tree2** - pozycja (-20, 4, -20), rozmiar (2, 8, 2), materiał Wood

### ✅ Pliki w ReplicatedStorage:
- `Plants.lua` - moduł z danymi roślin
- `ShowBackpackUpgradePrompt.lua` - RemoteEvent

### ✅ Pliki w ServerScriptService:
- `WorldSetup.lua` - skrypt tworzący obiekty świata
- `WorldManager.lua` - główny skrypt świata
- `PlacementHandler.lua` - obsługa umieszczania obiektów

## 🎯 Komendy do sprawdzenia:

### Sprawdź czy serwer działa:
```bash
netstat -an | findstr :34873
```

### Sprawdź czy pliki są na miejscu:
```bash
dir ServerScriptService\WorldSetup.lua
dir ReplicatedStorage\Plants.lua
```

### Uruchom serwer ponownie:
```bash
.\start_rojo_port_34873.bat
```

## 🎉 Po naprawce:
- ✅ Trawa powinna być widoczna w Workspace
- ✅ Transporter powinien być niebieski i mieć ProximityPrompt
- ✅ Drzewa powinny być brązowe i widoczne
- ✅ Wszystkie skrypty powinny działać bez błędów
