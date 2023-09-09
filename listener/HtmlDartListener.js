import DartListener from "../libs/DartListener.js";

export default class HtmlDartListener extends DartListener {
    constructor(res,filePath) {
        super();
        this.Res = res;
        this.filePath = filePath;
    }

    enterCenterWidget(ctx) {
        console.log("Enter center widget")
        this.Res.write('<center>');
    }

    exitCenterWidget(ctx) {
        console.log("Exit center widget")
        this.Res.write("</center>");
    }

    enterContainerWidget(ctx) {
        let containerStyle = '<dev class="container" '
        containerStyle += 'style= '
        containerStyle += '"'
        containerStyle += 'width: min-content; clear: both; display: block;'

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
                containerStyle += 'background-color: '
                containerStyle += '#'
                containerStyle += color.substring(color.length -6,color.length)
                containerStyle += ' ;'
            }

            if (borderRadiusValue !== null) {
                containerStyle += ' border-radius: '
                containerStyle += borderRadiusValue
                containerStyle += 'px ;'
            }

        }


        if (paddingNumber !== null) {
            containerStyle += 'padding:'
            containerStyle += paddingNumber.getText()
            containerStyle += 'px ;'
        }

        if (marginNumber !== null) {
            containerStyle += 'margin:'
            containerStyle += marginNumber.getText()
            containerStyle += 'px ;'
        }

        let height = this.getChildByType(widgetBodyProps, "HeightContext")
        if (height !== null) {
            containerStyle += 'height: '
            containerStyle += height.getText()
            containerStyle += ';'
        }

        let width = this.getChildByType(widgetBodyProps, "WidthContext")
        if (width !== null) {
            containerStyle += 'width: '
            containerStyle += width.getText()
            containerStyle += ';'
        }

        containerStyle += ' "'
        containerStyle += '>'
        this.Res.write(containerStyle);
    }

    exitContainerWidget(ctx) {
        this.Res.write('</dev>');
    }

    enterImageWidget(ctx) {
        let image = '<img';
        image += ' src= '
        image += '\''
        image += this.findChildOfType(ctx, "ImageUrlContext")?.getText().replaceAll('\'', "").replaceAll('\"', "");
        image += '\''


        image += ' style= " max-width: 100%; max-height: 100%; display: block;"'
        image += '>'
        this.Res.write(image)
    }

    enterAppBarWidget(ctx) {
        this.Res.write('<div data-role="appbar" data-expand-point="md">')
    }

    exitAppBarWidget(ctx) {
        super.exitAppBarWidget(ctx);
        this.Res.write("</div>");
    }

    enterColumnWidget(ctx) {
        super.enterColumnWidget(ctx);
        this.Res.write('<div class="column" style="">');//background-color:powderblue;
    }

    exitColumnWidget(ctx) {
        super.exitColumnWidget(ctx);
        this.Res.write('</div>');
    }

    enterRowWidget(ctx) {
        super.enterColumnWidget(ctx);
        this.Res.write('<div class="row" style="display:flex;   flex-wrap: wrap; margin:auto;justify-content: center;">');//background-color:powderblue;
    }

    exitRowWidget(ctx) {
        super.exitColumnWidget(ctx);
        this.Res.write('</div>');
    }


    enterElevatedButtonWidget(ctx) {
        const id = this.makeId(4);
        this.getNavigationFunction(ctx,id )
        let button = ''
        button += '<button ';
        button += 'onClick=';
        button += `"clickNavigation${id}()"`
        button += ' >';
        this.Res.write(button);
    }

    getNavigationFunction(ctx,id) {
        this.Res.write('<script>');
        let widgetBodyContext = this.getChildByType(this.getChildByType(ctx, "WidgetBodyContext"), "WidgetBodyPropsContext")
        this.Res.write(this.getNavigationJsFunction(ctx,id));
        this.Res.write('</script>');
    }

    exitElevatedButtonWidget(ctx) {
        super.exitElevatedButtonWidget(ctx);
        this.Res.write('</button>');
    }

    enterTextWidget(ctx) {
        console.log("Enter text widget")
        this.Res.write("<h1 ");


        const textStyleWidget = this.findChildOfType(ctx, "TextStyleWidgetContext");
        if (textStyleWidget !== null) {
            let textStyle = 'style='
            textStyle += '"'

            const fontWeight = this.findChildOfType(textStyleWidget, "FontWeightContext");
            const fontSize = this.findChildOfType(textStyleWidget, "FontSizeContext");
            const fontColor = this.findChildOfType(textStyleWidget, "ColorNameContext");

            if (fontSize !== null) {
                textStyle += 'font-size: '
                textStyle += fontSize.getText()
                textStyle += 'px; '
            }

            if (fontColor !== null) {
                const color = fontColor.getText().replaceAll('\'', "").replaceAll('\"', "")
                textStyle += 'color: '
                textStyle += color.substring(color.length -6,color.length)
                textStyle += '; '
            }

            if (fontWeight?.getText() === "FontWeight.bold") {
                textStyle += 'font-weight: bold;'
            }

            textStyle += '"'
            this.Res.write(textStyle);
        }
        this.Res.write('>');


        const widgetBodyProps = this.getChildByType(this.getChildByType(ctx, "WidgetBodyContext"), "WidgetBodyPropsContext")


        if (widgetBodyProps.stringLiteral() !== null)
            this.Res.write(widgetBodyProps.stringLiteral().getText().replaceAll('\'', "").replaceAll('\"', ""));
        if (widgetBodyProps.variable() !== null) {
            let scriptTag = ''
            scriptTag += '<script type="text/javascript">'
            scriptTag += 'document.write'
            scriptTag += '('
            scriptTag += widgetBodyProps.variable().getText()
            scriptTag += ')'
            scriptTag += '</script>'
            this.Res.write(scriptTag);
        }

        this.Res.write("</h1>");
    }

    enterSizedBoxWidget(ctx) {
        super.enterSizedBoxWidget(ctx);
        let sizedBox = '<div class="sized_box"';

        sizedBox += 'style="'

        let margin = this.findChildOfType(ctx, "EdgeInsetsNumberContext")
        if (margin !== null) {
            sizedBox += 'margin:'
            sizedBox += margin.getText()
            sizedBox += ';'
        }
        sizedBox += ' ;'

        let width = this.findChildOfType(ctx, "WidthContext")
        if (width !== null) {
            sizedBox += 'width: '
            sizedBox += width.getText()
        }

        let height = this.findChildOfType(ctx, "HeightContext")
        if (height !== null) {
            sizedBox += 'height: '
            sizedBox += height.getText()
        }

        sizedBox += '" >'
        this.Res.write(sizedBox);
    }

    exitSizedBoxWidget(ctx) {
        super.exitSizedBoxWidget(ctx);
        this.Res.write('</div>');
    }

    enterTextFieldWidget(ctx) {
        let textField = "";
        textField += '<input '
        textField += ' id='
        let controllerName = this.findChildOfType(ctx, "ControllerNameContext")
        textField += controllerName?.getText()

        const obscureText = this.findChildOfType(ctx, "ObscureTextContext")
        if (obscureText !== null && obscureText.booleanLiteral().getText() === "true") {
            textField += ' type="password"';
        }

        const inputDecorationWidget = this.findChildOfType(ctx, "InputDecorationWidgetContext")
        if (inputDecorationWidget !== null) {
            const hintText = this.findChildOfType(inputDecorationWidget, "HintTextContext")

            if (hintText !== null) {
                textField += ' placeholder='
                textField += '"'
                textField += hintText?.getText().replaceAll('\'', "").replaceAll('\"', "")
                textField += '"'
            }

        }

        textField += ' >'
        //TODO throw an error if the t is null
        textField += "</input>"
        this.Res.write(textField);
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


    getNavigationJsFunction(functionExpression,id) {
        let className = this.findChildOfType(functionExpression, "ClassNameContext")?.getText();
        let classMember = this.findChildOfType(functionExpression, "ClassMemberContext");

        let navigation = `function clickNavigation${id}() {`
        navigation += `window.location = "${this.filePath}"`
        navigation += '+'
        navigation += '"'
        navigation += className;
        navigation += '"';
        navigation += '+';
        navigation += '".html?"';

        const keyValue = this.getKeyValue(classMember)
        if (keyValue !== undefined) {
            navigation += keyValue;
        }

        navigation += '}';
        return navigation
    }

    getKeyValue(classMember) {
        if (classMember === null) return

        let parameters = ""
        parameters += '+'
        parameters += '"'
        parameters += classMember.key().getText()
        parameters += '"'
        parameters += '+ "="'

        let valueTextController = this.findChildOfType(classMember, "TextControllerContext");

        if (valueTextController !== null) {
            parameters += '+'
            parameters += 'document.getElementById('
            parameters += '"'
            parameters += valueTextController.controllerName().getText()
            parameters += '"'
            parameters += ').value'
        }
        return parameters
    }


    enterClassDeclaration(ctx) {
        const className = this.findChildOfType(ctx, "TypeWithParametersContext").typeIdentifier().getText()

        let headerParameterName = this.getHeaderParameterName(ctx, className)
        let javaScriptClassName = ""

        // javaScriptClassName = '<script type="text/javascript">'
        // javaScriptClassName += 'var global = ;'
        // javaScriptClassName += '</script>'
        //

        javaScriptClassName += '<script type="text/javascript">'
        javaScriptClassName += 'var className = '
        javaScriptClassName += '"'
        javaScriptClassName += className
        javaScriptClassName += '"'
        javaScriptClassName += ';'


        javaScriptClassName += ""
        javaScriptClassName += 'var url_string = window.location.href;'
        javaScriptClassName += 'var url = new URL(url_string);'
        javaScriptClassName += 'var '
        javaScriptClassName += headerParameterName
        javaScriptClassName += ' = url.searchParams.get'
        javaScriptClassName += '('
        javaScriptClassName += '"'
        javaScriptClassName += headerParameterName
        javaScriptClassName += '"'
        javaScriptClassName += ')'
        javaScriptClassName += ';'
        // javaScriptClassName += 'document.getElementById'
        // javaScriptClassName += '("'
        // javaScriptClassName += headerParameterName
        // javaScriptClassName += '")'
        // javaScriptClassName += '.value = '
        // javaScriptClassName += headerParameterName
        // javaScriptClassName += ';'
        javaScriptClassName += 'global ='
        javaScriptClassName += headerParameterName
        javaScriptClassName += ';'

        javaScriptClassName += '</script>'

        this.Res.write(javaScriptClassName)
    }

    getHeaderParameterName(ctx, className) {
        let parameterName = ''
        this.findChildrenOfType(ctx, "ClassMemberDefinitionContext").forEach((child) => {
            const functionName = this.findChildOfType(child, "IdentifierNotFUNCTIONContext")?.getText()
            if (functionName === className) {
                parameterName = this.findChildOfType(this.findChildOfType(child, "FormalParameterPartContext"), "IdentifierNotFUNCTIONContext")?.getText()
            }
        })
        return parameterName
    }


    enterFunctionSignature(ctx) {
        const functionName = ctx.identifierNotFUNCTION().getText()
        //if (functionName ===)
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
