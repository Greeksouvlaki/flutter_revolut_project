const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const mysql = require('mysql');

const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(cors()); // Enable CORS

// MySQL connection
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '12baloon!', // Use your MySQL root password
  database: 'school_project'
});

db.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    process.exit(1);
  }
  console.log('MySQL Connected...');
});

// Route to get all transactions
app.get('/transactions', (req, res) => {
  let sql = 'SELECT * FROM transactions';
  db.query(sql, (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      res.status(500).send('Error executing query');
      return;
    }
    res.send(results);
  });
});

// Route to add a new transaction
app.post('/transactions', (req, res) => {
  let newTransaction = {
    description: req.body.description,
    amount: req.body.amount,
    date: req.body.date
  };
  let sql = 'INSERT INTO transactions SET ?';
  db.query(sql, newTransaction, (err, result) => {
    if (err) {
      console.error('Error executing query:', err);
      res.status(500).send('Error executing query');
      return;
    }
    res.send('Transaction added...');
  });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Server running on port ${port}`);
});
