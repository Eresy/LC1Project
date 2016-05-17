-- This Happy file is an adaptation of machine-generated code by the BNF
-- converter.
--
--
-- The idea of this example is to show how to quickly realize a prototype
-- of a Lexer and a Parser for a programming language.  With the running
-- BNFC prototype we tested if the concrete grammar behaved as expected.
-- Then, by small manual refinements of the grammar and adaptations of the
-- production's actions directly on this Happy sources, we redefined a
-- better abstract syntax and tuned the Parser.
--
--
-- This version, for didactic purposes, uses (++) to build lists out
-- left-recursive production definitions.  Once one learns to move from the
-- object level to the function level, its easy to modify it with a linear
-- combination.
--
--
-- Adaptation by Marco Comini


{
{-# OPTIONS -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
module ImpyParser where
import ErrM
import ImpyAbstractSyntax
import ImpyLexer
}

%name pProgram Program
%name pDecl Decl
%name pRExpr RExpr
%name pLExpr LExpr
%name pStmt Stmt

-- no lexer declaration
%monad { Err } { thenM } { returnM }
%tokentype { Token }

%token
 '!' { PT _ (TS _ 1) }
 '!=' { PT _ (TS _ 2) }
 '%' { PT _ (TS _ 3) }
 '&' { PT _ (TS _ 4) }
 '&&' { PT _ (TS _ 5) }
 '&=' { PT _ (TS _ 6) }
 '(' { PT _ (TS _ 7) }
 ')' { PT _ (TS _ 8) }
 '*' { PT _ (TS _ 9) }
 '*=' { PT _ (TS _ 10) }
 '+' { PT _ (TS _ 11) }
 '++' { PT _ (TS _ 12) }
 '+=' { PT _ (TS _ 13) }
 ',' { PT _ (TS _ 14) }
 '-' { PT _ (TS _ 15) }
 '--' { PT _ (TS _ 16) }
 '-=' { PT _ (TS _ 17) }
 '/' { PT _ (TS _ 18) }
 '/=' { PT _ (TS _ 19) }
 ';' { PT _ (TS _ 20) }
 '<' { PT _ (TS _ 21) }
 '<=' { PT _ (TS _ 22) }
 '=' { PT _ (TS _ 23) }
 '==' { PT _ (TS _ 24) }
 '>' { PT _ (TS _ 25) }
 '>=' { PT _ (TS _ 26) }
 'False' { PT _ (TS _ 27) }
 'True' { PT _ (TS _ 28) }
 '[' { PT _ (TS _ 29) }
 ']' { PT _ (TS _ 30) }
 '^' { PT _ (TS _ 31) }
 '^=' { PT _ (TS _ 32) }
 'bool' { PT _ (TS _ 33) }
 'break' { PT _ (TS _ 34) }
 'char' { PT _ (TS _ 35) }
 'const' { PT _ (TS _ 36) }
 'continue' { PT _ (TS _ 37) }
 'do' { PT _ (TS _ 38) }
 'else' { PT _ (TS _ 39) }
 'float' { PT _ (TS _ 40) }
 'if' { PT _ (TS _ 41) }
 'int' { PT _ (TS _ 42) }
 'name' { PT _ (TS _ 43) }
 'ref' { PT _ (TS _ 44) }
 'res' { PT _ (TS _ 45) }
 'return' { PT _ (TS _ 46) }
 'val' { PT _ (TS _ 47) }
 'valres' { PT _ (TS _ 48) }
 'void' { PT _ (TS _ 49) }
 'while' { PT _ (TS _ 50) }
 '{' { PT _ (TS _ 51) }
 '|=' { PT _ (TS _ 52) }
 '||' { PT _ (TS _ 53) }
 '}' { PT _ (TS _ 54) }

L_ident  { PT _ (TV $$) }
L_integ  { PT _ (TI $$) }
L_charac { PT _ (TC $$) }
L_quoted { PT _ (TL $$) }
L_err    { _ }


%left '||'
%left '&&'
%left '!'
%nonassoc '==' '!=' '<' '<=' '>' '>='
%left '+' '-'
%left '*' '/' '%'
%right '^'
%left NEG

%%

VarIdent :: { VarIdent } : L_ident   { Var $1 }
FunIdent :: { FunIdent } : L_ident   { Fun $1 $ error "unknown arity" }
Integer :: { Int } : L_integ  { (read $1) :: Int }
Char    :: { Char }    : L_charac { (read $1) :: Char }
String  :: { String }  : L_quoted { $1 }

RExpr :: { RExpr }
  :  '(' RExpr ')'   { $2 }
  | RExpr '||' RExpr { InfixOp (BoolOp Or ) $1 $3 }
  | RExpr '&&' RExpr { InfixOp (BoolOp And) $1 $3 }
  | RExpr '==' RExpr { InfixOp (RelOp Eq ) $1 $3 }
  | RExpr '!=' RExpr { InfixOp (RelOp Neq) $1 $3 }
  | RExpr '<'  RExpr { InfixOp (RelOp Lt ) $1 $3 }
  | RExpr '<=' RExpr { InfixOp (RelOp LtE) $1 $3 }
  | RExpr '>'  RExpr { InfixOp (RelOp Gt ) $1 $3 }
  | RExpr '>=' RExpr { InfixOp (RelOp GtE) $1 $3 }
  | RExpr '+'  RExpr { InfixOp (ArithOp Add) $1 $3 }
  | RExpr '-'  RExpr { InfixOp (ArithOp Sub) $1 $3 }
  | RExpr '*'  RExpr { InfixOp (ArithOp Mul) $1 $3 }
  | RExpr '/'  RExpr { InfixOp (ArithOp Div) $1 $3 }
  | RExpr '%'  RExpr { InfixOp (ArithOp Mod) $1 $3 }
  | RExpr '^'  RExpr { InfixOp (ArithOp Pow) $1 $3 }
  | '!' RExpr        { UnaryOp Not $2 }
  | '-' RExpr %prec NEG { UnaryOp Neg $2 }
  | LExpr            { LExpr $1 }
  | FunIdent '(' ListRExpr ')' { FCall $1 $3 }
  | Integer          { Const $ Int $1 }
  | Char             { Const $ Char $1 }
  | String           { Const $ String $1 }

LExpr :: { LExpr }
  : LExpr1      { $1 }
  | '++' LExpr1 { PrePostIncDecr Pre Inc $2 }
  | '--' LExpr1 { PrePostIncDecr Pre Decr $2 }

LExpr1 :: { LExpr }
  : LExpr2      { $1 }
  | LExpr2 '++' { PrePostIncDecr Post Inc $1 }
  | LExpr2 '--' { PrePostIncDecr Post Decr $1 }

LExpr2 :: { LExpr }
  : '(' LExpr ')' { $2 }
  | BLExpr        { $1 }


BLExpr :: { LExpr }
  : BLExpr '[' RExpr ']' { ArrayEl $1 $3 }
  | VarIdent { Ident $1 }


ListRExpr :: { [RExpr] }
  : {- empty -}         { [] }
  | RExpr               { [$1] }
  | RExpr ',' ListRExpr { $1 : $3 }


Program :: { Program }
  : ListDecl { Prog $1 }


ListDecl :: { [Decl] }
  : {- empty -}   { [] }
  | ListDecl Decl { $1 ++ $2 }


Decl :: { [Decl] }
  : TypeSpec ListVarDecl ';' { cnv2Dvar $1 $2 }
  | TypeSpec FunIdent '(' ListParameter ')' CompStmt { [cnv2Dfun $1 $2 $4 $6] }


-- ListVarDecl :: { [VarDecl] }
ListVarDecl
  : VarDecl                 { [$1] }
  | VarDecl ',' ListVarDecl { $1 : $3 }


ListParameter :: { [FormParam] }
  : {- empty -}                 { [] }
  | Parameter                   { [$1] }
  | Parameter ',' ListParameter { $1 : $3 }


Parameter :: { FormParam }
  : TypeSpec VarIdent { Par{pmdlty=Value,ptype=$1,pvar=$2} }


VarDecl :: { (VarIdent,RExpr) }
VarDecl : VarIdent '=' RExpr { ($1,$3) }


ListStmt :: { [Stmt] }
  : {- empty -}   { [] }
  | ListStmt Stmt { $2 : $1 }


TypeSpec :: { Type }
  : BasicType { $1 }


BasicType :: { Type }
  : 'bool'  { BasicType BTBool }
  | 'char'  { BasicType BTChar }
  | 'float' { BasicType BTFloat }
  | 'int'   { BasicType BTInt }
  | 'void'  { BasicType BTVoid }


CompStmt :: { Stmt }
  : '{' ListDecl ListStmt '}' { Block $2 (reverse $3) }


Stmt :: { Stmt }
  : CompStmt { $1 }
  | FunIdent '(' ListRExpr ')' ';' { DiscardRet $ FCall $1 $3 }
  | JumpStmt { $1 }
  | IterStmt { $1 }
  | SelectionStmt { $1 }
  | LExpr Assignment_op RExpr ';' { Assgn $2 $1 $3 }


Assignment_op :: { AssignmentOp }
  : '='  { Assign }
  | '*=' { AssgnArith Mul }
  | '+=' { AssgnArith Add }
  | '/=' { AssgnArith Div }
  | '-=' { AssgnArith Sub }
  | '&=' { AssgnBool  And }
  | '^=' { AssgnBool  Xor }
  | '|=' { AssgnBool  Or  }


JumpStmt :: { Stmt }
  : 'break' ';' { Break }
  | 'continue' ';' { Continue }
  | 'return' ';'               { RetExp $ Nothing }
  | 'return' '(' RExpr ')' ';' { RetExp $ Just $3 }


SelectionStmt :: { Stmt }
  : 'if' '(' RExpr ')' Stmt             { IfNoElse $3 $5 }
  | 'if' '(' RExpr ')' Stmt 'else' Stmt { IfElse $3 $5 $7 }


IterStmt :: { Stmt }
  : 'while' '(' RExpr ')' Stmt      { While $3 $5 }
  | 'do' Stmt 'while' '(' RExpr ')' { DoWhile $2 $5 }



{
cnv2Dvar :: Type -> [(VarIdent,RExpr)] -> [Decl]
cnv2Dvar t = map cnv
  where
    cnv (v,e) = Dvar v t (Just $ Basic e)

cnv2Dfun :: Type -> FunIdent -> [FormParam] -> Stmt -> Decl
cnv2Dfun t (Fun f _) ps (Block ds cs) = Dfun (Fun f $ length ps) t ps ds cs
cnv2Dfun _ _ _  _ = error "Internal Parser Error"

returnM :: a -> Err a
returnM = return

thenM :: Err a -> (a -> Err b) -> Err b
thenM = (>>=)

happyError :: [Token] -> Err a
happyError ts =
  Bad $ "syntax error at " ++ tokenPos ts ++
  case ts of
    [] -> []
    [Err _] -> " due to lexer error"
    _ -> " before " ++ unwords (map prToken (take 4 ts))

myLexer = tokens
}

