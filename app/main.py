import secrets
from flask import Flask, render_template

app = Flask(__name__)

QUOTES = [
    {"text": "The only way to do great work is to love what you do.", "author": "Steve Jobs"},
    {"text": "Innovation distinguishes between a leader and a follower.", "author": "Steve Jobs"},
    {"text": "The future belongs to those who believe in the beauty of their dreams.", "author": "Eleanor Roosevelt"},
    {"text": "It does not matter how slowly you go as long as you do not stop.", "author": "Confucius"},
    {"text": "Everything you can imagine is real.", "author": "Pablo Picasso"},
    {"text": "The only way to do great work is to love what you do.", "author": "Steve Jobs"},
    {"text": "Believe you can and you're halfway there.", "author": "Theodore Roosevelt"},
    {"text": "The future depends on what you do today.", "author": "Mahatma Gandhi"},
    {"text": "Success is not final, failure is not fatal: it is the courage to continue that counts.", "author": "Winston Churchill"},
    {"text": "Do what you can, with what you have, where you are.", "author": "Theodore Roosevelt"},
    {"text": "Dream big and dare to fail.", "author": "Norman Vincent Peale"},
    {"text": "Act as if what you do makes a difference. It does.", "author": "William James"},
    {"text": "The secret of getting ahead is getting started.", "author": "Mark Twain"},
    {"text": "Great things are done by a series of small things brought together.", "author": "Vincent van Gogh"},
    {"text": "Your limitation—it's only your imagination.", "author": "Unknown"},
    {"text": "Hardships often prepare ordinary people for an extraordinary destiny.", "author": "C. S. Lewis"},
    {"text": "If you can dream it, you can do it.", "author": "Walt Disney"},
    {"text": "Do not wait for opportunity. Create it.", "author": "George Bernard Shaw"},
    {"text": "The journey of a thousand miles begins with one step.", "author": "Lao Tzu"},
    {"text": "What you think, you become. What you feel, you attract. What you imagine, you create.", "author": "Buddha"},
    {"text": "Success usually comes to those who are too busy to be looking for it.", "author": "Henry David Thoreau"},
    {"text": "It always seems impossible until it's done.", "author": "Nelson Mandela"},
    {"text": "Don't watch the clock; do what it does. Keep going.", "author": "Sam Levenson"},
    {"text": "Turn your wounds into wisdom.", "author": "Oprah Winfrey"},
    {"text": "Everything you've ever wanted is on the other side of fear.", "author": "George Addair"},
    {"text": "The best way out is always through.", "author": "Robert Frost"},
    {"text": "A little progress each day adds up to big results.", "author": "Unknown"},
    {"text": "Make each day your masterpiece.", "author": "John Wooden"},
    {"text": "You miss 100% of the shots you don't take.", "author": "Wayne Gretzky"}
]

@app.route("/")
def home():
    quote = secrets.choice(QUOTES)
    return render_template("index.html", quote=quote)
    
@app.route("/health")
def health():
    return {"status": "healthy"}, 200

@app.route("/info")
def info():
    return {"app": "aws-eks-gitops-pipeline", "version": "1.0.0"}, 200

if __name__ == "__main__":
    # Run the app, listening on all interfaces so it works in a container
    app.run(host="0.0.0.0", port=8000)  # nosec B104
