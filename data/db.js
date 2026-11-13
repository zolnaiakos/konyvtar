import 'dotenv/config';
import mysql2 from 'mysql2/promise';




const dbConfig = {
    host: process.env.DB_HOST, 
    user: process.env.DB_USER,
    database: process.env.DB_DATABASE,
    port: process.env.DB_PORT
}


const pool = mysql2.createPool(dbConfig)

export default pool;