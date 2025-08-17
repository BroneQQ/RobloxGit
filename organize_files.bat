@echo off
echo Organizing Roblox files...
echo.

echo Creating missing directories...
if not exist "ReplicatedStorage\Scripts" mkdir "ReplicatedStorage\Scripts"
if not exist "ServerScriptService\Scripts" mkdir "ServerScriptService\Scripts"
if not exist "StarterGui\Scripts" mkdir "StarterGui\Scripts"
if not exist "StarterPlayerScripts\Scripts" mkdir "StarterPlayerScripts\Scripts"

echo.
echo Copying files to appropriate locations...

REM Server Scripts
echo Copying server scripts...
copy "ROBLOX_SCRIPTS\1_WorldManager.lua" "ServerScriptService\WorldManager.lua" >nul
copy "ROBLOX_SCRIPTS\2_PlacementHandler.lua" "ServerScriptService\PlacementHandler.lua" >nul
copy "ROBLOX_SCRIPTS\5_InteractionScript.lua" "ServerStorage\InteractionScript.lua" >nul

REM Replicated Storage Scripts
echo Copying ReplicatedStorage scripts...
copy "ROBLOX_SCRIPTS\4_ClickLogic.lua" "ReplicatedStorage\ClickLogic.lua" >nul

REM StarterGui Scripts
echo Copying StarterGui scripts...
copy "ROBLOX_SCRIPTS\6_InventoryManager.lua" "StarterGui\InventoryManager.lua" >nul
copy "ROBLOX_SCRIPTS\8_GamePassHandler.lua" "StarterGui\GamePassHandler.lua" >nul
copy "ROBLOX_SCRIPTS\9_BackpackPromptGUI.lua" "StarterGui\BackpackPromptGUI.lua" >nul

REM StarterPlayerScripts
echo Copying StarterPlayerScripts...
copy "ROBLOX_SCRIPTS\7_CustomPromptHandler.lua" "StarterPlayerScripts\CustomPromptHandler.lua" >nul

echo.
echo Files organized successfully!
echo.
echo Now you need to:
echo 1. Disconnect Rojo plugin in Roblox Studio
echo 2. Reconnect Rojo plugin
echo 3. The files should now sync properly
echo.

pause
