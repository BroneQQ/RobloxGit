@echo off
echo Testing Rojo connection...
echo.

echo Checking if Rojo is installed...
aftman run -- rojo --version
if %errorlevel% neq 0 (
    echo ERROR: Rojo is not installed or not accessible
    echo Please run: aftman install
    pause
    exit /b 1
)

echo.
echo Checking if port 34872 is available...
netstat -an | findstr :34872
if %errorlevel% equ 0 (
    echo WARNING: Port 34872 is already in use
    echo You may need to use a different port
) else (
    echo Port 34872 is available
)

echo.
echo Starting Rojo server for testing...
echo Press Ctrl+C to stop the test
echo.

aftman run -- rojo serve --port 34872 --verbose

pause
