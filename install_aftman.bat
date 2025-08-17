@echo off
echo Installing Aftman...
echo.

echo Downloading Aftman...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/LPGhatguy/aftman/releases/latest/download/aftman-windows-x86_64.exe' -OutFile 'aftman.exe'"

if %errorlevel% neq 0 (
    echo ERROR: Failed to download Aftman
    echo Please check your internet connection
    pause
    exit /b 1
)

echo.
echo Installing Aftman...
.\aftman.exe self-install

if %errorlevel% neq 0 (
    echo ERROR: Failed to install Aftman
    echo Please try running as administrator
    pause
    exit /b 1
)

echo.
echo Cleaning up...
del aftman.exe

echo.
echo Aftman installed successfully!
echo Please restart your terminal and run: aftman install
echo.

pause
