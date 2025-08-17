# 🧠 Brainrot Simulator - Kompletny Projekt

## 📖 Opis Projektu
Brainrot Simulator to zaawansowana gra typu "Tycoon" dla Roblox, gdzie gracze:
- 🥚 Zbierają jajka spadające z taśmociągu
- 🐣 Wylęgają unikalne Brainroty (4 rzadkości)
- ⬆️ Ulepszają swoje Brainroty za monety
- 💰 Generują pasywny dochód
- 🏪 Sprzedają Brainroty za lepsze ceny

## 🎯 Kluczowe Mechaniki
- **System Pity**: Epic po 50 próbach, Legendary po 200
- **Automatyczny spawn**: Jajka co 5 sekund
- **Inkubacja**: 5-45s w zależności od rzadkości
- **Progresja**: Ulepszanie do poziomu 30
- **Ekonomia**: Zbalansowane koszty i dochody
- **Multiplayer**: Każdy gracz ma własną działkę

## 📁 Struktura Projektu

```
BrainrotSimulator/
├── 📜 GLOWNA_LOGIKA_GRY.md      # Szczegółowy opis mechanik
├── 📜 INSTRUKCJA_INSTALACJI.md  # Krok po kroku instalacja
├── 📜 KONFIGURACJA_MODELI.md    # Jak skonfigurować modele
├── 📜 ROZWIAZYWANIE_PROBLEMOW.md # Diagnoza i naprawy
├── 📂 ServerScriptService/
│   ├── WorldManager.lua         # Zarządzanie światem i graczami
│   └── PlacementHandler.lua     # Sadzenie i inkubacja jajek
├── 📂 ServerStorage/
│   └── InteractionScript.lua   # Logika Brainrotów (upgrade/income/sell)
├── 📂 ReplicatedStorage/
│   └── ClickLogic.lua          # Klikanie jajek i losowanie
├── 📂 StarterGui/
│   └── InventoryManager.lua    # UI ekwipunku i sadzenia
└── 📂 StarterPlayerScripts/
    └── CustomPromptHandler.lua # Niestandardowy UI sprzedaży
```

## 🚀 Szybki Start

### 1. NAJPIERW - Włącz API Services!
```
HOME → Game Settings → Security → Enable Studio Access to API Services ✅
```

### 2. Skopiuj strukturę do Roblox Studio:
1. Przeczytaj `INSTRUKCJA_INSTALACJI.md`
2. Stwórz strukturę w Explorer zgodnie z instrukcją
3. Skopiuj skrypty do odpowiednich miejsc
4. Skonfiguruj modele według `KONFIGURACJA_MODELI.md`

### 3. Uruchom i testuj:
- Jajka powinny spadać co 5s
- Kliknij jajko → dostaniesz Brainrota
- Wciśnij 1-9 → wybierz jajko z hotbara
- Kliknij na działce → posadź jajko
- Czekaj na inkubację → pojawi się Brainrot
- Kliknij Brainrota → ulepsz za monety
- Przytrzymaj E → sprzedaj Brainrota

## 🔧 Wymagane Uzupełnienia

### W PlacementHandler.lua (linia 20):
```lua
local BRAINROT_Y_OFFSETS = {
    ["Common_BrainrotA"] = 2.5,
    -- DODAJ WSZYSTKIE SWOJE MODELE!
}
```

### W InventoryManager.lua (linia 16):
```lua
local BRAINROT_IMAGE_IDS = {
    ["Common_BrainrotA"] = "rbxassetid://TWOJE_ID",
    -- DODAJ ID OBRAZKÓW DLA WSZYSTKICH MODELI!
}
```

## 🎮 Mechaniki Gry

### Rzadkości i Szanse:
- **Common**: 80% (5s inkubacja, 2 monety/5s)
- **Rare**: 20% (15s inkubacja, 5 monet/5s)  
- **Epic**: Pity po 50 (30s inkubacja, 15 monet/5s)
- **Legendary**: Pity po 200 (45s inkubacja, 30 monet/5s)

### Ekonomia:
- **Ulepszanie**: Level N→N+1 kosztuje (N+1)×10 monet
- **Sprzedaż**: 10 + (level×5) monet
- **Wzrost**: Co 5 leveli Brainrot rośnie o 15%
- **Limit**: 40 Brainrotów na gracza

## 🚨 Częste Problemy

| Problem | Rozwiązanie |
|---------|-------------|
| DataStoreService: AccessForbidden | Włącz API Services! |
| Infinite yield ProximityPromptsGui | Stwórz ScreenGui o tej nazwie |
| Jajka nie spadają | Sprawdź PlayerPlotTemplate i ConveyorBelt |
| Nie można kliknąć jajek | Dodaj ClickDetector do PrimaryPart |
| Brainroty nie pojawiają się | Ustaw PrimaryPart i Y_OFFSETS |

Więcej w `ROZWIAZYWANIE_PROBLEMOW.md`

## 📊 Status Projektu

✅ **Gotowe**:
- Kompletny system spawnu jajek
- Pełny system pity (Epic/Legendary)
- Funkcjonalny ekwipunek z hotbarem
- System sadzenia z ghost preview
- Inkubacja z countdown
- Ulepszanie i wzrost Brainrotów
- Pasywny dochód
- Sprzedaż z niestandardowym UI
- Zapis/odczyt danych gracza
- Multiplayer (każdy gracz ma działkę)

⚠️ **Do Uzupełnienia**:
- ID obrazków w BRAINROT_IMAGE_IDS
- Wysokości spawnu w BRAINROT_Y_OFFSETS  
- Modele PlayerPlotTemplate i ConveyorBelt
- Folder Data w każdym modelu Brainrota

## 🎯 Następne Kroki

1. **Przeczytaj wszystkie pliki .md** - zawierają kluczowe informacje
2. **Skonfiguruj modele** według instrukcji
3. **Uzupełnij tabele** w skryptach
4. **Przetestuj każdą mechanikę** osobno
5. **Użyj narzędzi diagnostycznych** z pliku problemów

## 📞 Wsparcie

Jeśli masz problemy:
1. Sprawdź Output w Roblox Studio
2. Przeczytaj `ROZWIAZYWANIE_PROBLEMOW.md`
3. Użyj skryptów diagnostycznych z Command Bar
4. Sprawdź czy wszystkie wymagania są spełnione

---

**Projekt stworzony na podstawie podsumowania z Gemini AI**  
**Wersja**: 2.1 (Sierpień 2025)  
**Kompatybilność**: Roblox Studio (najnowsza wersja)
