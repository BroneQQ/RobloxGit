# 🚀 Uruchomienie skryptu WorldSetup w Roblox Studio

## 🎯 **Metoda 1: Uruchom przez Output (Zalecana)**

1. **W Roblox Studio, otwórz Output:**
   - Przejdź do **View** → **Output**
   - Lub naciśnij **F9**

2. **W Output wpisz komendę:**
   ```lua
   require(game.ServerScriptService.WorldSetup)
   ```

3. **Naciśnij Enter**

4. **Sprawdź czy pojawiły się komunikaty:**
   ```
   Starting world setup...
   Ground created successfully!
   Transporter created successfully!
   Tree1 created successfully!
   Tree2 created successfully!
   World setup completed!
   ```

## 🎯 **Metoda 2: Uruchom przez Command Bar**

1. **W Roblox Studio, otwórz Command Bar:**
   - Przejdź do **View** → **Command Bar**
   - Lub naciśnij **Ctrl+Shift+P**

2. **Wpisz komendę:**
   ```lua
   require(game.ServerScriptService.WorldSetup)
   ```

3. **Naciśnij Enter**

## 🎯 **Metoda 3: Sprawdź ustawienia skryptu**

1. **W Roblox Studio, przejdź do ServerScriptService**
2. **Kliknij na WorldSetup.lua**
3. **W Properties sprawdź:**
   - **Disabled** = false
   - **RunContext** = Server

## 🎯 **Metoda 4: Uruchom przez Test**

1. **W Roblox Studio, kliknij "Play" (▶️)**
2. **Otwórz Output (F9)**
3. **Sprawdź czy skrypt się uruchomił automatycznie**

## 🔍 **Sprawdź czy obiekty się pojawiły:**

### W Workspace powinny być:
- **Ground** - zielona trawa (100x1x100)
- **Transporter** - niebieski transporter z ProximityPrompt
- **Tree1** - brązowe drzewo w pozycji (20, 5, 20)
- **Tree2** - brązowe drzewo w pozycji (-20, 4, -20)

### W Output powinny być komunikaty:
```
Starting world setup...
Ground created successfully!
Transporter created successfully!
Tree1 created successfully!
Tree2 created successfully!
World setup completed!
Objects in workspace:
  - Ground at (0, -0.5, 0)
  - Transporter at (0, 0.5, 50)
  - Tree1 at (20, 5, 20)
  - Tree2 at (-20, 4, -20)
```

## 🚨 **Jeśli skrypt nie działa:**

### Problem: "require" nie działa
- Sprawdź czy skrypt jest w ServerScriptService
- Sprawdź czy nazwa pliku to dokładnie "WorldSetup.lua"

### Problem: Brak komunikatów w Output
- Sprawdź czy Output jest otwarty (F9)
- Sprawdź czy nie ma błędów w Output

### Problem: Obiekty się nie pojawiają
- Sprawdź czy skrypt został uruchomiony
- Sprawdź czy nie ma błędów w Output
- Sprawdź czy obiekty nie są ukryte

## ✅ **Po udanym uruchomieniu:**

1. **Sprawdź Workspace** - obiekty powinny być widoczne
2. **Sprawdź Output** - komunikaty o utworzeniu obiektów
3. **Testuj grę** - kliknij Play i sprawdź czy wszystko działa

## 🎉 **Sukces!**

Po udanym uruchomieniu skryptu będziesz mieć:
- ✅ Zieloną trawę (Ground)
- ✅ Niebieski transporter z ProximityPrompt
- ✅ Dwa brązowe drzewa
- ✅ Wszystkie obiekty świata gotowe do użycia

