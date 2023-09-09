grammar Dart;


start: topLevelDefinition* EOF;

declaredIdentifier: COVARIANT? finalConstVarOrType identifier;

finalConstVarOrType:
	LATE? FINAL type?
	| CONST type?
	| LATE? varOrType;

finalVarOrType: FINAL type? | varOrType;

varOrType: VAR | type;

initializedVariableDeclaration:
	declaredIdentifier ('=' expression)? (
		',' initializedIdentifier
	)*;

initializedIdentifier: identifier ('=' expression)?;

initializedIdentifierList:
	initializedIdentifier (',' initializedIdentifier)*;

// Chapter 9 - Functions

functionSignature:
	metadata type? identifierNotFUNCTION formalParameterPart;

formalParameterPart: typeParameters? formalParameterList;

functionBody:
	'=>'  expression  ';'
	| ASYNC '=>'expression  ';'
	| (ASYNC | ASYNC '*' | SYNC '*')  block
	|  block ;

block: LBRACE statements RBRACE;

// Chapter 9.2 - Formal Parameters

formalParameterList:
	'(' ')'
	| '(' normalFormalParameters ','? ')'
	| '(' normalFormalParameters ',' optionalOrNamedFormalParameters ')'
	| '(' optionalOrNamedFormalParameters ')';

normalFormalParameters:
	normalFormalParameter (',' normalFormalParameter)*;

optionalOrNamedFormalParameters:
	optionalPositionalFormalParameters
	| 'BuildContext context'
	| 'context'
	| 'Build context'
	| namedFormalParameters;

optionalPositionalFormalParameters:
	'[' defaultFormalParameter (',' defaultFormalParameter)* ','? ']';

namedFormalParameters:
	LBRACE defaultNamedParameter (',' defaultNamedParameter)* ','? RBRACE;

// Chapter 9.2.1 - Required Formals

// "Simplifiquei" a regra do manual.
normalFormalParameter:
	metadata functionFormalParameter
	| metadata fieldFormalParameter
	| metadata simpleFormalParameter;

functionFormalParameter:
	COVARIANT? type? identifierNotFUNCTION formalParameterPart '?'?;

simpleFormalParameter:
	declaredIdentifier
	| COVARIANT? identifier;

fieldFormalParameter:
	finalConstVarOrType? THIS '.' identifier (
		formalParameterPart '?'?
	)?;

defaultFormalParameter: normalFormalParameter ('=' expression)?;

defaultNamedParameter:
	REQUIRED? normalFormalParameter ((':' | '=') expression)?;

typeWithParameters: typeIdentifier typeParameters?;

// Chapter 10 - Classes

// Modifiquei a regra (em relação ao SDK) para que ficasse como a do manual.
classDeclaration:
	 metadata ABSTRACT? CLASS typeWithParameters superclass? mixins? interfaces? LBRACE (
		metadata classMemberDefinition
	)*  RBRACE
	| metadata ABSTRACT? CLASS mixinApplicationClass;

classMemberDefinition:
	methodSignature functionBody
	| declaration ';';

methodSignature:
	constructorSignature initializers
	| factoryConstructorSignature
	| STATIC? functionSignature
	| STATIC? getterSignature
	| STATIC? setterSignature
	| operatorSignature
	| OVERRIDE functionSignature
	| constructorSignature;

declaration:
	EXTERNAL factoryConstructorSignature
	| EXTERNAL constantConstructorSignature
	| EXTERNAL constructorSignature
	| (EXTERNAL STATIC?)? getterSignature
	| (EXTERNAL STATIC?)? setterSignature
	| (EXTERNAL STATIC?)? functionSignature
	| EXTERNAL (STATIC? finalVarOrType | COVARIANT varOrType) identifierList
	| ABSTRACT (finalVarOrType | COVARIANT varOrType) identifierList
	| EXTERNAL? operatorSignature
	| STATIC (FINAL | CONST) type? staticFinalDeclarationList
	| STATIC LATE FINAL type? initializedIdentifierList
	| (STATIC | COVARIANT) LATE? varOrType initializedIdentifierList
	| LATE? (FINAL type? | varOrType) initializedIdentifierList
	| redirectingFactoryConstructorSignature
	| constantConstructorSignature (redirection | initializers)?
	| constructorSignature (redirection | initializers)?;

staticFinalDeclarationList:
	staticFinalDeclaration (',' staticFinalDeclaration)*;

staticFinalDeclaration: identifier '=' expression;

// Chapter 10.1.1 - Operators

operatorSignature: type? OPERATOR operator formalParameterList;

operator: '~' | binaryOperator | '[' ']' | '[' ']' '=';

binaryOperator:
	multiplicativeOperator
	| additiveOperator
	| shiftOperator
	| relationalOperator
	| '=='
	| bitwiseOperator;

// Chapter 10.2 - Getters

getterSignature: type? GET identifier;

// Chapter 10.3 - Setters

setterSignature: type? SET identifier formalParameterList;

// Chapter 10.6.1 - Generative Constructors

