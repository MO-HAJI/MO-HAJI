const express = require("express");
const app = express();
require("dotenv").config({ path: "./.env" });
const userRouter = require("./api/users/user_router");

app.use(express.json());
app.use("/api/users", userRouter);
app.use("/api/s3", require("./api/s3/routes/s3_routes")); // s3 라우터

app.listen(8000, function () {
    console.log("listening on 8000");
});
