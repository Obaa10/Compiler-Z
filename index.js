import express from 'express';
import bodyParser from 'body-parser';
import fs from "fs";
import appRootPath from "app-root-path";
import path from "path";

import api  from './api/index.js';

const app = express();

app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());


app.use(api);
app.listen(3000, () => {
    console.log(`App running on port 3000...`);
});












const testFilesName = ["center_text", "scaffold", "login", "signup", "homePage", "login.2.0.0"];
const testedFile = testFilesName[4]
function readFileInput() {
    try {
        return fs.readFileSync(path.join(appRootPath.path, "/samples/") + testedFile + ".txt", "utf8");
    } catch (e) {
        console.log("Error:", e.stack);
    }
}