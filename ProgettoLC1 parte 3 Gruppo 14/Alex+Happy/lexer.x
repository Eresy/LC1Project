{

module Lexer(alexScanTokens) where

import Data (Token(..))

}

%wrapper "basic"

$lett = [a-zA-Z]
$num = [0-9]

:-

$white+ ;

$num+ {\x -> Int x}

$num+ ’.’ $num+ (’e’ ’-’? $num+)? {\x -> Double x}

’\’’ (($lett - ["’\\"]) | (’\\’ ["’\\nt"])) ’\’’ {\x -> Char x}

’"’ ((char - ["\"\\"]) | (’\\’ ["\"\\nt"]))* ’"’ {\x -> LitString x}

$lett ($lett | $num | ’_’ | ’\’’)* {\x -> Label x}

\( {\x -> BrakOpen}

\) {\x -> BrakClose}

\[ {\x -> SBrakOpen}

\] {\x -> SBrakClose}

\{ {\x -> CBrakOpen}

\} {\x -> CBrakClose}

\= {\x -> AssignOP}

\=\= {\x -> CompareOP}

\+ {\x -> AddOp}

\- {\x -> SubOp}

\* {\x -> MulOp}

\/ {\x -> DivOp}

\+\+ {\x -> CatOp}

\, {\x -> Comma}

\; {\x -> Semicolon}

\& {\x -> Dereference }

. ;

{

--empty

}

