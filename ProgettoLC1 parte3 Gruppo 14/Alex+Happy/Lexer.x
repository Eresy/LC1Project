{

--module Main(main) where

module Lexer (alexScanTokens) where

import Data (Token(..), Pos(..))

}

%wrapper "posn"

$lett = [a-zA-Z]
$num = [0-9]


:-

$white+                             ;

$num+				    {\x y -> Int y (getPos x)}

$num+ ’.’ $num+ (’e’ ’-’? $num+)?   {\x y -> Double y (getPos x)} 

int                                 {\x y -> IntLabel (getPos x)}

float                               {\x y -> FloatLabel (getPos x)} 

char                                {\x y -> CharLabel (getPos x)}

String                              {\x y -> StringLabel (getPos x)}

void                                {\x y -> VoidLabel (getPos x)}

readInt                             {\x y -> ReadIntPF (getPos x)}

writeInt                            {\x y -> WriteIntPF (getPos x)}

readFloat                           {\x y -> ReadFloatPF (getPos x)}

writeFloat                          {\x y -> WriteFloatPF (getPos x)}

readChar                            {\x y -> ReadCharPF (getPos x)}

writeChar                           {\x y -> WriteCharPF (getPos x)}

readString                          {\x y -> ReadStringPF (getPos x)}

writeString                         {\x y -> WriteStringPF (getPos x)}

break                               {\x y -> Break (getPos x)}

continue                            {\x y -> Continue (getPos x)}

return                              {\x y -> Return (getPos x)}

valres                              {\x y -> ValRes (getPos x)}

’\’’ ($lett | (’\\’ "\n\t")) ’\’’   {\x y -> Char y (getPos x)}

’"’ @string ’"’			            {\x y -> String y (getPos x)}

$lett ($lett | $num | ’_’ | ’\’’)*  {\x y -> Label y (getPos x)}

\( {\x y -> BrakOpen (getPos x)}

\) {\x y -> BrakClose (getPos x)}

\[ {\x y -> SBrakOpen (getPos x)}

\] {\x y -> SBrakClose (getPos x)}

\{ {\x y -> CBrakOpen (getPos x)}

\} {\x y -> CBrakClose (getPos x)}

\= {\x y -> AssignOp (getPos x)}

\=\= {\x y -> EqualsOp (getPos x)}

\!\= {\x y -> DiffOp (getPos x) }

\< {\x y -> LessThanOp (getPos x)}

\> {\x y -> GreaterThanOp (getPos x)}

\>\= {\x y -> ELessThanOp (getPos x)}

\<\= {\x y -> EGreaterThanOp (getPos x)}

\+ {\x y -> AddOp (getPos x)}

\- {\x y -> SubOp (getPos x)}

\* {\x y -> MulOp (getPos x)}

\/ {\x y -> DivOp (getPos x)}

\+\+ {\x y -> IncOp (getPos x)}

\-\- {\x y -> DecOp (getPos x)}

\, {\x y -> Comma (getPos x)}

\; {\x y -> Semicolon (getPos x)}

\& {\x y -> Dereference (getPos x) }

\&\& {\x y -> And (getPos x)} 

\|\| {\x y -> Or (getPos x)}

\! {\x y -> NegOp (getPos x)}

. ;

{

getPos :: AlexPosn -> Pos
getPos (AlexPn _ x y) = (x,y)

--main = do
--    s <- getContents
--    print (alexScanTokens s)

}

