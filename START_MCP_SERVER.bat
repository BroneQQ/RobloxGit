@echo off
echo.
echo ========================================
echo    🧠 Brainrot Simulator MCP Server
echo ========================================
echo.

cd /d "%~dp0MCP_Server"

echo 📋 Sprawdzanie Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js nie jest zainstalowany!
    echo 📥 Pobierz z: https://nodejs.org/
    pause
    exit /b 1
)

echo ✅ Node.js znaleziony
echo.

echo 📦 Sprawdzanie zależności...
if not exist "node_modules" (
    echo 📥 Instalowanie zależności...
    npm install
    if errorlevel 1 (
        echo ❌ Błąd instalacji zależności!
        pause
        exit /b 1
    )
)

echo ✅ Zależności gotowe
echo.

echo 🔧 Sprawdzanie konfiguracji...
if not exist ".env" (
    echo ⚙️ Tworzenie pliku konfiguracyjnego...
    copy "env_example.txt" ".env" >nul 2>&1
    echo ✅ Plik .env utworzony z domyślnymi ustawieniami
)

echo.
echo 🚀 Uruchamianie MCP Server...
echo 🔗 Server będzie dostępny na: http://localhost:3000
echo 📊 Analytics: http://localhost:3000/api/analytics
echo ❤️ Health check: http://localhost:3000/health
echo.
echo 💡 Aby zatrzymać serwer, wciśnij Ctrl+C
echo.

npm start

echo.
echo 🛑 Serwer zatrzymany
pause
