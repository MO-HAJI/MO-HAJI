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
    getUserByUserEmail,
    getUsers,
    updateUser,
    login,
    followUser,
    unfollowUser,
    getFollowers,
    getFollowings,
    checkFollowing,

} = require("./user_controller");

const router = require("express").Router();

const { checkToken } = require("../../auth/token_validation");

router.post("/", createUser);
router.get("/", checkToken, getUsers);
router.get("/:email", checkToken, getUserByUserEmail);
router.put("/", checkToken, updateUser);
router.post("/login", login);
router.post("/follow", followUser);

router.post("/unfollow", unfollowUser);
router.get("/followers/:email", checkToken, getFollowers);
router.get("/followings/:email", checkToken, getFollowings);
router.post("/checkfollowing", checkFollowing);


module.exports = router;
