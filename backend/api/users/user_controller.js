const {
    create,
  
    getUsers,
    updateUser,
    getUserByUserEmail,
    setBackUrl,
    setProfileUrl,
  } = require("./user_service.js");
  
  const { genSaltSync, hashSync, compareSync } = require("bcrypt");
  const { sign } = require("jsonwebtoken");
  
  module.exports = {
    createUser: (req, res) => {
      const body = req.body;
      const salt = genSaltSync(10);
      body.password = hashSync(body.password, salt);
      create(body, (err, results) => {
        if (err) {
          console.log(err);
          return res.status(500).json({
            success: 0,
          });
        }
        return res.status(200).json({
          success: 1,
          data: results,
          message: "Success",
        });
      });
    },

    getUserByUserEmail: (req, res) => {
      const email = req.params.email;
      getUserByUserEmail(email, (err, results) => {
        if (err) {
          console.log(err);
          return;
        }
        if (!results) {
          return res.json({
            sucess: 0,
            message: "Record not Found",
          });
        }
        return res.json({
          sucess: 1,
          data: results,
        });
      });
    },
    getUsers: (req, res) => {
      getUsers((err, results) => {
        if (err) {
          console.log(err);
          return;
        }
        return res.json({
          success: 1,
          data: results,
        });
      });
    },
    updateUser: (req, res) => {
      const body = req.body;
      const salt = genSaltSync(10);
      body.password = hashSync(body.password, salt);
      updateUser(body, (err, results) => {
        if (err) {
          console.log(err);
          return;
        }
        if (!results) {
          return res.json({
            success: 0,
            message: "Failed to update user",
          });
        }
        return res.json({
          success: 1,
          message: "updated successfully",
        });
      });
    },
    login: (req, res) => {
      const body = req.body;
      getUserByUserEmail(body.email, (err, results) => {
        if (err) {
          console.log(err);
        }
        if (!results) {
          return res.json({
            success: 0,
            message: "Invalid ID",
          });
        }
        const result = compareSync(body.password, results.password);
        if (result) {
          results.password = undefined;
          const jsontoken = sign({ result: results }, "token_value", {
            expiresIn: "1h",
          });
          return res.json({
            success: 1,
            message: "login successfully",
            token: jsontoken,
          });
        } else {
          return res.json({
            success: 0,
            message: "Invalid Password",
          });
        }
      });
    },
    updateUserBackground: async (req, res) => {
      console.log("controller");
      const email = req.body.email;
      const url = req.file.fieldname + "-" + Date.now() + ".jpeg";
      const n = [email, url];
      // console.log(n[0]);
      // console.log(n[1]);
  
      setBackUrl(n, (err, results) => {
        if (err) {
          console.log(err);
          return;
        }
        return res.json({
          success: 1,
          message: "updated successfully",
        });
      });
    },
    updateUserProfile: async (req, res) => {
      console.log("controller");
      const email = req.body.email;
      const url = req.file.fieldname + "-" + Date.now() + ".jpeg";
      const n = [email, url];
      // console.log(n[0]);
      // console.log(n[1]);
  
      setProfileUrl(n, (err, results) => {
        if (err) {
          console.log(err);
          return;
        }
        return res.json({
          success: 1,
          message: "updated successfully",
        });
      });
    },
  };