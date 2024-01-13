const multer = require("multer");
const multerS3 = require("multer-s3-transform");
const AWS = require("aws-sdk");
const config = require("../config/s3_config");

// const { S3Client } = require("@aws-sdk/client-s3");
// const { fromIni } = require("@aws-sdk/credential-provider-ini");

// const s3 = new S3Client({ credentials: fromIni() });

const s3 = new AWS.S3({
    accessKeyId: config.AWS_ACCESS_KEY_ID,
    secretAccessKey: config.AWS_SECRET_ACCESS_KEY,
});

const upload = multer({
    storage: multerS3({
        s3: s3,
        bucket: config.AWS_BUCKET_NAME,
        // acl: "public-read", // upload된 파일을 URL로 읽을 수 있도록 설정
        key: function (req, file, cb) {
            if (file.fieldname == "profileimage") {
                cb(null, "profile/" + file.originalname);
            }
        },
    }),
});

module.exports = upload.fields([
    {
        name: "profileimage",
        maxCount: 1,
    },
]);
