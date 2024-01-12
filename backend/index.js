const express = require("express");
const app = express();
require("dotenv").config({ path: "./.env" });
const userRouter = require("./api/users/user_router");

app.use(express.json());
app.use("/api/users", userRouter);
app.listen(8000, function () {
  console.log("listening on 8000");
});