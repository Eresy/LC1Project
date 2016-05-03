{

module Parser (main) where

import Lexer (alexScanTokens)
import Data (Token(..), Type(..), Pointer(..))

}

%name parseCLike
%tokentype { Token }
%error { parseError }

%token
	int_		{ Int $$ }
	double_	{ Double $$ }
	char_	{ Char $$ }
	string_	{ String $$ }
	label_	{ Label $$ }
	brakOpen_	{ BrakOpen }
	brakClose_	{ BrakClose }
	sBrakOpen_	{ SBrakOpen }
	sBrakClose_	{ SBrakClose }
	cBrakOpen_	{ CBrakOpen }
	cBrakClose_	{ CBrakClose }
	assignOp_	{ AssignOp }
	compareOp_	{ CompareOp }
	lessThanOp_	{ LessThanOp }
	greaterThanOp_	{ GreaterThanOp }
	eLessThanOp_	{ ELessThanOp }
	eGreaterThanOp_	{ EGreaterThanOp } 
	addOp_		{ AddOp }
	subOp_		{ SubOp }
	mulOp_		{ MulOp	}
	divOp_		{ DivOp }
	incOp_		{ IncOp }
	decOp_		{ DecOp }
	comma_		{ Comma }
	semicolon_	{ Semicolon }
	dereference_	{ Dereference }
	and_		{ And }
	or_		{ Or }
	negOp_		{ NegOp }
	break_		{ Break }
	continue_	{ Continue }
	return_		{ Return }

	
%%
S : TopStatements {}

TopStatements	:   TopStatement TopStatements {}
TopStatement	:   Definition {}

Statement   :	Assignment {}
		| Definition  {}
		| FunctionCall {}
		| return_ Expression semicolon_ {}
		| FlowControl {}

Assignment  :	LValue assignOp_ RValue semicolon_ {}

Definition  :	TypeLabel LValue semicolon_ {}
		| TypeLabel Assignment {}
		| FunctionDef {}

FunctionDef :	TypeLabel Label brakOpen_ [Argument] brakClose_ cBrakOpen_ [Statement] cBrakClose_ {}
		| "void" Label brakOpen_  [Argumenta brakClose_ cBrakOpen_ [Statement] cBrakClose_ {}

LValue	    :	Label ArrayList {}
		| Pointer Label {}

RValue	:	Expression {}
		| Assignment {}
		| FunctionCall {}
		| ArrayDef {}
		| Dereference

Type	:	Integer {}
		| Char {}
		| String {}
		| "True" {}
		| "False" {}
		| Double {}

TypeLabel   :	"int"	    {}
		| "char"    {}
		| "double"  {}
		| "String"  {}

PredFunction : "readInt" "(" ")" {}
		| "writeInt(" Parameter ")"{}
		| "readFloat" "(" ")" {}
		| "writeFloat(" Parameter ")"{}
		| "readChar" "(" ")" {}
		| "writeChar(" Parameter ")"{}
		| "readString" "(" ")" {}
		| "writeString(" Parameter ")"{}

FunctionCall :	Label brakOpen Parameters brakClose ";" {}
		| PredFunction ";" {}

Parameters  :	Parameter Comma Parameters {}
		| Parameter {}
Parameter   : RValue {}

separator Argument "," {}
Argument : PassingType TypeLabel Label {}
PassingType : {}
		| "valres"{}

FlowControl : IfThenElse {}
		| While {}
		| For {}

separator FlowStatement ";" {}
FlowStatement : "break"  {}
		| "continue" {}
		| Statement{}

IfThenElse :	"if" "(" Expression ")" Then {}
		| "if" "(" Expression ")" Then Else {}
Then : "{" [Statement] "}" {}
Else : "else" Then {}
While : "while" "(" Expression ")" "{" [FlowStatement] "}" {}
For : "for" "(" ForInd ";" ForExpression ";" ForExpression ")" "{" [FlowStatement] "}" {}
ForInd : ForVars {}
		| {}
ForVars :	ForVar "," ForVars {}
		| ForVar {}
ForVar :  Assignment{}
ForExpression : Expression {}
		| {}

Label : Ident {}

separator Array "" {}
Array : "[" Integer "]" {}
ArrayDef : "{" [ArrayItem] "}" {}
separator ArrayItem "," {}
ArrayItem : RValue {}

Pointer : "*"{}

Expression1 :	Expression1 "&&" Expression2 {}
		| Expression1 "||" Expression2 {}
Expression2 :	"!" Expression3 {}
Expression3 :	Expression3 "==" Expression4 {}
		| Expression3 "!=" Expression4 {}
		| Expression3 "<" Expression4 {}
		| Expression3 ">" Expression4 {}
		| Expression3 "<=" Expression4 {}
		| Expression3 ">=" Expression4 {}
Expression4 :	Expression4 "+" Expression5 {}
		| Expression4 "-" Expression5 {}
Expression5 :	Expression5 "*" Expression6 {}
		| Expression5 "/" Expression6 {}
Expression6 :	Expression6 "++" {}
		| Expression6 "--" {}
Expression7 :	"++" Expression7 {}
		| "--" Expression7 {}
		| Type{}
		| LValue{}
		| FunctionCall{}

{



}
