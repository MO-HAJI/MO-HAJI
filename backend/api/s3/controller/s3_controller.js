const upload = require("../middleware/s3_upload"); // s3 upload middleware
const db = require("../../../database");

// function to upload file
const uploadFile = async (req, res) => {
    upload(req, res, async function (err) {
        if (err) {
            return res.status(400).send({
                result: 0,
                message: err,
            });
        }

        return res.status(200).send({
            result: 1,
            message: "image upload successfully",
        });
    });
};

const getFoodImage = async (req, res) => {
    const email = req.params.email;
    console.log("Email:", email);

    db.query("SELECT * FROM images WHERE email = ?", [email], (err, result) => {
        if (err) {
            console.log(err);
        } else {
            console.log(result);
            return res.status(200).send({
                result: 1,
                message: "get food image successfully",
                data: result,
            });
        }
    });
};

const deleteFoodImage = async (req, res) => {
    const id = req.params.id;
    console.log("id:", id);

    db.query("DELETE FROM images WHERE id = ?", [id], (err, result) => {
        if (err) {
            console.log(err);
        } else {
            console.log(result);
            return res.status(200).send({
                result: 1,
                message: "delete food image successfully",
            });
        }
    });
};

module.exports = {
    uploadFile,
    getFoodImage,
    deleteFoodImage,
};