constructorSignature: constructorName formalParameterList;

constructorName: typeIdentifier ('.' identifier)?;

redirection: ':' THIS ('.' identifier)? arguments;

initializers:
	':' initializerListEntry (',' initializerListEntry)*;

initializerListEntry:
	SUPER arguments
	| SUPER '.' identifier arguments
	| fieldInitializer
	| assertion;

fieldInitializer:
	(THIS '.')? identifier '=' initializerExpression;

initializerExpression: conditionalExpression | cascade;

// Chapter 10.6.2 - Factories

factoryConstructorSignature:
	CONST? FACTORY constructorName formalParameterList;

redirectingFactoryConstructorSignature:
	CONST? FACTORY constructorName formalParameterList '=' constructorDesignation;

// Chapter 10.6.3 - Constant Constructors

constantConstructorSignature:
	CONST constructorName formalParameterList;

// Chapter 10.8 - Superclasses

superclass: EXTENDS typeNotVoidNotFunction;

mixins: WITH typeNotVoidNotFunctionList;

// Chapter 10.9 - Superinterfaces

interfaces: IMPLEMENTS typeNotVoidNotFunctionList;

// Chapter 12.1 - Mixin Classes

mixinApplicationClass:
	typeWithParameters '=' mixinApplication ';';

mixinApplication: typeNotVoidNotFunction mixins interfaces?;

// Chapter 12.2 - Mixin Declaration

mixinDeclaration:
	MIXIN typeIdentifier typeParameters? (
		ON typeNotVoidNotFunctionList
	)? interfaces? LBRACE (metadata classMemberDefinition)* RBRACE;

// Chapter 13 - Enums

enumType:
	ENUM typeIdentifier LBRACE enumEntry (',' enumEntry)* (',')? RBRACE;

// Chapter 14 - Generics

typeParameter: metadata typeIdentifier (EXTENDS typeNotVoid)?;

typeParameters: '<' typeParameter (',' typeParameter)* '>';

enumEntry: metadata identifier;

// Chapter 15 - Metadata

metadata: ('@' metadatum)*;

metadatum:
	constructorDesignation arguments
	| identifier
	| qualifiedName;

// Chapter 16 - Expressions

expression:
	functionExpression
	| throwExpression
	| assignableExpression assignmentOperator expression
	| conditionalExpression
	| widget
	// Essa parte tbm identifica o lado direito de uma atribuição, chamada de funções...
	| cascade;

widget:
  'const '  widget
 | textWidget
 | centerWidget
 | scaffoldWidget
 | appBarWidget
 | textStyleWidget
 | sizedBoxWidget
 | columnWidget
 | textFieldWidget
 | elevatedButtonWidget
 | containerWidget
 | inputDecorationWidget
 | borderWidget
 | imageWidget
 | rowWidget
 | boxDecorationWidget
 ;


textWidget: TEXT  widgetBody;
textStyleWidget: TEXT_STYLE  widgetBody ;
centerWidget: CENTER  widgetBody ;
columnWidget: COLUMN  widgetBody ;
rowWidget: ROW  widgetBody ;
sizedBoxWidget: SIZED_BOX  widgetBody ;
scaffoldWidget: SCAFFOLD  widgetBody ;
appBarWidget: APP_BAR_WIDGET  widgetBody ;
textFieldWidget: TEXT_FIELD  widgetBody ;
elevatedButtonWidget: ELEVATED_BUTTON  widgetBody ;
containerWidget: CONTAINER  widgetBody ;
inputDecorationWidget: INPUT_DECORATION_WIDGET  widgetBody ;
borderWidget: BORDER_WIDGET  widgetBody ;
boxDecorationWidget: BOX_DECORATION_WIDGET  widgetBody ;
imageWidget: IMAGE_WIDGET  '.' NETWROK_IMAGE '(' imageUrl ')' ;

imageUrl: singleLineString;


widgetBody: '(' widgetBodyProps* ')';
widgetBodyProps:
	APP_BAR ':' widget
	| TITLE ':' widget
	| CHILD ':' widget
	| STYLE ':' widget
	| CHILDREN ':' '<Widget>'? '[' (widget | ',')* ']'
	| FONTSIZE ':' fontSize
	| FONT_WEIGHT_BODY_ATT ':' fontWeight
	| CONTROLLER ':' controllerName
	| HEIGHT ':' height
	| WIDTH ':' width
	| ON_PRESSED ':' functionExpression
	| MARGIN ':' 'const '? edgeInsets
	| PADDING ':' 'const '? padding
	| COLOR ':' 'const '? colors
	| BORDER_RADIUS_ATT ':' 'const '? borderRadius
	| DECORATION_BODY_ATT ':'  widget
	| HINT_TEXT ':'  hintText
	| OBSCURE_TEXT ':'  obscureText
	| BORDER ':'  widget
	| MAIN_AXIS_ALIGNMENT_BODY_ATT ':' 'const '? mainAxisAlignment
	| MAIN_AXIS_SIZE_BODY_ATT ':' 'const '? mainAxisSize
	| ','
	| stringLiteral
	| variable
	| BODY ':' widget;

