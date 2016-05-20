{

module Main (main) where

import Lexer (alexScanTokens)
import Data (Token(..))

}

%name parseChapel
%tokentype { Token }
%error { parseError }

%token
	
	comment_		{ Comment $$}
	int_			{ Int $$ }
	real_			{ Real $$ }
	char_			{ Char $$ }
	string_			{ String $$ }
	label_			{ Label $$ }
	typeInt_		{ TS_Int $$ }
	typeReal_		{ TS_Real $$ }
	typeChar_		{ TS_Char $$ }
	typeString_		{ TS_String $$ }
	typeVoid_		{ TS_Void $$ }
	typeBool_		{ TS_Bool $$ }
	value_			{ PM_Value $$ }
	reference_		{ PM_Reference $$ }
	constant_		{ PM_Constant $$ }
	if_			{ If $$ }
	then_			{ Then $$  }
	else_			{ Else $$ }
	for_			{ For $$ }
	in_			{ In $$ }
	while_			{ While $$}
	do_			{ Do $$ }
	break_			{ Break $$ }
	continue_		{ Continue $$ }
	return_			{ Return $$ }
	try_			{ Try $$ }
	catch_			{ Catch $$ }
	readInt_		{ PF_readInt $$ }
	writeInt_		{ PF_writeInt $$ }
	readReal_		{ PF_readReal $$ }
	writeReal_		{ PF_writeReal $$ }
	readChar_		{ PF_readChar $$ }
	writeChar_		{ PF_writeChar $$ }
	readString_		{ PF_readString $$ }
	writeString_		{ PF_writeString $$ }
	bknOpen_		{ BK_NOpen $$ }
	bknClose_		{ BK_NClos $$ }
	bksOpen_		{ BK_SOpen $$ }
	bksClose_		{ BK_SClos $$ }
	bkcOpen_		{ BK_COpen $$ }
	bkcClose_		{ BK_CClos $$ }
	assign_			{ OP_Assign $$ }
	equals_			{ OP_Equal $$ }
	nequal_			{ OP_NEqual $$ }
	lessthan_		{ OP_LesThn $$ }
	lessthaneq_		{ OP_LesThnEq $$ }
	greatthan_		{ OP_GrtThn $$ }
	greatthaneq_		{ OP_GrtThnEq $$ }
	add_			{ OP_Add $$ }
	sub_			{ OP_Sub $$ }
	mul_			{ OP_Mul $$ }
	div_			{ OP_Div $$ }
	inc_			{ OP_Incr $$ }
	dec_			{ OP_Decr $$ }
	deref_			{ OP_Deref $$ }
	and_			{ OP_And $$ }
	or_			{ OP_Or $$ }
	neg_			{ OP_Negt $$ }
	comma_			{ OP_Comma $$ }
	semic_			{ OP_Semicolon $$ }
	var_			{ CHP_Var $$ }
	proc_			{ CHP_Func $$ }
	cast_			{ CHP_Cast $$ }
	range_			{ CHP_Range $$ } 
	true_			{ TSB_True $$ }
	false_			{ TSB_False $$ }
%%


S		:	Program			{ }

Program		:	ListStatement		{ }

ListStatement	:	ListStatement Statement { }
		|				{ }

Statement	:	BlockStatement		{ }
		|	Expression semic_	{ }
		|	Assignment		{ }
		|	Declaration semic_	{ }
		|	FuncDeclaration		{ }
		|	WhileDo			{ }
		|	DoWhile			{ }
		|	If			{ }
		|	For			{ }
		|	TryCatch		{ }
		|	break_ semic_		{ }
		|	continue_ semic_		{ }
		|	return_ Expression semic_	{ }

BlockStatement	:	bkcOpen_ ListStatement bkcClose_		{ }

FunctionCall	:	Label ParameterA		{ }

FuncDeclaration	:	proc_ Label ParameterFDecl Cast BlockStatement 	{ }
		|	proc_ Label ParameterFDecl BlockStatement 	{ }
		|	proc_ Label Cast BlockStatement 		{ }
		|	proc_ Label BlockStatement 			{ }

ParameterFDecl	:	bknOpen_ ListParameterF bknClose_ 	{ }
ParameterF	:	Mode Label Cast 			{ }
ListParameterF	:	ListParameterF ParameterF			{ }
		|						{ }

ParameterA	:	bknOpen_ ListExpression bknClose_ 	{ }
ListExpression	:	Expression ListExpressionC 		{ }
ListExpressionC :	comma_ Expression ListExpressionC	{ }
		|						{ }

Mode		:	value_ 		{ }
		|	reference_	{ }
		|	constant_ 	{ }
 		|			{ }

Declaration	:	var_ ListPointer Label Cast	{ }

