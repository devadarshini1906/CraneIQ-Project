@echo off
title 🚀 MAXIM BACKEND SERVER
echo ==================================
echo    MAXIM AI BACKEND SERVER
echo ==================================
echo Starting Flask server with Groq AI...
echo.

cd /d "C:\PROJECTS\ai_chatbot_backend"
call venv\Scripts\activate

echo ✅ Virtual environment activated
echo 🐍 Python dependencies loaded
echo 🔧 Starting AI server...
echo.
echo 📍 API will run at: http://127.0.0.1:5000
echo 📍 Health check: http://127.0.0.1:5000/health
echo.
echo ⏳ Please wait for server to start...
echo 🛑 Press Ctrl+C to stop the server
echo ==================================
echo.

python app.py

pause