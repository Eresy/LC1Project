{

module Main (main) where

import Lexer (alexScanTokens)
import Data 
import AST

}

%name parseChapel
%tokentype { Token }
%error { parseError }

%token
	
	scomment_		{ SComment $$}
	mcomment_		{ MComment $$}
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
	nequals_		{ OP_NEqual $$ }
	lessthan_		{ OP_LesThn $$ }
	lessthaneq_		{ OP_LesThnEq $$ }
	greatthan_		{ OP_GrtThn $$ }
	greatthaneq_		{ OP_GrtThnEq $$ }
	add_			{ OP_Add $$ }
	sub_			{ OP_Sub $$ }
	mul_			{ OP_Mul $$ }
	div_			{ OP_Div $$ }
	addassign_		{ OP_AddAssign $$ }
	subassign_		{ OP_SubAssign $$ }
	mulassign_		{ OP_MulAssign $$ }
	divassign_		{ OP_DivAssign $$ } 
	deref_			{ OP_Deref $$ }
	and_			{ OP_And $$ }
	or_			{ OP_Or $$ }
	neg_			{ OP_Negt $$ }
	comma_			{ Comma $$ }
	semic_			{ Semicolon $$ }
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
		|	Assignment semic_	{ }
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
		|	return_ NamedAssignment semic_	{ }
		|	Comment				{ }

Comment		:	scomment_ 			{ }
	 	|	mcomment_			{ }

BlockStatement	:	bkcOpen_ ListStatement bkcClose_		{ }

FunctionCall	:	Label ParameterA				{ }
		|	readInt_ bknOpen_ bknClose_			{ }
		|	writeInt_ bknOpen_ Expression bknClose_		{ }
		|	readReal_ bknOpen_ bknClose_			{ }
		|	writeReal_ bknOpen_ Expression bknClose_	{ }
		|	readChar_ bknOpen_ bknClose_			{ }
		|	writeChar_ bknOpen_ Expression bknClose_	{ }
		|	readString_ bknOpen_ bknClose_			{ }
		|	writeString_ bknOpen_ Expression bknClose_	{ }

FuncDeclaration	:	proc_ Label ParameterFDecl Cast BlockStatement 	{ }
		|	proc_ Label ParameterFDecl BlockStatement 	{ }
		|	proc_ Label Cast BlockStatement 		{ }
		|	proc_ Label BlockStatement 			{ }

ParameterFDecl	:	bknOpen_ ListParameterF bknClose_ 	{ }
ParameterF	:	Mode Label Cast 			{ }
ListParameterF	:	ParameterF ListParameterFC		{ }
	        |						{ }
ListParameterFC	:	comma_ ParameterF ListParameterFC	{ }
		|						{ }

ParameterA	:	bknOpen_ ListExpression bknClose_ 	{ }
ListExpression	:	Expression ListExpressionC 		{ }
	        |						{ }
ListExpressionC :	comma_ Expression ListExpressionC	{ }
		|						{ }

Mode		:	value_ 		{ }
		|	reference_	{ }
		|	constant_ 	{ }
 		|			{ }

Declaration	:	var_ ListPointer Label Cast	{ }

Assignment	:	NamedAssignment 				{ }
		|	var_ ListPointer Label assign_ RValue		{ }
		|	Declaration assign_ RValue 			{ }

NamedAssignment	:	LValue AssignOps RValue 	{ }

AssignOps	:	assign_		{ }
	 	|	addassign_	{ }
		|	subassign_	{ }
		|	mulassign_	{ }
		|	divassign_	{ }

Range		:	Expression range_ Expression	{ }
		|	Expression range_ 		{ }
		|	range_ Expression 		{ }
		|	range_ 				{ }

Cast		:	cast_ TypeSpec 				{ }
		|	cast_ MultiDimRange TypeSpec 		{ }
MultiDimRange	:	bksOpen_ Range MoreRange bksClose_	{ }
MoreRange	:	comma_ Range MoreRange			{ }
	  	|						{ }


Pointer		:	mul_ 				{ }
ListPointer	:	Pointer ListPointer		{ }
		|					{ }

LValue		:	Label ListArrayIndex 	{ }
		|	Label			{ }

RValue		:	Expression	{ }
		|	NamedAssignment	{ }

ArrayIndex	:	bksOpen_ Expression bksClose_ 	{ }
ListArrayIndex	:	ArrayIndex ListArrayIndex	{ }
		|	ArrayIndex			{ }

ArrayElement	:	bknOpen_ ListValue bknClose_	{ }
ListValue	:	Value comma_ Value ListValueC		{ }
ListValueC	:	comma_ Value ListValueC		{ }
		|					{ }

WhileDo		:	while_ Expression BlockStatement { }
DoWhile		:	do_ BlockStatement while_ Expression semic_ { }

If		:	if_ Expression BlockStatement 				{ } 
		|	if_ Expression BlockStatement else_ BlockStatement	{ } 
		|	if_ Expression then_ Statement				{ }

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
		|	Expression3 nequals_ Expression4	{ }
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
Expression5	:	sub_ Expression6		{ }
	    	|	add_ Expression6		{ }
		|	Expression6			{ }
Expression6	:	mul_ Expression7 		{ } 
		|	deref_ Expression7		{ }
		|	Expression7			{ }
Expression7	:	Value 				{ }
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
    print tok
    print $ parseChapel tok

parseError (tok:toks) = error ("Parser Error:" ++ show tok ++ " at invalid position.")


}
