{

module Main (main) where

import Lexer (alexScanTokens)
import Data (Token(..), Type(..))

}

%name parseCLike
%tokentype { Token }
%error { parseError }

%token
	int_		{ Int $$ _}
	double_	{ Double $$ _}
	char_	{ Char $$ _}
	string_	{ String $$ _}
	label_	{ Label $$ _}
        comment_    { Comment $$ _}
	brakOpen_	{ BrakOpen _}
	brakClose_	{ BrakClose _}
	sBrakOpen_	{ SBrakOpen _}
	sBrakClose_	{ SBrakClose _}
	cBrakOpen_	{ CBrakOpen _}
	cBrakClose_	{ CBrakClose _}
	assignOp_	{ AssignOp _}
	equalsOp_	{ EqualsOp _}
	diffOp_		{ DiffOp _}
	lessThanOp_	{ LessThanOp _}
	greaterThanOp_	{ GreaterThanOp _}
	eLessThanOp_	{ ELessThanOp _}
	eGreaterThanOp_	{ EGreaterThanOp _} 
	addOp_		{ AddOp _}
	subOp_		{ SubOp _}
	mulOp_		{ MulOp	_}
	divOp_		{ DivOp _}
	incOp_		{ IncOp _}
	decOp_		{ DecOp _}
	comma_		{ Comma _}
	semicolon_	{ Semicolon _}
	dereference_	{ Dereference _}
	and_		{ And _}
	or_		{ Or _}
	negOp_		{ NegOp _}
	break_		{ Break _}
	continue_	{ Continue _}
	return_		{ Return _}
	intLabel_	{ IntLabel _}
	floatLabel_	{ FloatLabel _}
	charLabel_	{ CharLabel _}
	stringLabel_	{ StringLabel _}
	voidLabel_	{ VoidLabel _}
	if_		{ If _}
	else_		{ Else _}
	for_		{ For _}
	while_		{ While _}
	readInt_	{ ReadIntPF _}
	writeInt_	{ WriteIntPF _}
	readFloat_	{ WriteFloatPF _}
	writeFloat_	{ WriteFloatPF _}
	readChar_	{ ReadCharPF _}
	writeChar_	{ WriteCharPF _}
	readString_	{ ReadStringPF _}
	writeString_	{ WriteStringPF _}
	valRes_		{ ValRes _}
	
%%

S : TopStatements {}

TopStatements	:   TopStatement TopStatements {}
                    | {}
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
                | comment_ {}

FunctionDef :	TypeLabel Label brakOpen_ Arguments brakClose_ cBrakOpen_ Statements cBrakClose_ {}
		| voidLabel_ Label brakOpen_  Arguments brakClose_ cBrakOpen_ Statements cBrakClose_ {}

LValue	    :	Label Arrays {}
		| Pointer Label {}

RValue	:	Expression1 {}
		| Assignment {}
		| ArrayDef {}
		| dereference_ label_ {}

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
            | sBrakOpen_ sBrakClose_ {}

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

main = do
    s <- getContents
    let tok = alexScanTokens s
    print (parseCLike tok)
    print tok

--main = getContents >>= print . parseCLike . alexScanTokens

parseError :: [Token] -> a
parseError (tok:_) = error ("Parse error: " ++ show tok ++ " at invalid postion")
parseError [] = error "casini!"
parseError _ = error "OhOh!"

getTokPos :: Token -> (Int, Int)
getTokPos x = case x of
   		(Int _ p) -> p
                (Double _ p) -> p
                (Char _ p) -> p
                (String _ p) -> p
                (Label _ p) -> p
                (BrakOpen p)-> p
                (BrakClose p) -> p
                (SBrakOpen p) -> p
                (SBrakClose p) -> p
                (CBrakOpen p) -> p
                (CBrakClose p) -> p
                (AssignOp p) -> p
                (EqualsOp p) -> p
                (DiffOp p) -> p
                (LessThanOp p) -> p
                (GreaterThanOp p) -> p
                (ELessThanOp p) -> p
                (EGreaterThanOp p) -> p
                (AddOp p) -> p
                (SubOp p) -> p
                (MulOp p) -> p
                (DivOp p) -> p
                (IncOp p) -> p
                (DecOp p) -> p
                (Comma p) -> p
                (Semicolon p) -> p
                (Dereference p) -> p
                (And p) -> p
                (Or p) -> p
                (NegOp p) -> p
                (Break p) -> p
                (Continue p) -> p
		(Return p) -> p
                (IntLabel p) -> p
                (FloatLabel p) -> p
                (CharLabel p) -> p
                (StringLabel p) -> p
                (VoidLabel p) -> p
                (ReadIntPF p) -> p
                (WriteIntPF p) -> p
                (ReadFloatPF p) -> p
                (WriteFloatPF p) -> p
                (ReadCharPF p) -> p
                (WriteCharPF p) -> p
                (ReadStringPF p) -> p
                (WriteStringPF p) -> p
                (ValRes p) -> p
                (If p) -> p
                (Else p) -> p
                (While p) -> p
                (For p) -> p
 

}
