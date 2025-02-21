import { pathConstants } from "#config/path/path.config";
import { randomUUID, hash } from "crypto";
import multer from "multer";
import path from "path";

const avatarUpload = multer({ storage: multer.diskStorage(
    {
        destination: path.join(pathConstants.__dirname, '../../data/images/avatar/'),
        filename: function (req, file, cb) {
            const unique_name = randomUUID()+"_"+file.originalname;
            const hashed_name = hash('sha256', unique_name);
            cb(null, hashed_name + path.extname(file.originalname));
        }
    }
), limits: { fileSize: 1024 * 1024 * 10 } }).single("avatar");

export default avatarUpload;