from flask import Flask, request, jsonify
from flask_cors import CORS
import openai
import threading
import time

app = Flask(__name__)
CORS(app)  # Enable CORS for front-end communication

# OpenAI API Key
openai.api_key = "your_openai_api_key"

# In-memory storage for logs (replace with a database in production)
diet_logs = []
workout_logs = []
run_logs = []

# Reminder function
def send_reminders():
    while True:
        print("Reminder: Drink water!")
        time.sleep(3600)  # Remind every hour
        print("Reminder: Do 10 push-ups!")
        time.sleep(7200)  # Remind every 2 hours

# Start reminder thread
reminder_thread = threading.Thread(target=send_reminders)
reminder_thread.daemon = True
reminder_thread.start()

# Diet Tracking Endpoint
@app.route('/log_diet', methods=['POST'])
def log_diet():
    data = request.json
    diet_logs.append(data)
    return jsonify({"message": "Diet logged successfully!"})

# Workout Tracking Endpoint
@app.route('/log_workout', methods=['POST'])
def log_workout():
    data = request.json
    workout_logs.append(data)
    return jsonify({"message": "Workout logged successfully!"})

# Run Tracking Endpoint
@app.route('/log_run', methods=['POST'])
def log_run():
    data = request.json
    run_logs.append(data)
    return jsonify({"message": "Run logged successfully!"})

# AI Assistant Endpoint
@app.route('/ask_ai', methods=['POST'])
def ask_ai():
    user_input = request.json.get("message")
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=[{"role": "user", "content": user_input}]
    )
    return jsonify({"response": response['choices'][0]['message']['content']})

# Run the Flask app
if __name__ == '__main__':
    app.run(debug=True)
