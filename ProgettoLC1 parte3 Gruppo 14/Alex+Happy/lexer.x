{

--module Main(main) where

module Lexer (alexScanTokens) where

import Data (Token(..))

}

%wrapper "basic"

$lett = [a-zA-Z]
$num = [0-9]
$special = [\t\n]


:-

$white+                             ;

$num+				                     {\x -> Int x}

$num+ ’.’ $num+ (’e’ ’-’? $num+)?   {\x -> Double x} 

break                               {\x -> Break}

continue                            {\x -> Continue}

return                              {\x -> Return}

’\’’ ($lett | (’\\’ "\n\t")) ’\’’   {\x -> Char x}

’"’ @string ’"’			            {\x -> String x}

$lett ($lett | $num | ’_’ | ’\’’)*  {\x -> Label x}

\( {\x -> BrakOpen}

\) {\x -> BrakClose}

\[ {\x -> SBrakOpen}

\] {\x -> SBrakClose}

\{ {\x -> CBrakOpen}

\} {\x -> CBrakClose}

\= {\x -> AssignOp}

\=\= {\x -> CompareOp}

\< {\x -> LessThanOp}

\> {\x -> GreaterThanOp}

\>\= {\x -> ELessThanOp}

\<\= {\x -> EGreaterThanOp}

\+ {\x -> AddOp}

\- {\x -> SubOp}

\* {\x -> MulOp}

\/ {\x -> DivOp}

\+\+ {\x -> IncOp}

\-\- {\x -> DecOp}

\, {\x -> Comma}

\; {\x -> Semicolon}

\& {\x -> Dereference }

\&\& {\x -> And} 

\|\| {\x -> Or}

\! {\x -> NegOp}

. ;

{

--main = do
--    s <- getContents
--    print (alexScanTokens s)

}

