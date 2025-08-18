# Uruchomienie WorldSetup.lua

## Problem
Błąd "Module code did not return exactly one value" występuje, gdy próbujesz uruchomić `WorldSetup.lua` za pomocą `require()`.

## Rozwiązanie

### Metoda 1: Automatyczne uruchomienie (ZALECANE)
1. **Po prostu kliknij "Play" w Roblox Studio**
2. Skrypt `WorldSetup.lua` uruchomi się automatycznie
3. Sprawdź Output (Ctrl+Shift+O) aby zobaczyć komunikaty

### Metoda 2: Ręczne uruchomienie (jeśli potrzebne)
Jeśli chcesz uruchomić skrypt ręcznie:

1. **W Command Bar (Ctrl+Shift+F9) wpisz:**
   ```lua
   require(game.ServerScriptService.WorldSetup)()
   ```
   (zwróć uwagę na `()` na końcu!)

2. **Lub w Output (Ctrl+Shift+O) wpisz:**
   ```lua
   local worldSetup = require(game.ServerScriptService.WorldSetup)
   worldSetup()
   ```

## Co robi WorldSetup.lua?
- Tworzy podstawowe obiekty świata:
  - **Ground** - trawa (100x100)
  - **Transporter** - transporter z ProximityPrompt
  - **Tree1** i **Tree2** - dekoracyjne drzewa

## Sprawdzenie czy działa
Po uruchomieniu powinieneś zobaczyć w Output:
```
Starting world setup...
Ground created successfully!
Transporter created successfully!
Tree1 created successfully!
Tree2 created successfully!
World setup completed!
Objects in workspace:
  - Ground at 0, -0.5, 0
  - Transporter at 0, 0.5, 50
  - Tree1 at 20, 5, 20
  - Tree2 at -20, 4, -20
```

## Ważne
- Skrypt sprawdza czy obiekty już istnieją przed ich utworzeniem
- Jeśli obiekty już istnieją, zostaną pominięte
- Skrypt uruchamia się automatycznie gdy gra się startuje

