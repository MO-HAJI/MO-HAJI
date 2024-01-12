const mysql = require("mysql");
const { db_data } = require("./.env");

const con = mysql.createConnection(db_data);

module.exports = con;