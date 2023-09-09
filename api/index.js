import path from "path";
import appRootPath from "app-root-path";
import fs from "fs";

import express from 'express';

const router = express.Router();

 import multer from "multer";
import controllers from "../controllers/index.js";
import bodyParser from "body-parser";

const upload = multer({dest: 'uploads/'});


router.get('/', function (req, res) {
    res.sendFile(path.join(appRootPath.path, './public/home.html'));
});

router.get('/files', function (req, res) {
    res.sendFile(path.join(appRootPath.path, './public/files.html'));
});

router.get('/code', function (req, res) {
    res.sendFile(path.join(appRootPath.path, './public/code.html'));
});


router.post('/convertCode', (req, res, next) => {
    const fileName = req.body.fileName.replace(/\s+/g, '_').replace(/\\/g, '/');
    const filePath = req.body.filePath.replace(/\s+/g, '_').replace(/\\/g, '/');
    const code = req.body.code;

    controllers.generateOutPut(code, fileName,filePath)
    res.sendFile(path.join(appRootPath.path, './public/home.html'));
});


router.post('/convertFiles', upload.array('files'), function (req, res) {
    const files = req.files;
    const filePath = req.body.fileName.replace(/\s+/g, '_').replace(/\\/g, '/');

    for (const file of files) {
        fs.readFile(file.path, 'utf8', (err, data) => {
            if (err) {
                console.error(err);
                res.sendStatus(500);
                return;
            }
            controllers.generateOutPut(data, file.originalname.split(".")[0],filePath)
        });
    }
    res.sendFile(path.join(appRootPath.path, './public/home.html'));
});

export default router;
