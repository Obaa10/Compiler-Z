import antlr4 from "antlr4";
import fs from "fs";

const {CommonTokenStream, InputStream} = antlr4;


import DartLexer from "../libs/DartLexer.js";
import DartParser from "../libs/DartParser.js";
import AndroidListener from "../listener/AndroidListener.js";
import HtmlDartListener from "../listener/HtmlDartListener.js";

class Controllers {
    static async generateOutPut(input, fileName, filePath) {
        const chars = new InputStream(input, true);
        const lexer = new DartLexer(chars);
        const tokens = new CommonTokenStream(lexer);
        const parser = new DartParser(tokens);

        parser.buildParseTrees = true;
        const tree = parser.start();

        await this.testAndroidOutput(tree, fileName, filePath);
        this.testHtmlOutput(tree, fileName, filePath);
    }

    static async delay() {
        return new Promise(resolve => setTimeout(resolve, 1500));
    }

    static async testAndroidOutput(tree, fileName, filePath) {


        let body = '<LinearLayout\n' +
            'android:layout_width="match_parent"\n' +
            'android:layout_height="wrap_content"\n' +
            'xmlns:app="http://schemas.android.com/apk/res-auto"\n' +
            'xmlns:android="http://schemas.android.com/apk/res/android"\n' +
            'android:layout_gravity="center"\n' +
            'android:orientation="vertical">\n'

        if (!fs.existsSync(filePath)) {
            fs.mkdirSync(filePath);
        }
        if (!fs.existsSync(filePath + '/output/')) {
            fs.mkdirSync(filePath + '/output/');
        }
        if (!fs.existsSync(filePath + '/output/android/')) {
            fs.mkdirSync(filePath + '/output/android/');
        }
        if (!fs.existsSync(filePath + '/output/android/xml/')) {
            fs.mkdirSync(filePath + '/output/android/xml/');
        }
        if (!fs.existsSync(filePath + '/output/android/kotlin/')) {
            fs.mkdirSync(filePath + '/output/android/kotlin/');
        }


        let stream = fs.createWriteStream(filePath + '/output/android/xml/' + fileName + ".xml");
        let streamJava = fs.createWriteStream(filePath + '/output/android/kotlin/' + fileName + ".kt");


        stream.write(body)
        streamJava.write(Controllers.startWriteActivityClass(fileName))

        const androidDart = new AndroidListener(stream, streamJava);
        antlr4.tree.ParseTreeWalker.DEFAULT.walk(androidDart, tree);

        streamJava.write(Controllers.endWriteActivityClass())

        streamJava.end();

        stream.write('</LinearLayout>')
        stream.end();

    }

    static testHtmlOutput(tree, fileName, filePath) {

        if (!fs.existsSync(filePath + '/output/web/')) {
            fs.mkdirSync(filePath + '/output/web/');
        }

        let stream = fs.createWriteStream(filePath + "/output/web/" + fileName + ".html");

        stream.once('open', function (fd) {

            stream.write('<html lang="en"><head><meta charset="UTF-8"/><title>Flutter web</title></head><body>');

            const htmlDart = new HtmlDartListener(stream, filePath + "/output/web/");
            antlr4.tree.ParseTreeWalker.DEFAULT.walk(htmlDart, tree);

            stream.write("</body></html>");
            stream.end();

            // Controllers.testAndroidOutput(tree, fileName, filePath);
        });

    }

    static startWriteActivityClass(className) {
        return `
package com.example.myapplication
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.TextView
import android.widget.Button
import android.widget.EditText
import com.squareup.picasso.Picasso
import android.content.Intent
import android.widget.ImageView

class ${className} : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_${className})
        `
    }

    static endWriteActivityClass() {
        return '\n' +
            '}\n' +
            '}'
    }
}

export default Controllers;