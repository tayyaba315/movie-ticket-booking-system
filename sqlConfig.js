// db/sqlConfig.js
const sql = require('mssql');
require('dotenv').config(); // Load environment variables from .env

const config = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER, // DESKTOP-JPFT59C\SQLEXPRESS
    database: process.env.DB_NAME,
    port: parseInt(process.env.DB_PORT, 10), // default SQL Server port
    options: {
        encrypt: true, // Use true if you're deploying to Azure; false is fine for local
        trustServerCertificate: true // Required for local dev/self-signed certs
    }
};

async function connectToDatabase() {
    try {
        const pool = await sql.connect(config);
        console.log('✅ Connected to MSSQL');
        return pool;
    } catch (err) {
        console.error('❌ Database connection failed:', err);
        throw err;
    }
}

module.exports = {
    connectToDatabase,
    sql
};