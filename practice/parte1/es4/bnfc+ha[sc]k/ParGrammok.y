-- This Happy file was machine-generated by the BNF converter
{
{-# OPTIONS_GHC -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
module ParGrammok where
import AbsGrammok
import LexGrammok
import ErrM

}

%name pExpT ExpT
%name pListExpT ListExpT
-- no lexer declaration
%monad { Err } { thenM } { returnM }
%tokentype {Token}
%token
  ',' { PT _ (TS _ 1) }
  '<' { PT _ (TS _ 2) }
  '>' { PT _ (TS _ 3) }

L_integ  { PT _ (TI $$) }
L_doubl  { PT _ (TD $$) }


%%

Integer :: { Integer } : L_integ  { (read ( $1)) :: Integer }
Double  :: { Double }  : L_doubl  { (read ( $1)) :: Double }

ExpT :: { ExpT }
ExpT : Integer '<' ListExpT '>' { AbsGrammok.Tree $1 $3 }
     | Integer { AbsGrammok.Leaf $1 }
     | Double '<' ListExpT '>' { AbsGrammok.FTree $1 $3 }
     | Double { AbsGrammok.FLeaf $1 }
ListExpT :: { [ExpT] }
ListExpT : {- empty -} { [] }
         | ExpT { (:[]) $1 }
         | ExpT ',' ListExpT { (:) $1 $3 }
{

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
    _ -> " before " ++ unwords (map (id . prToken) (take 4 ts))

myLexer = tokens
}