padding: edgeInsets;

borderRadius: BORDER_RADIUS '.' (circularBorderRadius);

circularBorderRadius: BORDER_RADIUS_CIRCULAR '(' circularBorderRadiusValue ')';
circularBorderRadiusValue: numericLiteral;


colors: COLORS '(' colorName ')' ;
colorName: numericLiteral; //singleLineString

height: numericLiteral;
width: numericLiteral;

obscureText:
booleanLiteral;

hintText:
singleLineString;


fontSize:
numericLiteral;



fontWeight:
fontWeightBold
;

fontWeightBold:
FONT_WEIGHT '.' FONT_WEIGHT_BOLD;

mainAxisAlignment:
    mainAxisAlignmentCenter
;

mainAxisSize:
    mainAxisSizeMin
;
mainAxisSizeMin:
    MAIN_AXIS_SIZE '.' MAIN_AXIS_SIZE_MIN
;

mainAxisAlignmentCenter:
 MAIN_AXIS_ALIGNMENT '.' MAIN_AXIS_ALIGNMENT_CENTER
;

edgeInsets:
    EDGEINSETS '.' EDGEINSETS_ALL'(' edgeInsetsNumber ')'
;
edgeInsetsNumber: numericLiteral;
variable:IDENTIFIER ;

controllerName: IDENTIFIER;

expressionWithoutCascade:
	functionExpressionWithoutCascade
	| throwExpressionWithoutCascade
	| assignableExpression assignmentOperator expressionWithoutCascade
	| conditionalExpression;

expressionList: expression (',' expression)*;

primary:
	thisExpression
	| SUPER unconditionalAssignableSelector
	| constObjectExpression
	| newExpression
	| constructorInvocation
	| functionPrimary
	| '(' expression ')'
	| literal
	| identifier;

// Chapter 16.3 - Constants

literal:
	nullLiteral
	| booleanLiteral
	| numericLiteral
	| stringLiteral
	| symbolLiteral
	| setOrMapLiteral
	| listLiteral;

// Chapter 16.4 - Null

nullLiteral: NULL;

// Chapter 16.5 - Numbers

numericLiteral: NUMBER | HEX_NUMBER;

// Chapter 16.6 - Booleans

booleanLiteral: TRUE | FALSE;

// Chapter 16.7 - Strings

stringLiteral: singleLineString+; //	| multiLineString+

// Chapter 16.8 - Symbols

symbolLiteral: '#' (operator | (identifier ('.' identifier)*));

// Chapter 16.9 - Lists

listLiteral: CONST? typeArguments? '[' elements? ']';

// Chapter 16.10 - Maps Maps & Sets são tratados da mesma maneira no SDK :|

setOrMapLiteral: CONST? typeArguments? LBRACE elements? RBRACE;

elements: element (',' element)* ','?;

element:
	expressionElement
	| mapElement
	| spreadElement
	| ifElement
	| forElement;

expressionElement: expression;

mapElement: expression ':' expression;

spreadElement: ('...' | '...?') expression;

ifElement: IF '(' expression ')' element (ELSE element)?;

forElement: AWAIT? FOR '(' forLoopParts ')' element;

// Chapter 16.12 - Throw

throwExpression: THROW expression;

throwExpressionWithoutCascade: THROW expressionWithoutCascade;

// Chapter 16.13 - Function Expressions

functionExpression: formalParameterPart functionExpressionBody;

functionExpressionBody:
	'=>'  expression 
	| '(' normalFormalParameters ')' '=>'  expression
	| block
	| ASYNC '=>' expression ;

functionExpressionWithoutCascade:
	formalParameterPart functionExpressionWithoutCascadeBody;

functionExpressionWithoutCascadeBody:
	'=>'  expressionWithoutCascade 
	| ASYNC '=>' expressionWithoutCascade ;

// TODO: Qual seria um exemplo de functionPrimary?
functionPrimary: formalParameterPart functionPrimaryBody;

functionPrimaryBody:
	 block 
	| (ASYNC | ASYNC '*' | SYNC '*')  block ;

// Chapter 16.14 - This

thisExpression: THIS;

// Chapter 16.15.1 - New

newExpression: NEW constructorDesignation arguments;

// Chapter 16.15.2 - Const

constObjectExpression: CONST constructorDesignation arguments;

// Chapter 16.17.1 - Actual Arguments Lists

arguments: '(' argumentList? ')';

argumentList:
	namedArgument (',' namedArgument)*
	| expressionList (',' namedArgument)*;

namedArgument: label expression;

// Chapter 16.21.2 - Cascaded Invocations

cascade:
	cascade '..' cascadeSection
	| conditionalExpression ('?..' | '..') cascadeSection;

cascadeSection: cascadeSelector cascadeSectionTail;

cascadeSelector: '[' expression ']' | identifier;

cascadeSectionTail:
	cascadeAssignment
	| selector* (assignableSelector cascadeAssignment)?;

cascadeAssignment: assignmentOperator expressionWithoutCascade;

