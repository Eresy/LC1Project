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
	ref_			{ OP_Ref $$ }
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


S		:	Program			{ $1  }

Program		:	ListStatement		{ Program $1 }

ListStatement	:	Statement ListStatement { $1 : $2 }
		|				{ [] }

Statement	:	BlockStatement		{ Stmt1 $1 }
		|	Expression semic_	{ Stmt2 $1 }
		|	Assignment semic_	{ Stmt3 $1 }
		|	Declaration semic_	{ Stmt4 $1 }
		|	FuncDeclaration		{ Stmt5 $1 }
		|	WhileDo			{ Stmt6 $1 }
		|	DoWhile			{ Stmt7 $1 }
		|	If			{ Stmt8 $1 }
		|	For			{ Stmt9 $1 }
		|	TryCatch		{ Stmt10 $1 }
		|	break_ semic_		{ Stmt11 Brk }
		|	continue_ semic_		{ Stmt11 Cont }
		|	return_ Expression semic_	{ Stmt12 (Ret1 $2) }
		|	return_ NamedAssignment semic_	{ Stmt12 (Ret2 $2) }
		|	Comment				{ Stmt13 $1 }

Comment		:	scomment_ 			{ SCmt (fst $1) }
	 	|	mcomment_			{ MCmt (fst $1) }

BlockStatement	:	bkcOpen_ ListStatement bkcClose_		{ Blk $2 }

FunctionCall	:	Label ParameterA				{ FCall $1 $2 }
		|	readInt_ bknOpen_ bknClose_			{ ReadInt $1 }
		|	writeInt_ bknOpen_ Expression bknClose_		{ WriteInt $3 $1 }
		|	readReal_ bknOpen_ bknClose_			{ ReadReal $1 }
		|	writeReal_ bknOpen_ Expression bknClose_	{ WriteReal $3 $1 }
		|	readChar_ bknOpen_ bknClose_			{ ReadChar $1 }
		|	writeChar_ bknOpen_ Expression bknClose_	{ WriteChar $3 $1 }
		|	readString_ bknOpen_ bknClose_			{ ReadString $1 }
		|	writeString_ bknOpen_ Expression bknClose_	{ WriteString $3 $1 }

FuncDeclaration	:	proc_ Label ParameterFDecl Cast BlockStatement 	{ FullDecl $2 $3 $4 $5 }
		|	proc_ Label ParameterFDecl BlockStatement 	{ NoCastDecl $2 $3 $4 }
		|	proc_ Label Cast BlockStatement 		{ NoParamDecl $2 $3 $4 }
		|	proc_ Label BlockStatement 			{ NakedDecl $2 $3 }

ParameterFDecl	:	bknOpen_ ListParameterF bknClose_ 	{ $2 }
ParameterF	:	Mode Label Cast 			{ FParam $1 $2 $3 }
ListParameterF	:	ParameterF ListParameterFC		{ $1 : $2 }
	        |						{ [] }
ListParameterFC	:	comma_ ParameterF ListParameterFC	{ $2 : $3 }
		|						{ [] }

ParameterA	:	bknOpen_ ListExpression bknClose_ 	{ $2 }
ListExpression	:	Expression ListExpressionC 		{ $1 : $2 }
	        |						{ [] }
ListExpressionC :	comma_ Expression ListExpressionC	{ $2 : $3 }
		|						{ [] }

Mode		:	value_ 		{ Val }
		|	reference_	{ Ref }
		|	constant_ 	{ Con }
 		|			{ Uns }

Declaration	:	var_ ListPointer Label Cast	{ SimpleDecl $2 $3 $4 }

Assignment	:	NamedAssignment 				{ SimpleAssign $1 }
		|	var_ ListPointer Label assign_ RValue		{ GenericAssign $2 $3 $5 }
		|	Declaration assign_ RValue 			{ DeclAssign $1 $3 }

NamedAssignment	:	LValue AssignOps RValue 	{ Ass $1 $2 $3 }

