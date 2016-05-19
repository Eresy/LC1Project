{

module Main (main) where

import Lexer (alexScanTokens)
import Data (Token(..), Type(..), TypeResult(..))

}

%name parseCLike
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
	typeVoid_		{TS_Void $$ }
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
%%


S		:	Program			{ }
Program		:	ListStatement		{ }

ListStatement	:	ListStatement Statement { }
		|				{ }

Statement	:	BlockStatement		{ }
		|	Expression ";"		{ }
		|	Assignment		{ }
		|	Declaration ";"		{ }
		|	FuncDeclaration		{ }
		|	WhileDo			{ }
		|	DoWhile			{ }
		|	For			{ }
		|	If			{ }
		|	TryCatch		{ }
		|	"break" ";"		{ }
		|	"continue" ";"		{ }
		|	"return" Expression ";"	{ }

BlockStatement	:	"{" ListStatement "}"		{ }

FunctionCall	:	Label ParameterList		{ }

FuncDeclaration	:	"proc" Label ParameterDecl Cast BlockStatement 	{ }
FuncDeclaration	:	"proc" Label ParameterDecl BlockStatement 	{ }
FuncDeclaration	:	"proc" Label Cast BlockStatement 		{ }
FuncDeclaration	:	"proc" Label BlockStatement 			{ }

ParameterDecl	:	"(" [Parameter] ")" 				{ }
Parameter	:	Mode Label Cast 				{ }
"," { }
.	ParameterList	:	"(" [Expression] ")" 			{ }
"," { }

Mode		:	"val" 		{ }
Mode		:	"ref" 		{ }
Mode		:	"const" 	{ }
Mode		:	 		{ }

Declaration	:	"var" [Pointer] Label Cast { }

Assignment	:	Label "=" RValue " { }" { }
Assignment	:	"var" [Pointer] Label "=" RValue " { }" { }
Assignment	:	Declaration "=" RValue " { }" { }

Range		:	Expression ".." Expression { }
Range		:	Expression ".." { }
Range		:	 ".." Expression { }
Range		:	 ".." { }

Cast		:	":" TypeSpec { }
Cast		:	":" "[" Range "]" TypeSpec { }

Pointer		:	"*" { }
"" { }

LValue		:	Label { }
LValue		:	Label [ArrayIndex] { }

RValue		:	Expression { }

ArrayIndex	:	"[" Expression "]" { }
ArrayIndex "" { }
ArrayElement	:	"(" [LiteralList] ")" { }

LiteralList	:	Value { }
LiteralList "," { }

WhileDo		:	"while" Expression BlockStatement { }
DoWhile		:	"do" BlockStatement "while" Expression " { }" { }

If		:	"if" Expression BlockStatement { } 
If		:	"if" Expression BlockStatement "else" BlockStatement	{ } 

For		:	"for" Label "in" Range BlockStatement { }
For		:	"for" Label "in" Range "do" Statement { }

TryCatch	:	"try" Statement "catch" Statement { }

Expression1	:	Expression1 "&&" Expression2 { }
Expression1	:	Expression1 "||" Expression2 { }
Expression2	:	"!" Expression3 { }
Expression3	:	Expression3 "==" Expression4 { }
Expression3	:	Expression3 "<" Expression4 { }
Expression3	:	Expression3 ">" Expression4 { }
Expression3	:	Expression3 "<=" Expression4 { }
Expression3	:	Expression3 ">=" Expression4 { }
Expression4	:	Expression4 "+" Expression5 { }
Expression4	:	Expression4 "-" Expression5 { }
Expression4	:	Expression4 "*" Expression5 { }
Expression4	:	Expression4 "/" Expression5 { }
Expression5	:	"++" Expression6 { }
Expression5	:	"--" Expression6 { }
Expression5	:	Expression6 "++" { }
Expression5	:	Expression6 "--" { }
Expression5	:	"*" Expression6 { } 
Expression5	:	"&" Expression6 { }
Expression6	:	Value { }
Expression 6 { }

Value		:	LValue { }
Value		:	Literal { }
Value		:	FunctionCall { }
       
Label		:	Ident { }
TypeSpec	:	"int" { }
TypeSpec	:	"real" { }
TypeSpec	:	"bool" { }
TypeSpec	:	"string" { }
TypeSpec	:	"char" { }
TypeSpec	:	"void" { }
Literal		:	Integer { }
Literal		:	Double { }
Literal		:	Char { }
Literal		:	String { }
Literal		:	ArrayElement { }

{

main = do
    s <- getContents
    let tok = alexScanTokens s
    print $ parseCLike tok
    print tok

--main = getContents >>= print . parseCLike . alexScanTokens

parseError :: [Token] -> a
parseError (tok:toks) = error ("Parse error: " ++ show tok ++ " at invalid postion.\n\nStack Trace:\n "++ show toks ++ "\n")
parseError [] = error "casini!"
parseError _ = error "OhOh!"

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

}