// Chapter 16.23 - Assignment

assignmentOperator: '=' | compoundAssignmentOperator;

compoundAssignmentOperator:
	'*='
	| '/='
	| '~/='
	| '%='
	| '+='
	| '-='
	| '<<='
	| '>' '>' '>' '='
	| '>' '>' '='
	| '&='
	| '^='
	| '|='
	| '??=';

// Chapter 16.24 - Conditional

conditionalExpression:
	ifNullExpression (
		'?' expressionWithoutCascade ':' expressionWithoutCascade
	)?;

// Chapter 16.25 - If-null Expressions

ifNullExpression:
	logicalOrExpression ('??' logicalOrExpression)*;

// Chapter 16.26 - Logical Boolean Expressions

logicalOrExpression:
	logicalAndExpression ('||' logicalAndExpression)*;

logicalAndExpression:
	equalityExpression ('&&' equalityExpression)*;

// Chapter 16.27 - Equality

equalityExpression:
	relationalExpression (equalityOperator relationalExpression)?
	| SUPER equalityOperator relationalExpression;

equalityOperator: '==' | '!=';

// Chapter 16.28 - Relational Expressions

relationalExpression:
	bitwiseOrExpression (
		typeTest
		| typeCast
		| relationalOperator bitwiseOrExpression
	)?
	| SUPER relationalOperator bitwiseOrExpression;

relationalOperator: GE = '>=' | GT = '>' | LE = '<=' | LT = '<';

// Chapter 16.29 - Bitwise Expressions

bitwiseOrExpression:
	bitwiseXorExpression ('|' bitwiseXorExpression)*
	| SUPER ('|' bitwiseXorExpression)+;

bitwiseXorExpression:
	bitwiseAndExpression ('^' bitwiseAndExpression)*
	| SUPER ('^' bitwiseAndExpression)+;

bitwiseAndExpression:
	shiftExpression ('&' shiftExpression)*
	| SUPER ('&' shiftExpression)+;

bitwiseOperator: '&' | '^' | '|';

// Chapter 16.30 - Shift

shiftExpression:
	additiveExpression (shiftOperator additiveExpression)*
	| SUPER (shiftOperator additiveExpression)+;

shiftOperator: '<<' | '>' '>' '>' | '>' '>';

// Chapter 16.31 - Additive Expressions

additiveExpression:
	multiplicativeExpression (
		additiveOperator multiplicativeExpression
	)*
	| SUPER (additiveOperator multiplicativeExpression)+;

additiveOperator: '+' | '-';

// Chapter 16.32 - Multiplicative Expressions

multiplicativeExpression:
	unaryExpression (multiplicativeOperator unaryExpression)*
	| SUPER (multiplicativeOperator unaryExpression)+;

multiplicativeOperator: '*' | '/' | '%' | '~/';

// Chapter 16.33 - Unary Expressions

unaryExpression:
	prefixOperator unaryExpression
	| awaitExpression
	| postfixExpression
	| (minusOperator | tildeOperator) SUPER
	| incrementOperator assignableExpression;

prefixOperator:
	minusOperator
	| negationOperator
	| tildeOperator;

minusOperator: '-';

negationOperator: '!';

tildeOperator: '~';

// Chapter 16.34 - Await Expressions

awaitExpression: AWAIT unaryExpression;

// Chapter 16.35 - Postfix Expressions

// Chamada de função passa especificamente por aqui
postfixExpression:
	assignableExpression postfixOperator
	| primary selector*;

postfixOperator: incrementOperator;

constructorInvocation:
	typeName typeArguments '.' identifier arguments;

selector: '!' | assignableSelector | argumentPart;

argumentPart: typeArguments? arguments;

incrementOperator: '++' | '--';

// Chapter 16.36 - Assignable Expressions

assignableExpression:
	SUPER unconditionalAssignableSelector
	| primary assignableSelectorPart
	| identifier;

assignableSelectorPart: selector* assignableSelector;

unconditionalAssignableSelector:
	'[' expression ']'
	| '.' identifier;

assignableSelector:
	unconditionalAssignableSelector
	| '?.' identifier
	| '?' '[' expression ']';

// Chapter 16.37 - Identifier Reference

identifierNotFUNCTION:
	IDENTIFIER
	| ABSTRACT // Built-in identifier.
	| AS // Built-in identifier.
	| COVARIANT // Built-in identifier.
	| DEFERRED // Built-in identifier.
	| DYNAMIC // Built-in identifier.
	| EXPORT // Built-in identifier.
	| EXTERNAL // Built-in identifier.
	| FACTORY // Built-in identifier.
	| GET // Built-in identifier.
	| IMPLEMENTS // Built-in identifier.
	| IMPORT // Built-in identifier.
	| INTERFACE // Built-in identifier.
	| LATE // Built-in identifier.
	| LIBRARY // Built-in identifier.
	| MIXIN // Built-in identifier.
	| OPERATOR // Built-in identifier.
	| PART // Built-in identifier.
	| REQUIRED // Built-in identifier.
	| SET // Built-in identifier.
	| STATIC // Built-in identifier.
	| TYPEDEF // Built-in identifier.
	| ASYNC // Not a built-in identifier.
	| HIDE // Not a built-in identifier.
	| OF // Not a built-in identifier.
	| ON // Not a built-in identifier.
	| SHOW // Not a built-in identifier.
	| SYNC // Not a built-in identifier.
	| BUILD // Not a built-in identifier.
	;

