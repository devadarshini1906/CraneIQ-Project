from flask import Flask, request, jsonify
from flask_cors import CORS
import requests
import os
import time
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
CORS(app)

# Groq API Configuration
GROQ_API_KEY = os.getenv('GROQ_API_KEY')
GROQ_API_URL = "https://api.groq.com/openai/v1/chat/completions"

conversation_history = {}

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "MAXIM AI with Groq is running! 🚀"})

@app.route('/chat', methods=['POST'])
def chat_endpoint():
    try:
        data = request.json
        user_id = data.get('user_id', 'default_user')
        user_message = data.get('message', '').strip()
        
        if not user_message:
            return jsonify({"error": "No message provided"}), 400
        
        print(f"📨 Received: {user_message}")
        
        # System prompt for CraneIQ
        system_prompt = """You are MAXIM AI - a helpful assistant for CraneIQ. 
        Answer all questions clearly and use emojis. Be friendly and concise."""
        
        messages = [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_message}
        ]
        
        # Call Groq API
        headers = {
            "Authorization": f"Bearer {GROQ_API_KEY}",
            "Content-Type": "application/json"
        }
        
        payload = {
            "messages": messages,
            "model": "llama-3.1-8b-instant",
            "temperature": 0.7,
            "max_tokens": 150,
        }
        
        response = requests.post(GROQ_API_URL, json=payload, headers=headers)
        response_data = response.json()
        
        if response.status_code == 200:
            ai_response = response_data['choices'][0]['message']['content']
            return jsonify({
                "success": True,
                "reply": ai_response
            })
        else:
            return jsonify({
                "success": False,
                "reply": "I'm learning fast! Try again! ⚡"
            })
            
    except Exception as e:
        return jsonify({
            "success": False,
            "reply": "MAXIM AI is optimizing! Ask me anything! 🔧"
        })

# 🔥 FIXED LINE - Changed '_main_' to '__main__'
if __name__ == '__main__':
    print("🚀 MAXIM AI with Groq Started!")
    print("💬 Ready for questions!")
    app.run(host='0.0.0.0', port=5000)