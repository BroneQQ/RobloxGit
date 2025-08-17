@echo off
echo Checking Aftman installation...
echo.

echo Testing if aftman is available...
aftman --version
if %errorlevel% equ 0 (
    echo.
    echo SUCCESS: Aftman is working!
    echo.
    echo Installing Rojo...
    aftman install
    if %errorlevel% equ 0 (
        echo.
        echo SUCCESS: Rojo installed!
        echo.
        echo Testing Rojo...
        aftman run -- rojo --version
        if %errorlevel% equ 0 (
            echo.
            echo SUCCESS: Everything is ready!
            echo.
            echo You can now:
            echo 1. Run: start_rojo.bat
            echo 2. Install Rojo plugin in Roblox Studio
            echo 3. Connect plugin to http://localhost:34872
            echo 4. Edit code in Cursor AI
        ) else (
            echo.
            echo ERROR: Rojo is not working properly
        )
    ) else (
        echo.
        echo ERROR: Failed to install Rojo
    )
) else (
    echo.
    echo ERROR: Aftman is not available
    echo Please restart your terminal and try again
    echo.
    echo If the problem persists, try:
    echo 1. Close all terminal windows
    echo 2. Open a new terminal as administrator
    echo 3. Run this script again
)

echo.
pause
