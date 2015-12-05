
{

module Lexer(alexScanTokens) where

import Data (Token(..))

}

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
(\-)? $int+ e (\-)? $int+ (\. $int+)? {\x -> Double x}

--Tokens per delimitare i figli

\[ {\x -> ListOpen}
\] {\x -> ListClose}
\, {\x -> Separator}

{

--Empty block

 
}

