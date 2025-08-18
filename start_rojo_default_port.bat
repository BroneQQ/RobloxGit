@echo off
echo Starting Rojo server on default port...
echo.

echo Adding Aftman to PATH...
set PATH=%PATH%;%USERPROFILE%\.aftman\bin

echo.
echo Checking if Rojo is available...
rojo --version
if %errorlevel% neq 0 (
    echo ERROR: Rojo is not available
    echo Please run: aftman install
    pause
    exit /b 1
)

echo.
echo Starting Rojo server on default port...
echo Server will be available at the default Rojo port
echo.
echo Make sure you have the Rojo plugin installed in Roblox Studio!
echo.
echo Press Ctrl+C to stop the server
echo.

rojo serve

pause

