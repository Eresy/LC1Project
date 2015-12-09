{

module Lexer where

--Prendo la def. dei token

import Data (Token(..))

}

--Uso il wrapper basic, quello posn può essere usato per segnalare la pos. di errori (o indentazioni particolari)

%wrapper "basic"

$lett = [a-zA-Z]
$int = [0-9]

:-

--Ignoro i whitespace

$white+ ;

--Leggo un intero

(\-)? $int+ {\x -> Int x}

--Leggo un numero in virgola mobile, compresa la notazione esponenziale

(\-)? $int+ \. $int+ (e (\-)? $int+)? {\x -> Double x}
(\-)? $int+ e (\-)? $int+ (\. $int+)? {\x -> Double x} -- 10e2 non è un Int per haskell...

--Tokens per delimitare i figli

\< {\x -> TreeOpen}
\> {\x -> TreeClose}
\, {\x -> Separator}

{

--Empty block

 
}
