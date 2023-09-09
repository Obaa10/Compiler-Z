import DartListener from "../libs/DartListener.js";

export default class AndroidDartListener extends DartListener {
    constructor(res, javaRes) {
        super();
        this.Res = res;
        this.JavaRes = javaRes;
    }

    enterCenterWidget(ctx) {
        console.log("Enter center widget")
        let centerView = '<LinearLayout \n'
        centerView += 'android:layout_width="match_parent"\n'
        centerView += 'android:layout_height="wrap_content"\n'
        centerView += 'android:gravity="center"\n'
        centerView += 'android:orientation="vertical"\n'
        centerView += '>\n'
        this.Res.write(centerView);
    }

    exitCenterWidget(ctx) {
        this.Res.write('</LinearLayout>\n');
    }

    enterColumnWidget(ctx) {
        console.log("Enter column widget")
        let columnView = '<LinearLayout \n'
        columnView += 'android:layout_width="match_parent"\n'
        columnView += 'android:layout_height="wrap_content"\n'
        columnView += 'android:gravity="center"\n'
        columnView += 'android:orientation="vertical"\n'
        columnView += '>\n'
        this.Res.write(columnView);
    }

    exitColumnWidget(ctx) {
        this.Res.write('</LinearLayout>\n');
    }

    enterRowWidget(ctx) {
        console.log("Enter Row widget")
        let rowView = '<LinearLayout \n'
        rowView += 'android:layout_width="match_parent"\n'
        rowView += 'android:layout_height="wrap_content"\n'
        rowView += 'android:gravity="center"\n'
        rowView += 'android:orientation="horizontal"\n'
        rowView += '>\n'
        this.Res.write(rowView);
    }

    exitRowWidget(ctx) {
        this.Res.write('</LinearLayout>\n');
    }

    enterSizedBoxWidget(ctx) {
        console.log("Enter sizedBox widget")
        let sizedBoxView = '<View \n'

        let width = this.findChildOfType(ctx, "WidthContext")

        sizedBoxView += 'android:layout_width='
        sizedBoxView += '"'
        if (width !== null)
            sizedBoxView += width?.getText()
        else
            sizedBoxView += '0'
        sizedBoxView += 'dp"\n'


        let height = this.findChildOfType(ctx, "HeightContext")

        sizedBoxView += 'android:layout_height='
        sizedBoxView += '"'
        if (height !== null)
            sizedBoxView += height?.getText()
        else
            sizedBoxView += '0'
        sizedBoxView += 'dp"\n'


        //sizedBoxView += 'android:layout_weight="1"\n'
        sizedBoxView += '/>\n'
        this.Res.write(sizedBoxView);
    }

    enterTextFieldWidget(ctx) {
        console.log("Enter EditText widget")
        let textFieldView = '<EditText \n'
        textFieldView += 'android:layout_width="match_parent"\n'
        textFieldView += 'android:layout_height="wrap_content"\n'
        textFieldView += 'android:layout_marginHorizontal="22dp"\n'

        let controllerName = this.findChildOfType(ctx, "ControllerNameContext")


        textFieldView += 'android:id="@+id/'
        textFieldView += controllerName?.getText()
        textFieldView += '"\n'


        const obscureText = this.findChildOfType(ctx, "ObscureTextContext")

        if (obscureText !== null && obscureText.booleanLiteral().getText() === "true") {
            textFieldView += 'android:password="true"\n'
        }

        const inputDecorationWidget = this.findChildOfType(ctx, "InputDecorationWidgetContext")
        if (inputDecorationWidget !== null) {
            const hintText = this.findChildOfType(inputDecorationWidget, "HintTextContext")
            if (hintText !== null) {
                textFieldView += ' android:hint='
                textFieldView += '"'
                textFieldView += hintText?.getText().replaceAll('\'', "").replaceAll('\"', "")
                textFieldView += '"'
            }
        }

        textFieldView += '/>\n'
        this.Res.write(textFieldView);
    }