identifier:
	identifierNotFUNCTION
	| FUNCTION; // Built-in identifier that can be used as a type.

qualifiedName:
	typeIdentifier '.' identifier
	| typeIdentifier '.' typeIdentifier '.' identifier;

typeIdentifier:
	IDENTIFIER
	| DYNAMIC // Built-in identifier that can be used as a type.
	| ASYNC // Not a built-in identifier.
	| HIDE // Not a built-in identifier.
	| OF // Not a built-in identifier.
	| ON // Not a built-in identifier.
	| SHOW // Not a built-in identifier.
	| WIDGET // Not a built-in identifier.
	| BUILD_CONTEXT // Not a built-in identifier.
	| SYNC // Not a built-in identifier.
	| STATELESS // Not a built-in identifier.
	;

// Chapter 16.38 - Type Test

typeTest: isOperator typeNotVoid;

isOperator: IS '!'?;

// Chapter 16.39 - Type Cast

typeCast: asOperator typeNotVoid;

asOperator: AS;

// Chapter 17 - Statements

statements: statement*;

statement: label* nonLabelledStatement;

nonLabelledStatement:
	block
	| localVariableDeclaration
	| forStatement
	| whileStatement
	| doStatement
	| switchStatement
	| ifStatement
	| rethrowStatement
	| tryStatement
	| breakStatement
	| continueStatement
	| returnStatement
	| localFunctionDeclaration
	| assertStatement
	| yieldStatement
	| yieldEachStatement
	| navigationStatement
	| expressionStatement
	;


navigationStatement:
    NAVIGATOR '.' OF '(' CONTEXT ')' '.' PUSH '(' materialPageRoute ')' ';'
;

materialPageRoute:
 MATERIAL_PAGEROUTE '(' BUILDER ':'   formalParameterPart '=>' 'const '? className '(' (classMember | ',')* ')' ')' ','?
;
className:
IDENTIFIER;
classMember:
 key ':' value
;
key: IDENTIFIER;
value: IDENTIFIER |
 textController
 ;

textController: controllerName '.text';


// Chapter 17.2 - Expression Statements

expressionStatement: expression? ';';

// Chapter 17.3 - Local Variable Declaration

localVariableDeclaration:
	metadata initializedVariableDeclaration ';';

// Chapter 17.4 - Local Function Declaration

localFunctionDeclaration:
	metadata functionSignature functionBody;

// Chapter 17.5 - If Aceitando somente if com chaves {}
ifStatement:
	IF '(' expression ')' ifPart = block (ELSE elsePart = block)?;

// Chapter 17.6 - For

forStatement: AWAIT? FOR '(' forLoopParts ')' statement;

forLoopParts:
	metadata declaredIdentifier IN expression
	| metadata identifier IN expression
	| forInitializerStatement expression? ';' expressionList?;

// The localVariableDeclaration cannot be CONST, but that can be enforced in a later phase, and the
// grammar allows it.
forInitializerStatement:
	localVariableDeclaration
	| expression? ';';

// Chapter 17.7 - While

whileStatement: WHILE '(' expression ')' block;

// Chapter 17.8 - Do

doStatement: DO statement WHILE '(' expression ')' ';';

// Chapter 17.9 - Switch

switchStatement:
	SWITCH '(' expression ')' LBRACE switchCase* defaultCase? RBRACE;

switchCase: label* CASE expression ':' statements;

defaultCase: label* DEFAULT ':' statements;

// Chapter 17.10 - Rethrow

rethrowStatement: RETHROW ';';

// Chapter 17.11 - Try

tryStatement: TRY block (onPart+ finallyPart? | finallyPart);

onPart: catchPart block | ON typeNotVoid catchPart? block;

catchPart: CATCH '(' identifier (',' identifier)? ')';

finallyPart: FINALLY block;

// Chapter 17.12 - Return

returnStatement: RETURN expression? ';';

// Chapter 17.13 - Labels

label: identifier ':';

// 17.14 - Break

breakStatement: 'break' identifier? ';';

// 17.13 - Continue

continueStatement: 'continue' identifier? ';';

// 17.16 - Yield and Yield-Each

yieldStatement: 'yield' expression ';';

yieldEachStatement: 'yield*' expression ';';

// 17.17 Assert

assertStatement: assertion ';';

assertion: 'assert' '(' expression (',' expression)? ','? ')';

// Chapter 18 - Libraries

topLevelDefinition:
	classDeclaration
	| mixinDeclaration
