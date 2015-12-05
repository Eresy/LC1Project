
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

(\-)? $int+ {\x -> Int x}


(\-)? $int+ \. $int+ (e (\-)? $int+)? {\x -> Double x}
-- Haskell considera 10e3 un double
(\-)? $int+ e (\-)? $int+ (\. $int+)? {\x -> Double x}

--Tokens per delimitare i figli

\[ {\x -> ListOpen}
\] {\x -> ListClose}
\, {\x -> Separator}

. ;

{

--Empty block

 
}