AssignOps	:	assign_		{ Assign }
	 	|	addassign_	{ AddAssign }
		|	subassign_	{ SubAssign }
		|	mulassign_	{ MulAssign }
		|	divassign_	{ DivAssign }

Range		:	Expression range_ Expression	{ CRange $1 $3 }
		|	Expression range_ 		{ NURange $1 }
		|	range_ Expression 		{ NLRange $2 }
		|	range_ 				{ ULRange }

Cast		:	cast_ TypeSpec 				{ SCast $2 }
		|	cast_ MultiDimRange TypeSpec 		{ MCast $2 $3 }
MultiDimRange	:	bksOpen_ Range MoreRange bksClose_	{ $2 : $3 }
MoreRange	:	comma_ Range MoreRange			{ $2 : $3}
	  	|						{ [] }


Pointer		:	mul_ 				{ Ptr }
ListPointer	:	Pointer ListPointer		{ $1 : $2 }
		|					{ [] }

LValue		:	Label ListArrayIndex 	{ ArrayLV $1 $2 }
		|	Label			{ LV $1 }

RValue		:	Expression	{ SimpleRV $1 }
		|	NamedAssignment	{ ComplexRV $1 }

ArrayIndex	:	bksOpen_ Expression bksClose_ 	{ $2 }
ListArrayIndex	:	ArrayIndex ListArrayIndex	{ $1 : $2 }
		|	ArrayIndex			{ $1 : [] }

ArrayElement	:	bknOpen_ ListValue bknClose_	{ $2 }
ListValue	:	Value comma_ Value ListValueC	{ $1 : $3 : $4 }
ListValueC	:	comma_ Value ListValueC		{ $2 : $3}
		|					{ [] }

WhileDo		:	while_ Expression BlockStatement { WD $2 $3 }
DoWhile		:	do_ BlockStatement while_ Expression semic_ { DW $2 $4 }

If		:	if_ Expression BlockStatement 				{ IfBlock $2 $3 } 
		|	if_ Expression BlockStatement else_ BlockStatement	{ IfElseBlock $2 $3 $5} 
		|	if_ Expression then_ Statement				{ OneLineIf $2 $4}

For		:	for_ Label in_ Range BlockStatement 	{ ForBlk $2 $4 $5 }
		|	for_ Label in_ Range do_ Statement 	{ ForSmp $2 $4 $6 }

TryCatch	:	try_ Statement catch_ Statement { TrCh $2 $4 }

Expression	:	Expression1				{ $1 }
Expression1	:	Expression1 and_ Expression2 		{ AndExp $1 $3 $2}
		|	Expression1 or_ Expression2 		{ OrExp $1 $3 $2}
		|	Expression2				{ $1 }
Expression2	:	neg_ Expression3 			{ NotExp $2 $2}
	    	|	Expression3				{ $1 }
Expression3	:	Expression3 equals_ Expression4 	{ EqExp $1 $3 $2}
		|	Expression3 nequals_ Expression4	{ NEqExp $1 $3 $2}
		|	Expression3 lessthan_ Expression4 	{ LTExp $1 $3 $2}
		|	Expression3 greatthan_ Expression4 	{ GTExp $1 $3 $2}
		|	Expression3 lessthaneq_ Expression4 	{ LETExp $1 $3 $2}
		|	Expression3 greatthaneq_ Expression4 	{ GETExp $1 $3 $2}
		|	Expression4				{ $1 }
Expression4	:	Expression4 add_ Expression5 	{ AddExp $1 $3 $2}
		|	Expression4 sub_ Expression5 	{ SubExp $1 $3 $2}
		|	Expression4 mul_ Expression5 	{ MulExp $1 $3 $2}
		|	Expression4 div_ Expression5 	{ DivExp $1 $3 $2}
		|	Expression5			{ $1 }
