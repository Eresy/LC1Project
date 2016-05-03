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
	equalsOp_	{ EqualsOp }
	diffOp_		{ DiffOp }
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
	intLabel_	{ IntLabel }
	floatLabel_	{ FloatLabel }
	charLabel_	{ CharLabel }
	stringLabel_	{ StringLabel }
	voidLabel_	{ VoidLabel }
	if_		{ If }
	else_		{ Else }
	for_		{ For }
	while_		{ While }
	readInt_	{ ReadIntPF }
	writeInt_	{ WriteIntPF }
	readFloat_	{ WriteFloatPF }
	writeFloat_	{ WriteFloatPF }
	readChar_	{ ReadCharPF }
	writeChar_	{ WriteCharPF }
	readString_	{ ReadStringPF }
	writeString_	{ WriteStringPF }
	valRes_		{ ValRes }
	
%%

S : TopStatements {}

TopStatements	:   TopStatement TopStatements {}
TopStatement	:   Definition {}

Statements  :	Statement Statements {}
		| {}
Statement   :	Assignment {}
		| Definition  {}
		| FunctionCall {}
		| return_ Expression1 semicolon_ {}
		| FlowControl {}

Assignment  :	LValue assignOp_ RValue semicolon_ {}

Definition  :	TypeLabel LValue semicolon_ {}
		| TypeLabel Assignment {}
		| FunctionDef {}

FunctionDef :	TypeLabel Label brakOpen_ Arguments brakClose_ cBrakOpen_ Statements cBrakClose_ {}
		| voidLabel_ Label brakOpen_  Arguments brakClose_ cBrakOpen_ Statements cBrakClose_ {}

LValue	    :	Label Arrays {}
		| Pointer Label {}

RValue	:	Expression1 {}
		| Assignment {}
		| ArrayDef {}
		| dereference_ {}

Type	:	int_ {}
		| char_ {}
		| string_ {}
		| double_ {}

TypeLabel   :	intLabel_       {}
		| charLabel_    {}
		| floatLabel_  {}
		| stringLabel_  {}

PredFunction : readInt_ brakOpen_ brakClose_ {}
		| writeInt_ brakOpen_ Parameter brakClose_ {}
		| readFloat_ brakOpen_ brakClose_ {}
		| writeFloat_ brakOpen_ Parameter brakClose_ {}
		| readChar_ brakOpen_ brakClose_ {}
		| writeChar_ brakOpen_ Parameter brakClose_ {}
		| readString_ brakOpen_ brakClose_ {}
		| writeString_ brakOpen_ Parameter brakClose_ {}

FunctionCall :	Label brakOpen_ Parameters brakClose_ semicolon_ {}
		| PredFunction semicolon_ {}

Parameters  :	Parameter ParameterL {}
		| {}
ParameterL  :	comma_ Parameter ParameterL {}
		| {}
Parameter   :	RValue {}

Arguments   :	Argument ArgumentsL {}
		| {}
ArgumentsL  :	comma_ Argument ArgumentsL {}
		| {}
Argument    :	PassingType TypeLabel Label {}
PassingType :	valRes_ {}
		| {}

FlowControl :	IfThenElse {}
		| While {}
		| For {}

FlowStatements :    FlowStatement FlowStatements {}
		    | {}
FlowStatement : break_ semicolon_ {}
		| continue_ semicolon_ {}
		| Statement {}

IfThenElse :	if_ brakOpen_ Expression brakClose_ Then {}
		| if_ brakOpen_ Expression brakClose_ Then Else {}
Then	:	cBrakOpen_ Statements cBrakClose_ {}
Else	:	else_ Then {}
While	:	while_ brakOpen_ Expression brakClose_ cBrakOpen_ FlowStatements cBrakClose_ {}
For	:	for_ brakOpen_ ForInd semicolon_ ForExpression semicolon_ ForExpression brakClose_ cBrakOpen_ FlowStatements cBrakClose_ {}
ForInd	:	ForVars {}
		| {}
ForVars :	ForVar comma_ ForVars {}
		| ForVar {}
ForVar	:	Assignment{}
ForExpression : Expression {}
		| {}

Label	:   label_ {}

Arrays	:   Array Arrays {}
	    | {}
Array	:   sBrakOpen_ int_ sBrakClose_ {}

ArrayDef    :	cBrakOpen_ ArrayItems cBrakClose_ {}
ArrayItems  :	ArrayItem ArrayItemL {}
		| {}
ArrayItemL  :	comma_ ArrayItem ArrayItemL {}
		| {}
ArrayItem   :	RValue {}

Pointer	    :	mulOp_ {}

Expression  :	Expression1 {}
Expression1 :	Expression1 and_ Expression2 {}
		| Expression1 or_ Expression2 {}
		| Expression2 {}
Expression2 :	negOp_ Expression3 {}
		| Expression3 {}
Expression3 :	Expression3 equalsOp_ Expression4 {}
		| Expression3 diffOp_ Expression4 {}
		| Expression3 lessThanOp_ Expression4 {}
		| Expression3 greaterThanOp_ Expression4 {}
		| Expression3 eLessThanOp_ Expression4 {}
		| Expression3 eGreaterThanOp_ Expression4 {}
		| Expression4 {}
Expression4 :	Expression4 addOp_ Expression5 {}
		| Expression4 subOp_ Expression5 {}
		| Expression5 {}
Expression5 :	Expression5 mulOp_ Expression6 {}
		| Expression5 divOp_ Expression6 {}
		| Expression6 {}
Expression6 :	Expression6 incOp_ {}
		| Expression6 decOp_ {}
		| Expression7 {}
Expression7 :	incOp_ Expression7 {}
		| decOp_ Expression7 {}
		| Type {}
		| LValue {}
		| FunctionCall {}
		| brakOpen_ Expression1 brakClose_ {}

{



}
