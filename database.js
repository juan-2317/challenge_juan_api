const mysql = require('mysql')

// Create the connection to MySQL
const pool = mysql.createPool({
    host: "localhost",
    user: "root",
    password: "",
    database: "challengeglobant"
});

module.exports = pool
