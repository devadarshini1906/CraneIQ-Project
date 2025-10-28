@echo off
title 🐛 DEBUG FLUTTER CRASH
echo ==================================
echo    DEBUGGING FLUTTER CRASH
echo ==================================
echo This window will stay open to show the error...
echo.

cd /d "C:\PROJECTS\flutter_application_1"

echo Step 1: Cleaning...
flutter clean

echo.
echo Step 2: Getting packages...
flutter pub get

echo.
echo Step 3: Building web version...
echo ⚠️  WAITING FOR ERROR MESSAGE BELOW...
echo ==================================
echo.

flutter build web --verbose

echo.
echo ==================================
echo ❌ BUILD FAILED - Check error above!
echo Press any key to close...
pause >nul