    enterContainerWidget(ctx) {
        console.log("Enter Container widget")
        let containerView = '<androidx.cardview.widget.CardView \n'
        containerView += 'android:layout_gravity="center"\n'

        let widgetBodyProps = this.getChildByType(ctx.widgetBody(), "WidgetBodyPropsContext")

        let margin = this.getChildByType(widgetBodyProps, "EdgeInsetsContext")
        let marginNumber = this.getChildByType(margin, "EdgeInsetsNumberContext")

        let padding = this.getChildByType(widgetBodyProps, "PaddingContext")
        let paddingNumber = this.findChildOfType(padding, "EdgeInsetsNumberContext")

        let boxDecoration = this.findChildOfType(ctx, "BoxDecorationWidgetContext")

        if (boxDecoration !== null) {
            let colorName = this.findChildOfType(boxDecoration, "ColorNameContext")
            let borderRadiusValue = this.findChildOfType(boxDecoration, "CircularBorderRadiusValueContext")?.getText()

            if (colorName !== null) {
                const color = colorName?.getText().replaceAll('\'', "").replaceAll('\"', "");
                containerView += 'android:backgroundTint='
                containerView += '"'
                containerView += '#'
                containerView += color.substring(color.length - 6, color.length)
                containerView += '"\n'
            }

            if (borderRadiusValue !== null) {
                containerView += 'app:cardCornerRadius='
                containerView += '"'
                containerView += borderRadiusValue
                containerView += 'dp'
                containerView += '"\n'
            }

        }


        if (paddingNumber !== null) {
            containerView += 'app:contentPadding='
            containerView += '"'
            containerView += paddingNumber.getText()
            containerView += 'dp'
            containerView += '"\n'
        }else{
            containerView += "app:contentPadding=\"8dp\"\n"
        }

        if (marginNumber !== null) {
            containerView += 'android:layout_margin='
            containerView += '"'
            containerView += marginNumber.getText()
            containerView += 'dp'
            containerView += '"\n'
        }

        let height = this.getChildByType(widgetBodyProps, "HeightContext")
        if (height !== null) {
            containerView += 'android:layout_height='
            containerView += '"'
            containerView += height.getText()
            containerView += 'dp'
            containerView += '"\n'
        } else {
            containerView += 'android:layout_height="wrap_content"\n'
        }


        let width = this.getChildByType(widgetBodyProps, "WidthContext")
        if (width !== null) {
            containerView += 'android:layout_width='
            containerView += '"'
            if (Number(width.getText()) > 200)
                containerView += width.getText() / 2
            else
                containerView += width.getText()
            containerView += 'dp'
            containerView += '"\n'
        } else {
            containerView += 'android:layout_width="match_parent"\n'
        }

        containerView += '>\n'
        this.Res.write(containerView);
    }

    exitContainerWidget(ctx) {
        this.Res.write('</androidx.cardview.widget.CardView>\n');
    }

    enterImageWidget(ctx) {
        console.log("Enter image widget")
        const imageId = this.makeId(4)

        let imageJavaCode = '';
        imageJavaCode = `
         val image${imageId}View = findViewById<ImageView>(R.id.${imageId})
         Picasso.get().load("${this.findChildOfType(ctx, "ImageUrlContext")?.getText().replaceAll('\'', "").replaceAll('\"', "")}").resize(100, 100).into(image${imageId}View)
        `
        this.JavaRes.write(imageJavaCode);

        let imageView = '<ImageView \n'
        imageView += 'android:id="@+id/'
        imageView += imageId
        imageView += '"\n'
        imageView += 'android:layout_width="wrap_content"\n'
        imageView += 'android:layout_height="wrap_content"\n'
        imageView += '/>\n'
        this.Res.write(imageView)
    }

    enterElevatedButtonWidget(ctx) {
        console.log("Enter button widget")

        const buttonId = this.makeId(4)

        let className = this.findChildOfType(ctx, "ClassNameContext")?.getText();
        const javaActivityCode = this.getOnClick(buttonId, className, ctx)
        this.JavaRes.write(javaActivityCode);

        let buttonView = '<Button \n'
        buttonView += 'android:id="@+id/'
        buttonView += buttonId
        buttonView += '"\n'
        buttonView += 'android:layout_width="wrap_content"\n'
        buttonView += 'android:layout_height="wrap_content"\n'


        const text = this.findChildOfType(ctx, "StringLiteralContext").getText().replaceAll('\'', "").replaceAll('\"', "")
        buttonView += ' android:text='
        buttonView += '"'
        buttonView += text
        buttonView += '"'
        buttonView += '\n'


        buttonView += '/>\n';
        this.Res.write(buttonView);
    }

