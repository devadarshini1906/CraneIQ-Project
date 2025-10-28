@echo off
title 🐛 FLUTTER DEBUG - Capturing Errors
echo ==================================
echo    CAPTURING FLUTTER ERRORS
echo ==================================

cd /d "C:\PROJECTS\flutter_application_1"

echo 🎯 Testing Flutter build...
echo This may take a moment...

:: Run flutter commands and save output to file
flutter clean > debug_log.txt 2>&1
flutter pub get >> debug_log.txt 2>&1
flutter run -d chrome --verbose >> debug_log.txt 2>&1

echo.
echo ✅ Debug complete!
echo 📁 Error log saved as: debug_log.txt
echo.
echo 📋 Please open debug_log.txt and share the errors
echo.

notepad debug_log.txt
pause