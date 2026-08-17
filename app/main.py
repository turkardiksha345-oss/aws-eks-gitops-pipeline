from flask import Flask, render_template
import random

app = Flask(__name__)

QUOTES = [
    {"text": "The only way to do great work is to love what you do.", "author": "Steve Jobs"},
    {"text": "Innovation distinguishes between a leader and a follower.", "author": "Steve Jobs"},
    {"text": "Stay hungry, stay foolish.", "author": "Steve Jobs"},
    {"text": "The future belongs to those who believe in the beauty of their dreams.", "author": "Eleanor Roosevelt"},
    {"text": "It does not matter how slowly you go as long as you do not stop.", "author": "Confucius"},
    {"text": "Everything you can imagine is real.", "author": "Pablo Picasso"},
    {"text": "Simplicity is the ultimate sophistication.", "author": "Leonardo da Vinci"}
]

@app.route("/")
def home():
    quote = random.choice(QUOTES)
    return render_template("index.html", quote=quote)

@app.route("/health")
def health():
    return {"status": "healthy"}, 200

if __name__ == "__main__":
    # Run the app, listening on all interfaces so it works in a container
    app.run(host="0.0.0.0", port=8000)
