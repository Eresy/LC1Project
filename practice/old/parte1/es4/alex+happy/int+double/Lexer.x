{
-- Rendo alexScanTokens esportabile, cosi` il parser può usare il lexer
module Lexer where

}

--Uso il wrapper basic, quello posn può essere usato per segnalare la pos. di errori (o indentazioni particolari)
%wrapper "basic"

$l = [a-zA-Z]
$d = [0-9]

:-

--Ignoro i whitespace
$white+ ;

--Prendo il resto dei caratteri non usati e lo ignoro; questo per non avere lexical errors
--.#[$lett $d \< \> \. \- e \,]       ;

--Leggo un Int, una serie di numeri da 0 a 9
$d+ {\x -> (d (read x))}

--Leggo un Double, serie di numeri separata da punto con o senza notazione espon.
$d+ \. $d+ (e (\-)? $d+)? {\x -> Double (read x)}

--Tokens per delimitare i figli
\< {\x -> TreeOpen}
\> {\x -> TreeClose}
\, {\x -> Separator}

{

--La def del datatype dei vari token che butto fuori dal lexer
data Token = 
 Int Int |
 Double Double |
 TreeOpen |
 TreeClose |
 Separator deriving (Show)
 
}
