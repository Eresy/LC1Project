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

--Leggo un intero, compreso con notazione esponenziale intera

(\-)? $int+ (e (\-)? $int+)?{\x -> Int x}

--Leggo un numero in virgola mobile, compreso con notazione esponenziale
--e discrimino se è un intero elevato ad un frazionale oppure se ha la virgola

(\-)? $int+ \. $int+ (e (\-)? $int+)? {\x -> Double x}
(\-)? $int+ e (\-) $int+ \. $int+ {\x -> Double x}

--Tokens per delimitare i figli

\< {\x -> TreeOpen}
\> {\x -> TreeClose}
\, {\x -> Separator}

{

--Empty block

 
}
