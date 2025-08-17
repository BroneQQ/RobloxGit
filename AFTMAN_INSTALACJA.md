# Instalacja Aftman

## Krok 1: Pobranie Aftman

### Windows (PowerShell)
```powershell
# Pobierz i zainstaluj Aftman
Invoke-WebRequest -Uri "https://github.com/LPGhatguy/aftman/releases/latest/download/aftman-windows-x86_64.exe" -OutFile "aftman.exe"
.\aftman.exe self-install
```

### Alternatywnie przez winget
```powershell
winget install LPGhatguy.Aftman
```

### Lub przez Chocolatey
```powershell
choco install aftman
```

## Krok 2: Weryfikacja instalacji

Po instalacji, uruchom ponownie terminal i sprawdź:
```powershell
aftman --version
```

## Krok 3: Instalacja narzędzi

W folderze projektu uruchom:
```powershell
aftman install
```

To zainstaluje Rojo zgodnie z konfiguracją w `aftman.toml`.

## Krok 4: Testowanie

Sprawdź czy Rojo działa:
```powershell
aftman run -- rojo --version
```

## Rozwiązywanie problemów

### Problem: "aftman is not recognized"
- Uruchom ponownie terminal/PowerShell
- Sprawdź czy Aftman został dodany do PATH
- Spróbuj uruchomić jako administrator

### Problem: Błąd podczas instalacji
- Sprawdź połączenie z internetem
- Spróbuj uruchomić PowerShell jako administrator
- Sprawdź czy antywirus nie blokuje instalacji

### Problem: Rojo nie instaluje się
- Sprawdź czy `aftman.toml` jest poprawny
- Uruchom `aftman install` ponownie
- Sprawdź logi błędów

## Po instalacji

Po pomyślnej instalacji możesz:
1. Uruchomić `start_rojo.bat` aby uruchomić serwer Rojo
2. Połączyć plugin Rojo w Roblox Studio
3. Edytować kod w Cursorze