    getOnClick(buttonId, nextClass, ctx) {

        let classMember = this.findChildOfType(ctx, "ClassMemberContext");
        let valueTextController = this.findChildOfType(classMember, "TextControllerContext");

        if (classMember !== null) {
            return ` val ${buttonId} = findViewById<Button>(R.id.${buttonId})
            ${buttonId}.setOnClickListener {
            val i = Intent(this, ${this.findChildOfType(ctx, "ClassNameContext")?.getText()}::class.java)
            val message = findViewById<EditText>(R.id.${valueTextController?.controllerName()?.getText()}).text.toString()
            i.putExtra("${classMember.key().getText()}", message)
            startActivity(i)
            } \n`
        } else {
            return ` val ${buttonId} = findViewById<Button>(R.id.${buttonId})
            ${buttonId}.setOnClickListener {
            val i = Intent(this, ${this.findChildOfType(ctx, "ClassNameContext")?.getText()}::class.java)
            startActivity(i)
            } \n`
        }
    }


    enterTextWidget(ctx) {
        console.log("Enter text widget")
        const textId = this.makeId(4)

        let textView = '<TextView \n'
        textView += 'android:id="@+id/'
        textView += textId
        textView += '"\n'
        textView += 'android:layout_width="wrap_content"\n'
        textView += 'android:layout_height="wrap_content"\n'


        const textStyleWidget = this.findChildOfType(ctx, "TextStyleWidgetContext");
        if (textStyleWidget !== null) {

            const fontWeight = this.findChildOfType(textStyleWidget, "FontWeightContext");
            const fontSize = this.findChildOfType(textStyleWidget, "FontSizeContext");
            const fontColor = this.findChildOfType(textStyleWidget, "ColorNameContext");

            if (fontSize !== null) {
                textView += 'android:textSize='
                textView += '"'
                textView += fontSize.getText()
                textView += 'sp'
                textView += '"'
                textView += '\n'
            }

            if (fontColor !== null) {
                const color = fontColor?.getText().replaceAll('\'', "").replaceAll('\"', "");
                textView += 'android:textColor='
                textView += '"'
                textView += '#'
                textView += color.substring(color.length - 6, color.length)
                textView += '"'
                textView += '\n'
            }

            if (fontWeight?.getText() === "FontWeight.bold") {
                textView += 'android:textStyle="bold"'
            }
        }

        const widgetBodyProps = this.getChildByType(this.getChildByType(ctx, "WidgetBodyContext"), "WidgetBodyPropsContext")

        if (widgetBodyProps.stringLiteral() !== null) {
            const text = widgetBodyProps.stringLiteral().getText().replaceAll('\'', "").replaceAll('\"', "")
            textView += ' android:text='
            textView += '"'
            textView += text
            textView += '"'
            textView += '\n'
        }


        if (widgetBodyProps.variable() !== null) {
            let javaCode = `
                val extras = intent.extras
                if (extras != null) {
                    val value = extras.getString("${widgetBodyProps.variable().getText()}")
                    val myText = findViewById<TextView>(R.id.${textId})
                    myText.text = value
                }`

            this.JavaRes.write(javaCode);
        }

        textView += ' />\n';
        this.Res.write(textView);
    }

    getChildByType(ctx, childClassName) {
        for (let i = 0; i < ctx?.getChildCount(); i++) {
            if (ctx.getChild(i).constructor.name === childClassName) {
                return ctx.getChild(i)
            }
        }
        return null
    }

    findChildOfType(node, tokentype) {
        if (node !== null) for (let i = 0; i < node.getChildCount(); i++) {
            let child = node.getChild(i);
            if (child.constructor.name === tokentype) {
                return child;
            }
            if (child.getChildCount() > 0) {
                let t = this.findChildOfType(child, tokentype)
                if (t !== null) return t;
            }
        }
        return null
    }

    findChildrenOfType(node, tokentype) {
        let children = []
        if (node !== null) for (let i = 0; i < node.getChildCount(); i++) {
            let child = node.getChild(i);
            if (child.constructor.name === tokentype) {
                children.push(child);
            }
            if (child.getChildCount() > 0) {
                let t = this.findChildOfType(child, tokentype)
                if (t !== null) return t;
            }
        }
        return children
    }

    makeId(length) {
        let result = '';
        const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
        const charactersLength = characters.length;
        let counter = 0;
        while (counter < length) {
            result += characters.charAt(Math.floor(Math.random() * charactersLength));
            counter += 1;
        }
        return result;
    }

}