/*|	extensionDeclaration*/
	| enumType
	| typeAlias
	| EXTERNAL functionSignature ';'
	| EXTERNAL getterSignature ';'
	| EXTERNAL setterSignature ';'
	| EXTERNAL finalVarOrType identifierList ';'
	| getterSignature functionBody
	| setterSignature functionBody
	| functionSignature functionBody
	| (FINAL | CONST) type? staticFinalDeclarationList ';'
	| LATE FINAL type? initializedIdentifierList ';'
	| LATE? varOrType identifier ('=' expression)? (
		',' initializedIdentifier
	)* ';';

// Chapter 18.1 - Imports

identifierList: identifier (',' identifier)*;

// Chapter 19.1 - Static Types

type: functionType '?'? | typeNotFunction;

typeNotVoid: functionType '?'? | typeNotVoidNotFunction;

typeNotFunction: typeNotVoidNotFunction | VOID;

typeNotVoidNotFunction:
	typeName typeArguments? '?'?
	| FUNCTION '?'?;

typeName: typeIdentifier ('.' typeIdentifier)?;

typeArguments: '<' typeList '>';

typeList: type (',' type)*;

typeNotVoidNotFunctionList:
	typeNotVoidNotFunction (',' typeNotVoidNotFunction)*;

functionTypeTail: FUNCTION typeParameters? parameterTypeList;

functionTypeTails:
	functionTypeTail '?'? functionTypeTails
	| functionTypeTail;

functionType:
	functionTypeTails
	| typeNotFunction functionTypeTails;

parameterTypeList:
	'(' ')'
	| '(' normalParameterTypes ',' optionalParameterTypes ')'
	| '(' normalParameterTypes ','? ')'
	| '(' optionalParameterTypes ')';

normalParameterTypes:
	normalParameterType (',' normalParameterType)*;

normalParameterType: typedIdentifier | type;

optionalParameterTypes:
	optionalPositionalParameterTypes
	| namedParameterTypes;

optionalPositionalParameterTypes:
	'[' normalParameterTypes ','? ']';

namedParameterTypes:
	LBRACE namedParameterType (',' namedParameterType)* ','? RBRACE;

namedParameterType: REQUIRED? typedIdentifier;

typedIdentifier: type identifier;

constructorDesignation:
	typeIdentifier
	| qualifiedName
	| typeName typeArguments ('.' identifier)?;

//Chapter 19.3 - Type Aliases

typeAlias:
	TYPEDEF typeIdentifier typeParameters? '=' functionType ';'
	| TYPEDEF functionTypeAlias;

functionTypeAlias: functionPrefix formalParameterPart ';';

functionPrefix: type identifier | identifier;

singleLineString:
	 RAW_SINGLE_LINE_STRING
	| SINGLE_LINE_STRING_SQ_BEGIN_END
	| SINGLE_LINE_STRING_SQ_BEGIN_MID expression (
		SINGLE_LINE_STRING_SQ_MID_MID expression
	)* SINGLE_LINE_STRING_SQ_MID_END
	| SINGLE_LINE_STRING_DQ_BEGIN_END
	| SINGLE_LINE_STRING_DQ_BEGIN_MID expression (
		SINGLE_LINE_STRING_DQ_MID_MID expression
	)* SINGLE_LINE_STRING_DQ_MID_END;



//TODO: VOLTAR COM MULTILINE STRING DEPOIS? multiLineString RAW_MULTI_LINE_STRING |
// MULTI_LINE_STRING_SQ_BEGIN_END | MULTI_LINE_STRING_SQ_BEGIN_MID expression
// (MULTI_LINE_STRING_SQ_MID_MID expression)* MULTI_LINE_STRING_SQ_MID_END |
// MULTI_LINE_STRING_DQ_BEGIN_END | MULTI_LINE_STRING_DQ_BEGIN_MID expression
// (MULTI_LINE_STRING_DQ_MID_MID expression)* MULTI_LINE_STRING_DQ_MID_END ;

// ------------------------------- Lexer Rules -------------------------------

fragment LETTER: 'a' .. 'z' | 'A' .. 'Z';
fragment DIGIT: '0' .. '9';
fragment EXPONENT: ('e' | 'E') ('+' | '-')? DIGIT+;
fragment HEX_DIGIT:
	('a' | 'b' | 'c' | 'd' | 'e' | 'f')
	| ('A' | 'B' | 'C' | 'D' | 'E' | 'F')
	| DIGIT;

// Reserved words.

ASSERT: 'assert';
BREAK: 'break';
CASE: 'case';
CATCH: 'catch';
CLASS: 'class';
CONST: 'const';
CONTINUE: 'continue';
DEFAULT: 'default';
DO: 'do';
ELSE: 'else';
ENUM: 'enum';
EXTENDS: 'extends';
FALSE: 'false';
FINAL: 'final';
FINALLY: 'finally';
FOR: 'for';
IF: 'if';
IN: 'in';
IS: 'is';
NEW: 'new';
NULL: 'null';
RETHROW: 'rethrow';
RETURN: 'return';
SUPER: 'super';
SWITCH: 'switch';
THIS: 'this';
THROW: 'throw';
TRUE: 'true';
TRY: 'try';
VAR: 'var';
VOID: 'void';
WHILE: 'while';
WITH: 'with';

