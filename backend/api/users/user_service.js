//user_service.js

const con = require("../../database");

module.exports = {
  create: (data, callBack) => {
    var name = data.name;
    var birth = data.birth;
    var gender = data.gender;
    var email = data.email;
    var password = data.password;
    con.query(
      "INSERT INTO users (name, birth, gender, email, password) VALUES(?,?,?,?,?)",
      [name, birth, gender, email, password],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },

  getUsers: (callBack) => {
    con.query("select * from users", (error, results, fields) => {
      if (error) {
        return callBack(error);
      }
      return callBack(null, results);
    });
  },

  getUserByUserID: (id, callBack) => {
    con.query(
      "select * from users where id = ?",
      [id],
      (error, results, fields) => {
        if (error) {
          callBack(error);
        }
        return callBack(null, results[0]);
      }
    );
  },
  getUserByUserEmail: (email, callBack) => {
    con.query(
      "select * from users where email = ?",
      [email],
      (error, results, fields) => {
        if (error) {
          callBack(error);
        }
        return callBack(null, results[0]);
      }
    );
  },
  updateUser: (data, callBack) => {
    var email = data.email;
    var updatedData = data;
    con.query(
      "UPDATE users SET ? WHERE email = ?",
      [updatedData, email],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
  setBackUrl: (data, callBack) => {
    var email = data[0];
    var background_image = data[1];
    con.query(
      "UPDATE users SET background_image = ? WHERE email = ?",
      [background_image, email],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
  setBackUrl: (data, callBack) => {
    var email = data[0];
    var background_image = data[1];
    console.log("service");
    console.log(data[0]);
    console.log(data[1]);
    con.query(
      "UPDATE users SET background_image = ? WHERE email = ?",
      [background_image, email],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
  setProfileUrl: (data, callBack) => {
    var email = data[0];
    var background_image = data[1];
    console.log("service");
    console.log(data[0]);
    console.log(data[1]);
    con.query(
      "UPDATE users SET profile_image = ? WHERE email = ?",
      [background_image, email],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
};