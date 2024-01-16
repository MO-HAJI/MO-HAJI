const uploadController = require("../controller/s3_controller");

const express = require("express");
const router = express.Router();

router.post("/image-upload", uploadController.uploadFile);
router.get("/foodimage/:email", uploadController.getFoodImage);

module.exports = router;
