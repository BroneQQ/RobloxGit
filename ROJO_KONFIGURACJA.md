# Konfiguracja Rojo dla Cursor AI

## Krok 1: Uruchomienie serwera Rojo

1. Otwórz terminal w folderze projektu
2. Uruchom skrypt: `start_rojo.bat`
3. Serwer Rojo będzie dostępny na porcie 34872

## Krok 2: Instalacja pluginu Rojo w Roblox Studio

1. Otwórz Roblox Studio
2. Przejdź do **View** → **Plugins**
3. Kliknij **Manage Plugins**
4. Wyszukaj "Rojo" i zainstaluj plugin "Rojo"
5. Uruchom plugin w Roblox Studio

## Krok 3: Połączenie z serwerem Rojo

1. W Roblox Studio, w pluginie Rojo:
   - Kliknij **Connect**
   - Wprowadź adres: `http://localhost:34872`
   - Kliknij **Connect**

## Krok 4: Edycja w Cursorze

Teraz możesz edytować pliki Lua w Cursorze:
- `ReplicatedStorage/` - pliki będą synchronizowane z ReplicatedStorage
- `ServerScriptService/` - pliki będą synchronizowane z ServerScriptService
- `ServerStorage/` - pliki będą synchronizowane z ServerStorage
- `StarterGui/` - pliki będą synchronizowane z StarterGui
- `StarterPlayerScripts/` - pliki będą synchronizowane z StarterPlayerScripts

## Struktura projektu

```
BrainrotSimulator/
├── default.project.json    # Konfiguracja Rojo
├── start_rojo.bat         # Skrypt uruchamiający serwer
├── ReplicatedStorage/     # Synchronizowane z ReplicatedStorage
├── ServerScriptService/   # Synchronizowane z ServerScriptService
├── ServerStorage/         # Synchronizowane z ServerStorage
├── StarterGui/           # Synchronizowane z StarterGui
└── StarterPlayerScripts/ # Synchronizowane z StarterPlayerScripts
```

## Rozwiązywanie problemów

### Problem: Nie można połączyć się z serwerem
- Sprawdź czy serwer Rojo jest uruchomiony
- Sprawdź czy port 34872 nie jest zajęty
- Uruchom ponownie `start_rojo.bat`

### Problem: Zmiany nie synchronizują się
- Sprawdź czy plugin Rojo jest aktywny w Roblox Studio
- Sprawdź czy połączenie jest aktywne
- Spróbuj ponownie połączyć się z serwerem

### Problem: Błędy w plikach Lua
- Sprawdź składnię Lua w Cursorze
- Użyj wtyczki Lua Language Server w Cursorze
- Sprawdź logi w Roblox Studio

## Korzyści z używania Rojo z Cursorem

1. **Lepsze edytowanie kodu**: Cursor AI z autouzupełnianiem i analizą kodu
2. **Automatyczna synchronizacja**: Zmiany w Cursorze automatycznie pojawiają się w Roblox Studio
3. **Kontrola wersji**: Możliwość używania Git do śledzenia zmian
4. **Współpraca**: Łatwiejsze współdzielenie kodu z zespołem
5. **Debugowanie**: Lepsze narzędzia do debugowania kodu Lua
