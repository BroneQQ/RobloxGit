# ✅ Aftman zainstalowany! - Następne kroki

## 🎉 Sukces!
Aftman został pomyślnie zainstalowany przez winget!

## 📋 Co teraz zrobić:

### 1. Zrestartuj terminal
- **Zamknij wszystkie okna terminala/PowerShell**
- **Otwórz nowy terminal** w folderze projektu
- **Uruchom**: `check_aftman.bat`

### 2. Alternatywnie - ręczne sprawdzenie
Po restarcie terminala uruchom:
```bash
aftman --version
```

Jeśli działa, uruchom:
```bash
aftman install
```

### 3. Testowanie Rojo
Po instalacji Rojo sprawdź:
```bash
aftman run -- rojo --version
```

### 4. Uruchomienie serwera
```bash
start_rojo.bat
```

### 5. Instalacja pluginu w Roblox Studio
1. Otwórz **Roblox Studio**
2. Przejdź do **View → Plugins**
3. Kliknij **Manage Plugins**
4. Wyszukaj **"Rojo"** i zainstaluj
5. Uruchom plugin

### 6. Połączenie z serwerem
1. W pluginie Rojo kliknij **"Connect"**
2. Wprowadź: `http://localhost:34872`
3. Kliknij **"Connect"**

### 7. Edycja w Cursorze
- Otwórz projekt w **Cursor AI**
- Edytuj pliki `.lua` w odpowiednich katalogach
- Zmiany automatycznie synchronizują się z Roblox Studio

## 🔧 Jeśli coś nie działa:

### Problem: Aftman nadal nie jest rozpoznawany
- Uruchom terminal **jako administrator**
- Sprawdź czy PATH został zaktualizowany
- Spróbuj uruchomić ponownie komputer

### Problem: Błąd podczas instalacji Rojo
- Sprawdź połączenie z internetem
- Uruchom `aftman install` ponownie
- Sprawdź czy `aftman.toml` jest poprawny

### Problem: Serwer Rojo nie uruchamia się
- Sprawdź czy port 34872 nie jest zajęty
- Uruchom `test_rojo_connection.bat`
- Sprawdź firewall

## 📁 Przydatne pliki:

- `check_aftman.bat` - Sprawdza instalację i instaluje Rojo
- `start_rojo.bat` - Uruchamia serwer Rojo
- `test_rojo_connection.bat` - Testuje połączenie
- `ROJO_PLUGIN_INSTALACJA.md` - Instrukcja instalacji pluginu

## 🚀 Gotowe do użycia!

Po wykonaniu wszystkich kroków będziesz mógł:
- Edytować kod Roblox w Cursorze
- Automatycznie synchronizować z Roblox Studio
- Korzystać z zaawansowanych funkcji Cursor AI
- Debugować kod w czasie rzeczywistym