// Built-in identifiers.

ABSTRACT: 'abstract';
AS: 'as';
COVARIANT: 'covariant';
DEFERRED: 'deferred';
DYNAMIC: 'dynamic';
EXPORT: 'export';
EXTENSION: 'extension';
EXTERNAL: 'external';
FACTORY: 'factory';
FUNCTION: 'Function';
GET: 'get';
IMPLEMENTS: 'implements';
IMPORT: 'import';
INTERFACE: 'interface';
LATE: 'late';
LIBRARY: 'library';
OPERATOR: 'operator';
MIXIN: 'mixin';
PART: 'part';
REQUIRED: 'required';
SET: 'set';
STATIC: 'static';
TYPEDEF: 'typedef';
// "Contextual keywords".
AWAIT: 'await';
YIELD: 'yield';

// Other words used in the grammar.

ASYNC: 'async';
HIDE: 'hide';
OF: 'of';
ON: 'on';
SHOW: 'show';
SYNC: 'sync';
BUILD_CONTEXT: 'BuildContext';
WIDGET: 'Widget';
BUILD: 'build';

// Widgets type
STATELESS: 'StatelessWidget';
SCAFFOLD: 'Scaffold';
TEXT_STYLE: 'TextStyle';
TEXT_FIELD: 'TextField';
ELEVATED_BUTTON: 'ElevatedButton';
TEXT: 'Text';
CENTER: 'Center';
COLUMN: 'Column';
ROW: 'Row';
SIZED_BOX: 'SizedBox';
APP_BAR_WIDGET: 'AppBar';
CONTAINER: 'Container';
INPUT_DECORATION_WIDGET: 'InputDecoration';
BORDER_WIDGET: 'OutlineInputBorder';
BOX_DECORATION_WIDGET: 'BoxDecoration';

IMAGE_WIDGET: 'Image';
NETWROK_IMAGE: 'network';

// Widget bodies
BODY: 'body';
TITLE: 'title';
CHILD: 'child';
FONTSIZE: 'fontSize';
CONTROLLER: 'controller';
HEIGHT: 'height';
WIDTH: 'width';
ON_PRESSED: 'onPressed';
STYLE: 'style';
CHILDREN: 'children';
APP_BAR: 'appBar';
MARGIN: 'margin';
EDGEINSETS: 'EdgeInsets';
EDGEINSETS_ALL: 'all';
MAIN_AXIS_ALIGNMENT: 'MainAxisAlignment';
MAIN_AXIS_ALIGNMENT_CENTER: 'center';
MAIN_AXIS_ALIGNMENT_BODY_ATT: 'mainAxisAlignment';

MAIN_AXIS_SIZE: 'MainAxisSize';
MAIN_AXIS_SIZE_MIN: 'min';
MAIN_AXIS_SIZE_BODY_ATT: 'mainAxisSize';

DECORATION_BODY_ATT: 'decoration';
HINT_TEXT: 'hintText';
BORDER: 'border';
OBSCURE_TEXT: 'obscureText';


FONT_WEIGHT: 'FontWeight';
FONT_WEIGHT_BOLD: 'bold';
FONT_WEIGHT_BODY_ATT: 'fontWeight';


PADDING: 'padding';

BORDER_RADIUS_ATT: 'borderRadius';
BORDER_RADIUS: 'BorderRadius';
BORDER_RADIUS_CIRCULAR: 'circular';

COLOR: 'color';
COLORS: 'Color';


NAVIGATOR: 'Navigator';
CONTEXT: 'context';
PUSH: 'push';
MATERIAL_PAGEROUTE: 'MaterialPageRoute';
BUILDER: 'builder';

// Lexical tokens that are not words.
NUMBER:
	DIGIT+ '.' DIGIT+ EXPONENT?
	| DIGIT+ EXPONENT?
	| '.' DIGIT+ EXPONENT?;

HEX_NUMBER: '0x' HEX_DIGIT+ | '0X' HEX_DIGIT+;

RAW_SINGLE_LINE_STRING:
	'r' '\'' (~('\'' | '\r' | '\n'))* '\''
	| 'r' '"' (~('"' | '\r' | '\n'))* '"';

//RAW_MULTI_LINE_STRING:
// 'r' '"""' (.)*? '"""' | 'r' '\'\'\'' (.)*? '\'\'\'' ;

LBRACE: '{';

RBRACE: '}';

fragment SIMPLE_STRING_INTERPOLATION: '$' IDENTIFIER_NO_DOLLAR;

fragment ESCAPE_SEQUENCE:
	'\\n'
	| '\\r'
	| '\\b'
	| '\\t'
	| '\\v'
	| '\\x' HEX_DIGIT HEX_DIGIT
	| '\\u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
	| '\\u{' HEX_DIGIT_SEQUENCE '}';

