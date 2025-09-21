from flask import Flask, jsonify
from flask_cors import CORS
import mysql.connector

app = Flask(__name__)
CORS(app)  # allow Flutter app to call API

def get_db_connection():
    return mysql.connector.connect(
        host="localhost",      # your DB host
        user="root",           # your MySQL username
        password="Mad@2006",           # your MySQL password
        database="plasonisis"  # your DB name
    )

@app.route("/daily_prices", methods=["GET"])
def daily_prices():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT id, state, apmc, commodity, min_price, modal_price, max_price, unit, date
        FROM daily_prices
        ORDER BY date DESC
        LIMIT 50
    """)
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(rows)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5002, debug=True)
