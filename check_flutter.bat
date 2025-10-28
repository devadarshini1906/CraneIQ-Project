@echo off
title Check Flutter Setup
echo ==================================
echo    FLUTTER CONFIGURATION CHECK
echo ==================================

echo 1. Checking Flutter version...
flutter --version

echo.
echo 2. Checking Flutter configuration...
flutter config

echo.
echo 3. Checking available devices...
flutter devices

echo.
echo 4. Checking web support...
flutter doctor -v | findstr "web"

echo.
echo ==================================
echo ✅ Check complete! 
echo Share the output with me for next steps.
pause