Expression5	:	sub_ Expression6		{ NegExp $2 $1}
	    	|	add_ Expression6		{ PosExp $2 $1}
		|	Expression6			{ $1 }
Expression6	:	mul_ Expression7 		{ DerExp $2 $1} 
		|	ref_ Expression7		{ RefExp $2 $1}
		|	Expression7			{ $1 }
Expression7	:	Value 				{ $1 }
		|	bknOpen_ Expression1 bknClose_	{ $2 }

Value		:	LValue		{ VExp3 $1 }
		|	Literal 	{ VExp1 $1 }
		|	FunctionCall 	{ VExp2 $1 }
       
Label		:	label_		{ (fst $1) }

TypeSpec	:	typeInt_	{ IntSpec $1 }
		|	typeReal_	{ RealSpec $1 }
		|	typeBool_	{ BoolSpec $1 }
		|	typeString_	{ StringSpec $1 }
		|	typeChar_	{ CharSpec $1 }
		|	typeVoid_	{ VoidSpec $1 }

Literal		:	int_ 		{ Int' (fst $1) (snd $1) }
		|	real_ 		{ Real' (fst $1) (snd $1) }
		|	char_ 		{ Char' (fst $1) (snd $1) }
		|	string_ 	{ String' (fst $1) (snd $1) }
		|	ArrayElement 	{ Array' $1 }
		|	true_		{ Bool' "true" $1 }
		|	false_		{ Bool' "false" $1 }
{

main = do
    s <- getContents
    let tok = alexScanTokens s
    print tok
    ast <- parseChapel tok
    putStrLn (typeCheck ast)

parseError (tok:toks) = error ("Parser Error:" ++ show tok ++ " at invalid position.")

typeCheck a = case a of
    (Program x) 	-> foldr (++) [] (map typeCheck x)
    (Stmt1 x)	        -> foldr (++) [] (map typeCheck x)
    (Stmt2 x)           -> expTypeCheck x 
    (Stmt3 x)		-> typeCheck x
    (Stmt5 x)		-> typeCheck x
    (Stmt6 x)		-> typeCheck x
    (Stmt7 x)		-> typeCheck x
    (Stmt8 x)		-> typeCheck x
    (Stmt9 x)		-> typeCheck x
    (Stmt10 x)		-> typeCheck x
    (FullDecl _ param cast body)	-> (returnCheck cast body) ++ "\n" ++ (typeCheck body)
    (NoCastDecl _ _ body)		-> (typeCheck body)
    (NoParamDecl _ cast body)	-> returnCheck cast body
    (NakedDecl _ body)		-> typeCheck body
    (DeclAssign decl lval)	-> compareTypes (inferType decl) (inferType lval)
    (WD condition body)		-> (boolCheck condition) ++ (typeCheck body)
    (DW body condition)		-> (boolCheck condition) ++ (typeCheck body)
    (OneLineIf condition stm)	-> (boolCheck condition) ++ (typeCheck stm) 
    (IfBlock condition blk)	-> (boolCheck condition) ++ (typeCheck blk) 
    (IfElseBlock condition blkThen blkElse)	-> (boolCheck condition) ++ (typeCheck blkThen) ++ (typeCheck blkElse)
    (ForBlk _ _ block)		-> (typeCheck block)
    (ForSmp _ _ stmt)		-> (typeCheck stmt)
    (TrCh stmt1 stmt2)		-> (typeCheck stmt1) ++ (typeCheck stmt2)
    _                           -> []

inferType a = case a of
    (AddExp x y)    ->  
    (SubExp x y)    ->
    (MulExp x y)    ->
    (DivExp x y)    ->
    (PosExp x)      ->
    (NegExp x)      ->
    (RefExp x)      ->
    (EqExp x y)     ->
    (NEqExp x y)    ->
    (LTExp x y)     ->
    (GTExp x y)     ->
    (LETExp x y)    ->
    (GETExp x y)    ->
    (AndExp x y)    ->
    (OrExp x y)     ->
    (NotExp x)      ->
    (VExp1 x)       -> 
    (VExp2 x)       -> inferType x
    (VExp3 x)       -> inferType x

data TReturnType = Correct Type | Error Type | Ignore deriving (Eq, Ord, Show)

expTypeCheck a = let 
	getOp a = fst $ expTypeCheck a
	getErr a = snd $ expTypeCheck a
	result a b = evaluate (getOp a) (getOp b)
	throwErr a b = errMsg (getOp a) (getOp b)
		in case a of
			(AddExp x y _)    ->	(result x y (), concatErrMsg x y)
			(SubExp x y _)    ->	(result x y (), concatErrMsg x y)
			(MulExp x y _)    ->	(result x y (), concatErrMsg x y)
			(DivExp x y _)    ->	(result x y (), concatErrMsg x y)
			(PosExp x _)      ->	(result x (Bool "" (0,0)) (), concatErrMsg x (Bool' "" (0,0)) $ ++ posErrMsg x )
			(NegExp x _)      ->
			(RefExp x _)      ->
			(EqExp x y pos)   ->	(result x y (Bool' "" pos), )
			(NEqExp x y _)    ->	(result x y (Bool' "" pos), ) 
			(LTExp x y _)     ->	(result x y (Bool' "" pos), )	
			(GTExp x y _)     ->	(result x y (Bool' "" pos), )	
			(LETExp x y _)    ->	(result x y (Bool' "" pos), )	
			(GETExp x y _)    ->	(result x y (Bool' "" pos), )	
			(AndExp x y _)    ->	(result x y (Bool' "" pos), )	
			(OrExp x y _)     ->	(result x y (Bool' "" pos), )	
			(NotExp x _)      ->	(result x y (Bool' "" pos), )
			(VExp1 x)         ->	(x, "")
			(VExp2 x)         ->	((), "")
			(VExp3 x)         ->	((), "")
	where 	evaluate x y type = case compareTypes a b of
			True	->	retType a b
			False 	->	()
			_	->	()
			where   retType a b type = type
				retType a b _ = case (a,b) of
					((Real' _ _ ),(Int' _ _))	->	a
					((Int' _ _ ),(Real' _ _))	->	b
					_				->	a
		errMsg a b = case compareTypes a b of
			False	->	"Type Error: "++show a++" type is incompatible with "++show b
			_	->	[]
		concatErrMsg a b = (getErr a) ++ (getErr b) ++ throwErr a b
		posErrMsg a b = 

returnCheck cast body = case (compareTypes (inferType cast) (getReturn body)) of
    True -> []
    False -> "Type Error: Return YOYO"
    where getReturn b = case b of
                        (a@(Ret1 x),_)  -> inferType a
                        (a@(Ret2 x),_)  -> inferType a
                        (_,x)           -> getReturn x
                        _       	-> Void' 

compareTypes a b = case compare a b of
    True -> []
    False -> "SADASDASD"
    where compare a b = case (a,b) of
            ((Int' _ _), (Int' _ _))       -> True
            ((Real' _ _), (Real' _ _))     -> True
            ((Char' _ _), (Char' _ _))     -> True
            ((String' _ _), (String' _ _)) -> True
            ((Bool' _ _), (Bool' _ _))     -> True
            ((Array' lst1), (Array' lst2)) -> compareTypes lst1 lst2
            ((Pointer' t), (Pointer' d))   -> compareTypes t d
            ((Void'), (Void'))             -> True
            ((Int' _ _), (Real' _ _))      -> True
            ((Real' _ _), (Int' _ _))      -> True
	    ((),_)			   -> True
	    (-,())			   -> True
	    ((x:xs),(y:ys))		   -> (compareTypes x y) && (compareTypes xs ys)
	    ((x:_)),(y:_))		   -> compareTypes x y
            _                              -> False

boolCheck a = compareTypes (inferType a) (Bool' "" (0,0)) 

}
