{

module Parser (main) where

import Lexer (alexScanTokens)
import Data (Token(..), Type(..), Pointer(..))

}

%name parseCLike
%tokentype { Token }
%error { parseError }

%token
	int		{ Int $$ }
	double	{ Double $$ }
	char	{ Char $$ }
	string	{ String $$ }
	label	{ Label $$ }
	{	{ BrakOpen }
	brakClose	{ BrakClose }
	sBrakOpen	{ SBrakOpen }
	sBrakClose	{ SBrakClose }
	cBrakOpen	{ CBrakOpen }
	cBrakClose	{ CBrakClose }
	assignOp	{ AssignOp }
	compareOp	{ CompareOp }
	lessThanOp	{ LessThanOp }
	greaterThanOp	{ GreaterThanOp }
	eLessThanOp	{ ELessThanOp }
	eGreaterThanOp	{ EGreaterThanOp } 
	addOp		{ AddOp }
	subOp		{ SubOp }
	mulOp		{ MulOp	}
	divOp		{ DivOp }
	incOp		{ IncOp }
	decOp		{ DecOp }
	comma		{ Comma }
	semicolon	{ Semicolon }
	dereference	{ Dereference }
	and		{ And }
	or		{ Or }
	negOp		{ NegOp }

	
%%
S : [TopStatement] ;

terminator TopStatement "" ;
TopStatement : Definition ;

terminator Statement "" ;
Statement : Assignment ;
		| Definition  ;
		| FunctionCall ;
		| "return" Expression ";" ;
		| FlowControl;

Assignment : LValue "=" RValue ";" ;

Definition : TypeLabel LValue ";" ;
		| TypeLabel Assignment ;
		| FunctionDef ;
FunctionDef : TypeLabel Label "(" [Argument] ")" "{" [Statement] "}" ;
		| "void" Label "(" [Argument] ")" "{" [Statement] "}" ;

LValue : Label [Array];
		| Pointer Label ;

RValue : Expression ;
		| Assignment ;
		| FunctionCall ;
		| ArrayDef ;
		| Dereference

Type : Integer ;
		| Char ;
		| String ;
		| "True" ;
		| "False" ;
		| Double ;

TypeLabel : "int";
		| "char";
		| "double";
		| "String";

PredFunction : "readInt" "(" ")" ;
		| "writeInt(" Parameter ")";
		| "readFloat" "(" ")" ;
		| "writeFloat(" Parameter ")";
		| "readChar" "(" ")" ;
		| "writeChar(" Parameter ")";
		| "readString" "(" ")" ;
		| "writeString(" Parameter ")";

FunctionCall : Label "(" [Parameter] ")" ";" ;
		| PredFunction ";" ;
separator Parameter "," ;
Parameter : RValue ;

separator Argument "," ;
Argument : PassingType TypeLabel Label ;
PassingType : ;
		| "valres";

FlowControl : IfThenElse ;
		| While ;
		| For ;

separator FlowStatement ";" ;
FlowStatement : "break"  ;
		| "continue" ;
		| Statement;

IfThenElse :	"if" "(" Expression ")" Then ;
		| "if" "(" Expression ")" Then Else ;
Then : "{" [Statement] "}" ;
Else : "else" Then ;
While : "while" "(" Expression ")" "{" [FlowStatement] "}" ;
For : "for" "(" ForInd ";" ForExpression ";" ForExpression ")" "{" [FlowStatement] "}" ;
ForInd : ForVars ;
		| ;
ForVars :	ForVar "," ForVars ;
		| ForVar ;
ForVar :  Assignment;
ForExpression : Expression ;
		| ;

Label : Ident ;

separator Array "" ;
Array : "[" Integer "]" ;
ArrayDef : "{" [ArrayItem] "}" ;
separator ArrayItem "," ;
ArrayItem : RValue ;

Pointer : "*";

Expression1 :	Expression1 "&&" Expression2 ;
		| Expression1 "||" Expression2 ;
Expression2 :	"!" Expression3 ;
Expression3 :	Expression3 "==" Expression4 ;
		| Expression3 "!=" Expression4 ;
		| Expression3 "<" Expression4 ;
		| Expression3 ">" Expression4 ;
		| Expression3 "<=" Expression4 ;
		| Expression3 ">=" Expression4 ;
Expression4 :	Expression4 "+" Expression5 ;
		| Expression4 "-" Expression5 ;
Expression5 :	Expression5 "*" Expression6 ;
		| Expression5 "/" Expression6 ;
Expression6 :	Expression6 "++" ;
		| Expression6 "--" ;
Expression7 :	"++" Expression7 ;
		| "--" Expression7 ;
		| Type;
		| LValue;
		| FunctionCall;

{



}
