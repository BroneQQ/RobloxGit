# 🚀 Kompletna konfiguracja Rojo + Cursor AI

## 📋 Lista kroków do wykonania

### 1. Instalacja Aftman
```bash
# Uruchom skrypt instalacyjny
install_aftman.bat
```

**Lub ręcznie:**
```powershell
Invoke-WebRequest -Uri "https://github.com/LPGhatguy/aftman/releases/latest/download/aftman-windows-x86_64.exe" -OutFile "aftman.exe"
.\aftman.exe self-install
```

### 2. Instalacja Rojo
```bash
# Po restarcie terminala
aftman install
```

### 3. Testowanie instalacji
```bash
# Sprawdź czy wszystko działa
test_rojo_connection.bat
```

### 4. Uruchomienie serwera Rojo
```bash
# Uruchom serwer
start_rojo.bat
```

### 5. Instalacja pluginu Rojo w Roblox Studio
1. Otwórz **Roblox Studio**
2. Przejdź do **View → Plugins**
3. Kliknij **Manage Plugins**
4. Wyszukaj **"Rojo"** i zainstaluj
5. Uruchom plugin w Roblox Studio

### 6. Połączenie z serwerem
1. W pluginie Rojo kliknij **"Connect"**
2. Wprowadź adres: `http://localhost:34872`
3. Kliknij **"Connect"**

### 7. Edycja w Cursorze
- Otwórz projekt w **Cursor AI**
- Edytuj pliki `.lua` w odpowiednich katalogach
- Zmiany automatycznie synchronizują się z Roblox Studio

## 📁 Struktura projektu

```
BrainrotSimulator/
├── 📄 default.project.json          # Konfiguracja Rojo
├── 🚀 start_rojo.bat               # Uruchomienie serwera
├── 🧪 test_rojo_connection.bat     # Test połączenia
├── ⚙️ install_aftman.bat          # Instalacja Aftman
├── 📁 .vscode/settings.json        # Konfiguracja Cursor
├── 📁 ReplicatedStorage/           # Synchronizowane z ReplicatedStorage
├── 📁 ServerScriptService/         # Synchronizowane z ServerScriptService
├── 📁 ServerStorage/               # Synchronizowane z ServerStorage
├── 📁 StarterGui/                  # Synchronizowane z StarterGui
└── 📁 StarterPlayerScripts/        # Synchronizowane z StarterPlayerScripts
```

## ✅ Weryfikacja konfiguracji

### Sprawdź czy Aftman działa:
```bash
aftman --version
```

### Sprawdź czy Rojo działa:
```bash
aftman run -- rojo --version
```

### Sprawdź połączenie:
```bash
test_rojo_connection.bat
```

## 🔧 Rozwiązywanie problemów

### Problem: Aftman nie jest rozpoznawany
- Uruchom ponownie terminal
- Sprawdź czy został dodany do PATH
- Spróbuj uruchomić jako administrator

### Problem: Rojo nie łączy się
- Sprawdź czy serwer jest uruchomiony
- Sprawdź czy port 34872 nie jest zajęty
- Sprawdź firewall

### Problem: Plugin nie łączy się
- Sprawdź czy plugin jest zainstalowany
- Sprawdź czy serwer Rojo działa
- Sprawdź adres połączenia

## 🎯 Korzyści

✅ **Lepsze edytowanie kodu** - Cursor AI z autouzupełnianiem
✅ **Automatyczna synchronizacja** - Zmiany w Cursorze → Roblox Studio
✅ **Kontrola wersji** - Git integration
✅ **Debugowanie** - Lepsze narzędzia debugowania
✅ **Współpraca** - Łatwiejsze współdzielenie kodu

## 📚 Przydatne pliki

- `ROJO_KONFIGURACJA.md` - Szczegółowa konfiguracja
- `ROJO_PLUGIN_INSTALACJA.md` - Instalacja pluginu
- `AFTMAN_INSTALACJA.md` - Instalacja Aftman
- `CURSOR_AI_SETUP.md` - Konfiguracja Cursor AI

## 🚀 Gotowe do użycia!

Po wykonaniu wszystkich kroków możesz:
1. Edytować kod w Cursorze
2. Automatycznie synchronizować z Roblox Studio
3. Korzystać z zaawansowanych funkcji Cursor AI
4. Debugować kod w czasie rzeczywistym
