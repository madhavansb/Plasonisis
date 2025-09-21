from flask import Flask, jsonify
from flask_cors import CORS
import requests

app = Flask(__name__)
CORS(app)

NEWS_API_KEY = "your_key"  # Replace with your actual NewsAPI key

@app.route("/api/agri-news", methods=["GET"])
def agri_news():
    url = f"https://newsapi.org/v2/everything?q=agriculture&language=en&sortBy=publishedAt&apiKey={NEWS_API_KEY}"
    try:
        response = requests.get(url)
        data = response.json()
        # Return only articles
        return jsonify(data.get("articles", []))
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
