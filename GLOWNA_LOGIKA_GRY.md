# 🧠 Brainrot Simulator - Główna Logika Gry

## 🎯 Opis Gry
Brainrot Simulator to gra typu "Tycoon" w Roblox, gdzie gracze:
- Zbierają jajka spadające z taśmociągu
- Wylęgają z nich Brainroty (różne postacie)
- Ulepszają swoje Brainroty aby generowały więcej monet
- Sprzedają Brainroty za pieniądze
- Rozwijają swoją kolekcję i farmę

## ⚙️ Mechaniki Gry

### 1. System Jajek i Pity
- **4 rzadkości**: Common (80%), Rare (20%), Epic (pity po 50), Legendary (pity po 200)
- Jajka spadają co 5 sekund na taśmociąg gracza
- Gracz klika jajko → dostaje losowego Brainrota do ekwipunku
- System pity zapewnia Epic/Legendary po określonej liczbie prób

### 2. System Sadzenia i Inkubacji
- Gracz wybiera Brainrota z hotbara (1-9 lub klik)
- Sadzi go na swojej działce (ghost preview)
- Jajko inkubuje się przez określony czas:
  - Common: 5s
  - Rare: 15s  
  - Epic: 30s
  - Legendary: 45s
- Po inkubacji pojawia się żywy Brainrot

### 3. System Brainrotów
- **Ulepszanie**: Klik → wydaj monety → zwiększ level (max 30)
- **Wzrost**: Co 5 leveli Brainrot rośnie wizualnie (1.15x scale)
- **Dochód**: Każdy Brainrot generuje monety co 5s:
  - Common: 2 monety
  - Rare: 5 monet
  - Epic: 15 monet  
  - Legendary: 30 monet
- **Sprzedaż**: Przytrzymaj E → sprzedaj za: 10 + (level × 5) monet

### 4. System Ekwipunku i UI
- Hotbar pokazuje wszystkie jajka w ekwipunku
- Numery 1-9 do szybkiego wyboru
- Ghost preview podczas sadzenia
- Niestandardowy UI dla promptów sprzedaży

### 5. System Świata i Graczy
- Każdy gracz ma swoją działkę (600 jednostek odstępu)
- Własny taśmociąg z punktami spawn/end
- Limit 40 Brainrotów na gracza
- Automatyczny zapis danych: monety, pity, ekwipunek

## 🔧 Kluczowe Systemy

### WorldManager
- Tworzy działki i taśmociągi dla nowych graczy
- Zarządza systemem pity (Epic/Legendary)
- Automatyczny spawn jajek co 5s
- Zapis/odczyt danych gracza (DataStore)

### PlacementHandler  
- Sprawdza limit Brainrotów (40/gracz)
- Weryfikuje czy gracz ma jajko w ekwipunku
- Usuwa jajko z ekwipunku po posadzeniu
- Uruchamia inkubację z countdown

### InventoryManager
- Dynamiczny hotbar z jajkami
- Obsługa klawiszy 1-9
- Ghost preview podczas sadzenia
- Komunikacja z serwerem (PlaceEggRequest)

### InteractionScript (w każdym Brainrocie)
- Click → upgrade za monety
- Automatyczny dochód co 5s
- ProximityPrompt do sprzedaży
- System wzrostu co 5 leveli

### CustomPromptHandler
- Niestandardowy wygląd promptów sprzedaży
- Progress bar podczas przytrzymywania
- Wyświetla nazwę, level i cenę sprzedaży

## 🚨 Wymagane Naprawy

### 1. KRYTYCZNE - DataStore
**Problem**: `DataStoreService: AccessForbidden`
**Rozwiązanie**: HOME → Game Settings → Security → Włącz "Enable Studio Access to API Services"

### 2. Brakujące GUI
**Problem**: `ProximityPromptsGui` nie istnieje
**Rozwiązanie**: Stwórz ScreenGui o tej nazwie w StarterGui

### 3. Animacje i Meshes
**Problem**: Błędy ładowania animacji w modelach z Marketplace
**Rozwiązanie**: Usuń wszystkie obiekty typu Animation i Animate Script z modeli Brainrotów

### 4. Konfiguracja obrazków
**Problem**: `BRAINROT_IMAGE_IDS` jest puste
**Rozwiązanie**: Dodaj ID obrazków dla każdego Brainrota w InventoryManager

### 5. Offsety wysokości
**Problem**: `BRAINROT_Y_OFFSETS` jest niepełne  
**Rozwiązanie**: Ustaw wysokość spawnu dla każdego modelu Brainrota

## 📊 Ekonomia Gry

### Koszty Ulepszania
- Level 1→2: 20 monet
- Level 2→3: 30 monet
- Level N→N+1: (N+1) × 10 monet

### Dochody
- Common Brainrot level 1: 2 monety/5s = 24 monety/min
- Legendary Brainrot level 30: 30 monet/5s = 360 monet/min

### Ceny Sprzedaży
- Brainrot level 1: 15 monet
- Brainrot level 30: 160 monet

## 🎮 Flow Gracza

1. **Start**: Gracz dostaje 100 monet, działkę i taśmociąg
2. **Zbieranie**: Jajka spadają co 5s, gracz je klika
3. **Sadzenie**: Wybiera jajko z hotbara, sadzi na działce
4. **Czekanie**: Inkubacja 5-45s w zależności od rzadkości
5. **Zarządzanie**: Ulepszanie Brainrotów, zbieranie dochodów
6. **Ekspansja**: Więcej Brainrotów, wyższe levele, więcej monet
7. **Optymalizacja**: Sprzedaż słabszych, focus na mocniejsze

## 🔄 Pętle Gameplay

### Krótka Pętla (1-2 min)
Klik jajko → Posadź → Inkubacja → Ulepszaj

### Średnia Pętla (5-10 min)  
Zbieraj dochody → Ulepszaj wszystkie → Sadź nowe

### Długa Pętla (30+ min)
Optymalizuj farmę → Sprzedaj słabe → Focus na Epic/Legendary

## 📈 Progresja

### Early Game (0-500 monet)
- Sadź wszystkie Common/Rare
- Ulepszaj do ~level 5-10
- Zbieraj podstawowe dochody

### Mid Game (500-5000 monet)
- Focus na Epic Brainroty (pity po 50)
- Sprzedawaj słabe Common
- Ulepszaj Epic do level 15-20

### Late Game (5000+ monet)
- Czekaj na Legendary (pity po 200)
- Maksymalne levele (30)
- Optymalna farma 40 najlepszych Brainrotów
