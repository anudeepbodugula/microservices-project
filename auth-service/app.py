from flask import Flask, request, jsonify
import mysql.connector

app = Flask(__name__)

import os

conn = mysql.connector.connect(
    host=os.getenv("DB_HOST", "localhost"),
    user=os.getenv("DB_USER", "myproject_user"),
    port=int(os.getenv("DB_PORT", 3306)),
    password=os.getenv("DB_PASS", "123"),
    database=os.getenv("DB_NAME", "myproject")
)
cursor = conn.cursor()


@app.route("/health")
def health():
    return "Auth Service is UP", 200

@app.route("/db-health")
def db_health():
    try:
        cursor.execute("SELECT 1")
        return "Database connection is OK", 200
    except Exception as e:
        return f"Database connection failed: {str(e)}", 500   

@app.route("/login", methods=["POST"])
def login():
    data = request.json
    cursor.execute("SELECT * FROM users WHERE email=%s AND password=%s", (data['email'], data['password']))
    result = cursor.fetchone()
    if result:
        return jsonify({"message": "Login success"}), 200
    return jsonify({"message": "Invalid credentials"}), 401

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)
