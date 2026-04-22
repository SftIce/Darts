@echo off
setlocal
title Pro Darts V2 - Unified Installer
color 0E

echo ======================================================
echo           PRO DARTS V2 - INSTALLATION SETUP           
echo ======================================================
echo.
echo Target Project: E:\Darts
echo.

:: Move to the project directory
cd /d "E:\Darts"

:: 1. Clean previous builds to prevent conflicts
echo [1/4] Cleaning old build files...
call flutter clean
echo.

:: 2. Build Windows Version
echo [2/4] Building Windows Desktop Version (Release)...
call flutter build windows
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Windows build failed. 
    echo Ensure Visual Studio "Desktop development with C++" is installed.
    pause
    exit /b
)

:: 3. Build Web Version
echo [3/4] Building Browser Version (CanvasKit)...
call flutter build web --web-renderer canvaskit
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Web build failed.
    pause
    exit /b
)

:: 4. Create Launcher Batch Files
echo [4/4] Creating Launchers in E:\Darts...

:: Desktop Launcher
(
echo @echo off
echo start "" "E:\Darts\build\windows\x64\runner\Release\darts.exe"
) > "Launch_Darts_Windows.bat"

:: Browser Launcher (Runs a local temporary server to avoid CORS issues)
(
echo @echo off
echo echo Starting local web server for Pro Darts...
echo start "" flutter run -d chrome --release
) > "Launch_Darts_Browser.bat"

echo.
echo ======================================================
echo             INSTALLATION SUCCESSFUL!
echo ======================================================
echo.
echo 1. Use 'Launch_Darts_Windows.bat' for the Desktop App.
echo 2. Use 'Launch_Darts_Browser.bat' for the Browser App.
echo.
echo Note: The Windows version is recommended for 
echo E:\Darts asset loading and local file persistence.
echo ======================================================
echo.
pause