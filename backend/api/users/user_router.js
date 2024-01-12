const multer = require("multer");
const path = require("path");

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    const dest = path.join(__dirname, "../../images/");
    cb(null, dest);
  },
  filename: function (req, file, cb) {
    cb(null, file.fieldname + "-" + Date.now() + ".jpeg");
  },
});
const upload = multer({ storage: storage });

const {
  createUser,
  // getUserByUserID,
  getUserByUserEmail,
  getUsers,
  updateUser,
  login,
  updateUserProfile,
  updateUserBackground,
  getNews,
  getNewsSearch,
  getYoutubeSearch,
  getALLYoutube,
} = require("./user_controller");

const router = require("express").Router();

const { checkToken } = require("../../auth/token_validation");


router.post("/", createUser);
router.get("/", checkToken, getUsers);
// router.get("/:id", checkToken, getUserByUserID);
router.get("/:email", checkToken, getUserByUserEmail);
router.put("/", checkToken, updateUser);
router.post("/login", login);
router.patch(
  "/users/backgroundimage",
  checkToken,
  upload.single("image"),
  updateUserBackground
);
router.patch(
  "/users/profileimage",
  checkToken,
  upload.single("image"),
  updateUserProfile
);

module.exports = router;