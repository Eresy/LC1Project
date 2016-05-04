{
module Main where
import Data.Char (isDigit, isAlpha, isSpace)
}

%name calc
%tokentype { Token }
%error { parseError }

%token
   let   { TLet }
   in    { TIn }
   int   { TInt $$ }
   var   { TVar $$ }
   '='   { TEq }
   '+'   { TPlus }
   '-'   { TMinus }
   '*'   { TTimes }
   '/'   { TDiv }
   '('   { TOpenBrk }
   ')'   { TClosBrk }

%%

Exp   : let var '=' Exp in Exp   { Let $2 $4 $6 }
      | Exp1                     { Exp1 $1 }

Exp1  : Exp1 '+' Term            { Plus $1 $3 }
      | Exp1 '-' Term            { Minus $1 $3 }
      | Term                     { Term $1 }

Term  : Term '*' Factor          { Times $1 $3 }
      | Term '/' Factor          { Div $1 $3 }
      | Factor                   { Factor $1 }

Factor
      : int                      { Int $1 }
      | var                      { Var $1 }
      | '(' Exp ')'              { Brack $2 }

{

parseError :: [Token] -> a
parseError _ = error "DioSalame"

data Exp
      = Let String Exp Exp
      | Exp1 Exp1

instance Show Exp where
   show (Let s a b) = "LET " ++ s ++ show a ++ show b
   show (Exp1 x) = show x

data Exp1
      = Plus Exp1 Term
      | Minus Exp1 Term
      | Term Term

instance Show Exp1 where
   show (Plus a b) = show a ++ " $+ " ++ show b
   show (Minus a b) = show a ++ " $- " ++ show b
   show (Term x) = show x

data Term
      = Times Term Factor
      | Div Term Factor
      | Factor Factor

instance Show Term where
   show (Times a b) = show a ++ " $* " ++ show b
   show (Div a b) = show a ++ " $/ " ++ show b
   show (Factor x) = show x

data Factor
      = Int Int
      | Var String
      | Brack Exp

instance Show Factor where
   show (Int x) = "$I:=" ++ show x  
   show (Var x) = "$V:=" ++ x
   show (Brack x) = "$( \n" ++ show x ++ "\n $)"



data Token
      = TLet
      | TIn
      | TInt Int
      | TVar String
      | TEq
      | TPlus
      | TMinus
      | TTimes
      | TDiv
      | TOpenBrk
      | TClosBrk
      deriving Show

-- LEXER
lexer :: String -> [Token]
lexer [] = []
lexer (c:cs)
      | isSpace c = lexer cs
      | isAlpha c = lexVar (c:cs)
      | isDigit c = lexNum (c:cs)
lexer ('=':cs) = TEq : lexer cs
lexer ('+':cs) = TPlus : lexer cs
lexer ('-':cs) = TMinus : lexer cs
lexer ('*':cs) = TTimes : lexer cs
lexer ('/':cs) = TDiv : lexer cs
lexer ('(':cs) = TOpenBrk : lexer cs
lexer (')':cs) = TClosBrk : lexer cs

lexNum cs = TInt (read num) : lexer rest
       where (num,rest) = span isDigit cs

lexVar cs = 
   case span isAlpha cs of
      ("let",rest) -> TLet : lexer rest
      ("in",rest)  -> TIn : lexer rest
      (var, rest)  -> TVar var : lexer rest



      
main = getContents >>= print . calc . lexer
}
