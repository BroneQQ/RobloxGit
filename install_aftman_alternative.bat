@echo off
echo Installing Aftman - Alternative Methods
echo.

echo Method 1: Using winget (recommended)
echo.
winget install LPGhatguy.Aftman
if %errorlevel% equ 0 (
    echo.
    echo SUCCESS: Aftman installed via winget!
    echo Please restart your terminal and run: aftman install
    pause
    exit /b 0
)

echo.
echo Method 2: Manual download with curl
echo.
curl -L -o aftman.exe "https://github.com/LPGhatguy/aftman/releases/latest/download/aftman-windows-x86_64.exe"
if %errorlevel% equ 0 (
    echo.
    echo Installing Aftman...
    .\aftman.exe self-install
    if %errorlevel% equ 0 (
        echo.
        echo SUCCESS: Aftman installed!
        del aftman.exe
        echo Please restart your terminal and run: aftman install
        pause
        exit /b 0
    )
)

echo.
echo Method 3: Direct PowerShell download
echo.
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/LPGhatguy/aftman/releases/latest/download/aftman-windows-x86_64.exe' -OutFile 'aftman.exe' -UseBasicParsing}"
if %errorlevel% equ 0 (
    echo.
    echo Installing Aftman...
    .\aftman.exe self-install
    if %errorlevel% equ 0 (
        echo.
        echo SUCCESS: Aftman installed!
        del aftman.exe
        echo Please restart your terminal and run: aftman install
        pause
        exit /b 0
    )
)

echo.
echo All methods failed. Please try manual installation:
echo 1. Go to: https://github.com/LPGhatguy/aftman/releases
echo 2. Download aftman-windows-x86_64.exe
echo 3. Run: .\aftman-windows-x86_64.exe self-install
echo.

pause
