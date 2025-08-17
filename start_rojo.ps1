Write-Host "Starting Rojo server..." -ForegroundColor Green
Write-Host ""

# Add Aftman to PATH
$env:PATH += ";$env:USERPROFILE\.aftman\bin"

Write-Host "Checking if Rojo is available..." -ForegroundColor Yellow
try {
    $rojoVersion = rojo --version
    Write-Host "Rojo version: $rojoVersion" -ForegroundColor Green
}
catch {
    Write-Host "ERROR: Rojo is not available" -ForegroundColor Red
    Write-Host "Please run: aftman install" -ForegroundColor Yellow
    Read-Host "Press Enter to continue"
    exit 1
}

Write-Host ""
Write-Host "Starting Rojo server on port 34872..." -ForegroundColor Green
Write-Host "Server will be available at: http://localhost:34872" -ForegroundColor Cyan
Write-Host ""
Write-Host "Make sure you have the Rojo plugin installed in Roblox Studio!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

# Start Rojo server
rojo serve --port 34872
