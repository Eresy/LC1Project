{

module Main (main) where

import Lexer (alexScanTokens)
import Data (Token(..), Type(..), TypeResult(..))

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

S : TopStatements { $1 }

TopStatements	:   TopStatement TopStatements { isCorrect $1 $2 }
                    | { TypeNull }
TopStatement	:   Definition { $1 }

Statements  :	Statement Statements { isCorrect $1 $2 }
		| { TypeNull }
Statement   :	Assignment { $1 }
		| Definition  { $1 }
		| FunctionCall { $1 }
		| return_ Expression semicolon_ { $2 }
		| FlowControl { $1 }

Assignment  :	LValue assignOp_ RValue semicolon_ { typeCompare $1 $3 }

Definition  :	TypeLabel LValue semicolon_ { typeCompare $1 $2 } 
		| TypeLabel Assignment { typeCompare $1 $2 }
		| FunctionDef { $1 }
                | comment_ { TypeNull }

FunctionDef :	TypeLabel Label brakOpen_ Arguments brakClose_ cBrakOpen_ Statements cBrakClose_ { typeCompare $1 $1 } --da cambiare
		| voidLabel_ Label brakOpen_  Arguments brakClose_ cBrakOpen_ Statements cBrakClose_ { infer VoidType }

LValue	    :	Label Arrays { TypeNull } --da cambiare
		| Pointer Label { TypeNull } --da cambiare

RValue	:	Expression { $1 }
		| Assignment { $1 }
		| ArrayDef { $1 }
		| dereference_ label_ { infer IntType }

Type	:	int_ { infer (IntType) }
		| char_ { infer (CharType) }
		| string_ { infer (StringType) }
		| double_ { infer (DoubleType) }

TypeLabel   :	intLabel_       { infer (IntType) }
		| charLabel_    { infer (CharType) }
		| floatLabel_   { infer (DoubleType) }
		| stringLabel_  { infer (StringType) }

PredFunction :  readInt_ brakOpen_ brakClose_ { infer (IntType) }
		| writeInt_ brakOpen_ Parameter brakClose_ { typeCompare (infer IntType) $3 }
		| readFloat_ brakOpen_ brakClose_ { (infer DoubleType) }
		| writeFloat_ brakOpen_ Parameter brakClose_ { typeCompare (infer DoubleType) $3 }
		| readChar_ brakOpen_ brakClose_ { (infer CharType)  }
		| writeChar_ brakOpen_ Parameter brakClose_ { typeCompare (infer CharType) $3 }
		| readString_ brakOpen_ brakClose_ { (infer StringType) }
		| writeString_ brakOpen_ Parameter brakClose_ { typeCompare (infer StringType) $3 }

FunctionCall :	Label brakOpen_ Parameters brakClose_ semicolon_ {TypeNull}
		| PredFunction semicolon_ { $1 }

Parameters  :	Parameter ParameterL { isCorrect $1 $2 }
		| { TypeNull }
ParameterL  :	comma_ Parameter ParameterL { isCorrect $2 $3 }
		| {TypeNull }
Parameter   :	RValue { $1 }

Arguments   :	Argument ArgumentsL { isCorrect $1 $2}
		| { TypeNull }
ArgumentsL  :	comma_ Argument ArgumentsL { isCorrect $2 $3 }
		| { TypeNull }
Argument    :	PassingType TypeLabel Label { $2 }
PassingType :	valRes_ {}
		| {}

FlowControl :	IfThenElse { $1 }
		| While { $1 }
		| For { $1 }

FlowStatements :    FlowStatement FlowStatements { isCorrect $1 $2}
		    | { TypeNull}
FlowStatement : break_ semicolon_ { TypeNull }
		| continue_ semicolon_ { TypeNull}
		| Statement { $1 }

IfThenElse :	if_ brakOpen_ Expression brakClose_ Then { isCorrect $3 $5 }
		| if_ brakOpen_ Expression brakClose_ Then Else { isCorrect $3 (isCorrect $5 $6)}
Then	:	cBrakOpen_ Statements cBrakClose_ { $2 }
Else	:	else_ Then { $2 }
While	:	while_ brakOpen_ Expression brakClose_ cBrakOpen_ FlowStatements cBrakClose_ { isCorrect $3 $6 }
                | while_ brakOpen_ Expression brakClose_ Statement { isCorrect $3 $5 }
For	:	for_ brakOpen_ ForInd semicolon_ ForExpression semicolon_ ForExpression brakClose_ cBrakOpen_ FlowStatements cBrakClose_ {isCorrect $3 (isCorrect $5 (isCorrect $7 $10))}
                | for_ brakOpen_ ForInd semicolon_ ForExpression semicolon_ ForExpression brakClose_ {isCorrect $3 (isCorrect $5 $7) }
ForInd	:	ForVars { $1 }
		| { TypeNull }
ForVars :	ForVar comma_ ForVars { isCorrect $1 $3 }
		| ForVar { TypeNull}
ForVar	:	LValue assignOp_ RValue { typeCompare $1 $3 }
ForExpression : Expression { $1 }
		| { TypeNull }

Label	:   label_ { TypeNull }

Arrays	:   Array Arrays { TypeNull }
	    | { TypeNull }
Array	:   sBrakOpen_ int_ sBrakClose_ { TypeNull}
            | sBrakOpen_ sBrakClose_ { TypeNull }

ArrayDef    :	cBrakOpen_ ArrayItems cBrakClose_ { $2 }
ArrayItems  :	ArrayItem ArrayItemL { typeCompare $1 $2 }
		| { TypeNull }
ArrayItemL  :	comma_ ArrayItem ArrayItemL { typeCompare $2 $3 }
		| { TypeNull }
ArrayItem   :	RValue { $1 }

Pointers    :   Pointer Pointers { TypeNull}
                | { TypeNull }
Pointer	    :	mulOp_ {TypeNull}

Expression  :	Expression1 { $1 }
Expression1 :	Expression1 and_ Expression2 { typeCompare $1 $3  }
		| Expression1 or_ Expression2 { typeCompare $1 $3}
		| Expression2 { $1 }
Expression2 :	negOp_ Expression3 { $2 }
		| Expression3 { $1 }
Expression3 :	Expression3 equalsOp_ Expression4 { typeCompare $1 $3 }
		| Expression3 diffOp_ Expression4 { typeCompare $1 $3 }
		| Expression3 lessThanOp_ Expression4 { typeCompare $1 $3 }
		| Expression3 greaterThanOp_ Expression4{ typeCompare $1 $3 }
		| Expression3 eLessThanOp_ Expression4 { typeCompare $1 $3 }
		| Expression3 eGreaterThanOp_ Expression4 { typeCompare $1 $3 }
		| Expression4 { $1 }
Expression4 :	Expression4 addOp_ Expression5 {typeCompare $1 $3}
		| Expression4 subOp_ Expression5 {typeCompare $1 $3}
		| Expression5 { $1 }
Expression5 :	Expression5 mulOp_ Expression6 { typeCompare $1 $3 }
		| Expression5 divOp_ Expression6 { typeCompare $1 $3 }
		| Expression6 { $1 }
Expression6 :	Expression6 incOp_ { $1 }
		| Expression6 decOp_ { $1 }
		| Expression7 { $1 }
Expression7 :	incOp_ Expression7 { $2 }
		| decOp_ Expression7 { $2 }
		| Type {$1}
		| LValue {$1}
		| FunctionCall {$1}
		| brakOpen_ Expression1 brakClose_ {$2}

{

main = do
    s <- getContents
    let tok = alexScanTokens s
    print (parseCLike tok)
    print tok

--main = getContents >>= print . parseCLike . alexScanTokens

parseError :: [Token] -> a
parseError (tok:toks) = error ("Parse error: " ++ show tok ++ " at invalid postion.\n\nStack Trace:\n "++ show toks ++ "\n")
parseError [] = error "casini!"
parseError _ = error "OhOh!"

--isCorrect :: TypeResult -> TypeResult -> TypeResult
isCorrect x@(TypeCorrect a) (TypeCorrect b) = x
isCorrect x@(TypeError _ _) _ = x
isCorrect _ x@(TypeError _ _) = x
isCorrect TypeNull x = x
isCorrect x TypeNull = x
isCorrect TypeNull TypeNull = TypeNull

--typeCompare :: TypeResult -> TypeResult -> TypeResult
typeCompare (TypeCorrect a) (TypeCorrect b) = comparez a b
typeCompare x@(TypeError _ _) _ = x
typeCompare _ x@(TypeError _ _) = x
typeCompare TypeNull x = x
typeCompare x TypeNull = x
typeCompare TypeNull TypeNull = TypeNull

comparez :: Type -> Type -> TypeResult
comparez a b = comp (a == b) where
    comp True = (TypeCorrect a)
    comp False = (TypeError a b)

infer x = (TypeCorrect x)

--typeInfer :: Token -> Type
--typeInfer x = case x of
--   		(Int _ _) -> IntType 
--                (Double _ p) -> DoubleType
--                (Char _ p) -> CharType
--                (String _ p) -> StringType
--                (Label _ p) -> NullType
--                (BrakOpen p)-> NullType
--                (BrakClose p) -> NullType
--                (SBrakOpen p) -> NullType
--                (SBrakClose p) -> NullType
--                (CBrakOpen p) -> NullType
--                (CBrakClose p) -> NullType
--                (AssignOp p) -> NullType
--                (EqualsOp p) -> NullType
--                (DiffOp p) -> NullType
--                (LessThanOp p) -> NullType
--                (GreaterThanOp p) -> NullType
--                (ELessThanOp p) -> NullType
--                (EGreaterThanOp p) -> NullType
--                (AddOp p) -> NullType
--                (SubOp p) -> NullType
--                (MulOp p) -> NullType
--                (DivOp p) -> NullType
--                (IncOp p) -> NullType
--                (DecOp p) -> NullType
--                (Comma p) -> NullType
--                (Semicolon p) -> NullType
--                (Dereference p) -> NullType
--                (And p) -> NullType
--                (Or p) -> NullType
--                (NegOp p) -> NullType
--                (Break p) -> NullType
--                (Continue p) -> NullType
--		(Return p) -> NullType
--                (IntLabel p) -> NullType
--                (FloatLabel p) -> NullType
--                (CharLabel p) -> NullType
--                (StringLabel p) -> NullType
--                (VoidLabel p) -> NullType
--                (ReadIntPF p) -> NullType
--                (WriteIntPF p) -> NullType
--                (ReadFloatPF p) -> NullType
--                (WriteFloatPF p) -> NullType
--                (ReadCharPF p) -> NullType
--                (WriteCharPF p) -> NullType
--                (ReadStringPF p) -> NullType
--                (WriteStringPF p) -> NullType
--                (ValRes p) -> NullType
--                (If p) -> NullType
--                (Else p) -> NullType
--                (While p) -> NullType
--                (For p) -> NullType
 

}
