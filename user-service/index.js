require('dotenv').config();
const express = require('express');
const mysql = require('mysql2');
const app = express();

app.use(express.json());

// MySQL connection
const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).send('User Service is healthy');
});

// Create a user
app.post('/user', (req, res) => {
    const { name, email } = req.body;
    db.query('INSERT INTO users (name, email) VALUES (?, ?)', [name, email], (err) => {
        if (err) return res.status(500).send(err);
        res.send('User created');
    });
});

// (Optional) Get all users
app.get('/users', (req, res) => {
    db.query('SELECT * FROM users', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results);
    });
});

// 🔍 Database health check
app.get('/db-health', (req, res) => {
    db.query('SELECT 1', (err) => {
        if (err) {
            console.error('Database health check failed:', err);
            return res.status(500).send('Database connection failed');
        }
        res.status(200).send('Database connection is OK');
    });
});
// Set to port 3000 (as per your earlier request)
const PORT = process.env.APP_PORT || 3000;
app.listen(PORT, () => console.log(`User Service running on port ${PORT}`));