fragment HEX_DIGIT_SEQUENCE:
	HEX_DIGIT HEX_DIGIT? HEX_DIGIT? HEX_DIGIT? HEX_DIGIT? HEX_DIGIT?;

fragment STRING_CONTENT_COMMON:
	~('\\' | '\'' | '"' | '$' | '\r' | '\n')
	| ESCAPE_SEQUENCE
	| '\\' ~(
		'n'
		| 'r'
		| 'b'
		| 't'
		| 'v'
		| 'x'
		| 'u'
		| '\r'
		| '\n'
	)
	| SIMPLE_STRING_INTERPOLATION;

fragment STRING_CONTENT_SQ: STRING_CONTENT_COMMON | '"';

SINGLE_LINE_STRING_SQ_BEGIN_END: '\'' STRING_CONTENT_SQ*  '\'';



SINGLE_LINE_STRING_SQ_BEGIN_MID: '\'' STRING_CONTENT_SQ* '${';

SINGLE_LINE_STRING_SQ_MID_MID: '}' STRING_CONTENT_SQ* '${';

SINGLE_LINE_STRING_SQ_MID_END: '}' STRING_CONTENT_SQ* '\'';

fragment STRING_CONTENT_DQ: STRING_CONTENT_COMMON | '\'';

SINGLE_LINE_STRING_DQ_BEGIN_END: '"' STRING_CONTENT_DQ* '"';


SINGLE_LINE_STRING_DQ_BEGIN_MID: '"' STRING_CONTENT_DQ* '${';

SINGLE_LINE_STRING_DQ_MID_MID: '}' STRING_CONTENT_DQ* '${';

SINGLE_LINE_STRING_DQ_MID_END: '}' STRING_CONTENT_DQ* '"';

fragment QUOTES_SQ: | '\'' | '\'\'';

// Explicação do SDK. Read string contents, which may be almost anything, but stop when seeing
// '\'\'\'' and when seeing '${'. We do this by allowing all other possibilities including escapes,
// simple interpolation, and fewer than three '\''.
fragment STRING_CONTENT_TSQ:
	QUOTES_SQ (
		STRING_CONTENT_COMMON
		| '"'
		| '\r'
		| '\n'
		| '\\\r'
		| '\\\n'
	);

//MULTI_LINE_STRING_SQ_BEGIN_END:
// '\'\'\'' STRING_CONTENT_TSQ* '\'\'\'' ;

//MULTI_LINE_STRING_SQ_BEGIN_MID:
// '\'\'\'' STRING_CONTENT_TSQ* QUOTES_SQ '${'
// 
// ;

//MULTI_LINE_STRING_SQ_MID_MID:
// '}' STRING_CONTENT_TSQ* QUOTES_SQ '${'
// 
// ;

//MULTI_LINE_STRING_SQ_MID_END:
// '}' STRING_CONTENT_TSQ* '\'\'\'' ;

fragment QUOTES_DQ: | '"' | '""';

// Explicação do SDK. Read string contents, which may be almost anything, but stop when seeing '"""'
// and when seeing '${'. We do this by allowing all other possibilities including escapes, simple
// interpolation, and fewer-than-three '"'.
fragment STRING_CONTENT_TDQ:
	QUOTES_DQ (
		STRING_CONTENT_COMMON
		| '\''
		| '\r'
		| '\n'
		| '\\\r'
		| '\\\n'
	);

//MULTI_LINE_STRING_DQ_BEGIN_END:
// '"""' STRING_CONTENT_TDQ* '"""' ;

//MULTI_LINE_STRING_DQ_BEGIN_MID:
// '"""' STRING_CONTENT_TDQ* QUOTES_DQ '${'
// 
// ;

//MULTI_LINE_STRING_DQ_MID_MID:
// '}' STRING_CONTENT_TDQ* QUOTES_DQ '${'
// 
// ;

//MULTI_LINE_STRING_DQ_MID_END:
// '}' STRING_CONTENT_TDQ* '"""' ;

fragment IDENTIFIER_START_NO_DOLLAR: LETTER | '_';

fragment IDENTIFIER_PART_NO_DOLLAR:
	IDENTIFIER_START_NO_DOLLAR
	| DIGIT;

fragment IDENTIFIER_NO_DOLLAR:
	IDENTIFIER_START_NO_DOLLAR IDENTIFIER_PART_NO_DOLLAR*;

fragment IDENTIFIER_START: IDENTIFIER_START_NO_DOLLAR | '$';

fragment IDENTIFIER_PART: IDENTIFIER_START | DIGIT;

SCRIPT_TAG: '#!' (~('\r' | '\n'))* NEWLINE;

IDENTIFIER: IDENTIFIER_START IDENTIFIER_PART*;

SINGLE_LINE_COMMENT: '//' (~('\r' | '\n'))* NEWLINE? -> skip;

MULTI_LINE_COMMENT:
	'/*' (MULTI_LINE_COMMENT | .)*? '*/' -> skip;

fragment NEWLINE: ('\r' | '\n' | '\r\n');

WS: (' ' | '\t' | '\r' | '\n')+ -> skip;

OVERRIDE: '@override';