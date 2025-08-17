@echo off
echo Starting Rojo server...
echo.
echo Make sure you have the Rojo plugin installed in Roblox Studio!
echo.
echo Server will be available at: http://localhost:34872
echo.
echo Press Ctrl+C to stop the server
echo.

aftman run -- rojo serve --port 34872

pause