Assignment	:	Label equals_ RValue semic_			{ }
		|	var_ ListPointer Label equals_ RValue semic_	{ }
		|	Declaration equals_ RValue semic_		{ }

Range		:	Expression range_ Expression	{ }
		|	Expression range_ 		{ }
		|	range_ Expression 		{ }
		|	range_ 				{ }

Cast		:	cast_ TypeSpec { }
		|	cast_ bksOpen_ Range bksClose_ TypeSpec { }

Pointer		:	mul_ { }
ListPointer	:	ListPointer Pointer		{ }
		|					{ }

LValue		:	Label ListArrayIndex { }

RValue		:	Expression { }

ArrayIndex	:	bksOpen_ Expression bksClose_ 	{ }
ListArrayIndex	:	ArrayIndex ListArrayIndex{ }
		|					{ }

ArrayElement	:	bknOpen_ ListValue bknClose_	{ }
ListValue	:	Value ListValueC		{ }
ListValueC	:	comma_ Value ListValueC		{ }
		|					{ }

WhileDo		:	while_ Expression BlockStatement { }
DoWhile		:	do_ BlockStatement while_ Expression semic_ { }

If		:	if_ Expression BlockStatement { } 
		|	if_ Expression BlockStatement else_ BlockStatement	{ } 

For		:	for_ Label in_ Range BlockStatement 	{ }
		|	for_ Label in_ Range do_ Statement 	{ }

TryCatch	:	try_ Statement catch_ Statement { }

Expression	:	Expression1				{ }
Expression1	:	Expression1 and_ Expression2 		{ }
		|	Expression1 or_ Expression2 		{ }
		|	Expression2				{ }
Expression2	:	neg_ Expression3 			{ }
	    	|	Expression3				{ }
Expression3	:	Expression3 equals_ Expression4 	{ }
		|	Expression3 lessthan_ Expression4 	{ }
		|	Expression3 greatthan_ Expression4 	{ }
		|	Expression3 lessthaneq_ Expression4 	{ }
		|	Expression3 greatthaneq_ Expression4 	{ }
		|	Expression4				{ }
Expression4	:	Expression4 add_ Expression5 	{ }
		|	Expression4 sub_ Expression5 	{ }
		|	Expression4 mul_ Expression5 	{ }
		|	Expression4 div_ Expression5 	{ }
		|	Expression5			{ }
Expression5	:	mul_ Expression6 		{ } 
		|	deref_ Expression6		{ }
		|	Expression6			{ }
Expression6	:	Value 				{ }
		|	bknOpen_ Expression1 bknClose_	{ }

Value		:	LValue		{ }
		|	Literal 	{ }
		|	FunctionCall 	{ }
       
Label		:	label_		{ }

TypeSpec	:	typeInt_	{ }
		|	typeReal_	{ }
		|	typeBool_	{ }
		|	typeString_	{ }
		|	typeChar_	{ }
		|	typeVoid_	{ }

Literal		:	int_ 		{ }
		|	real_ 		{ }
		|	char_ 		{ }
		|	string_ 	{ }
		|	ArrayElement 	{ }
		|	true_		{ }
		|	false_		{ }
{

main = do
    s <- getContents
    let tok = alexScanTokens s
    print $ parseChapel tok
    print tok

parseError :: [Token] -> a
parseError (tok:toks) = error ("Parse error: " ++ show tok ++ " at invalid postion.\n\nStack Trace:\n "++ show toks ++ "\n")
parseError [] = error "casini!"
parseError _ = error "OhOh!"
{-
isCorrect :: TypeResult -> TypeResult -> TypeResult
isCorrect x@(Correct a) (Correct b) = x
isCorrect (Correct _) x@(ReturnT _) = x
isCorrect x@(ReturnT _) (Correct _) = x
isCorrect x@(Error _ _) _ = error ("Type error!")
isCorrect _ x@(Error _ _) = error ("Type error!")
isCorrect Null x = x
isCorrect x Null = x
isCorrect Null Null = Null

instance Monad TypeResult where
	TypeResult a >>= f = f a
	return a = (Correct a)
	fail str = 
	catch a f = case a of
		(Correct a) -> (Correct a)
		(Error a b) -> f a

typeCompare :: TypeResult -> TypeResult -> TypeResult
typeCompare (Correct a) (Correct b) = tCompare a b
typeCompare (ReturnT a) (Correct b) = tCompare a b
typeCompare (Correct a) (ReturnT b)= tCompare a b
typeCompare x@(Error _ _) _ = x
typeCompare _ x@(Error _ _) = x
typeCompare Null x = x
typeCompare x Null = x
typeCompare Null Null = Null

tCompare :: Type -> Type -> TypeResult
tCompare a b = comp (a == b) where
    comp True = (Correct a)
    comp False = Error a b

infer x = (Correct x)
ret x = (ReturnT x)
-}
}
