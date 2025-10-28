@echo off
title 📱 MAXIM FLUTTER FRONTEND
echo ==================================
echo    MAXIM FLUTTER FRONTEND
echo ==================================
echo Starting Flutter WEB application...
echo.

cd /d "C:\PROJECTS\flutter_application_1"

echo ✅ Current directory: %CD%
echo.

echo 🔍 Checking Flutter project...
if not exist "pubspec.yaml" (
    echo ❌ ERROR: Not a valid Flutter project!
    echo Please check the path in this batch file
    pause
    exit
)

echo 🎯 Configuring for WEB only...
flutter config --enable-web

echo 🧹 Cleaning previous builds...
flutter clean

echo 📦 Getting Flutter packages...
flutter pub get

echo 🌐 Launching in Chrome (WEB ONLY)...
echo.
echo ⚠️  If Chrome doesn't open, check for errors above!
echo 📍 App will open at: http://localhost:5000
echo 🛑 Press 'q' to quit the Flutter server
echo ==================================
echo.

flutter run -d chrome --web-port=5000 --web-hostname=127.0.0.1

echo.
echo ==================================
echo ❌ Flutter app closed or failed!
echo Check the errors above and press any key to close...
pause