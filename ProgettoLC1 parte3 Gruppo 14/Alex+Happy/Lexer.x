{
-- STAND ALONE
module Main (main) where

-- SLAVE 
-- module Lexer (alexScanTokens) where

import Data (Token(..), Pos(..))
}

%wrapper "posn"

$alp = [a-zA-Z]
$num = [0-9]


:-

$white+                                      ;

"//" [.]*                                    {\x y -> SComment y (getPos x)}

"/*" [\0-\255]* "*/"                         {\x y -> MComment y (getPos x)}

$num+                                        {\x y -> Int y (getPos x)}

$num+ '.' $num+                              {\x y -> Real y (getPos x)}

int                                          {\x y -> TS_Int (getPos x)}

real                                         {\x y -> TS_Real (getPos x)}

char                                         {\x y -> TS_Char (getPos x)}

string                                       {\x y -> TS_String (getPos x)}

void                                         {\x y -> TS_Void (getPos x)}

val                                          {\x y -> PM_Value (getPos x)}

ref                                          {\x y -> PM_Reference (getPos x)}

const                                        {\x y -> PM_Constant (getPos x)}

if                                           {\x y -> If (getPos x)}

then                                         {\x y -> Then (getPos x)}

else                                         {\x y -> Else (getPos x)}

for                                          {\x y -> For (getPos x)}

in                                           {\x y -> In (getPos x)}

while                                        {\x y -> While (getPos x)}

do                                           {\x y -> Do (getPos x)}

break                                        {\x y -> Break (getPos x)}

continue                                     {\x y -> Continue (getPos x)}

try                                          {\x y -> Try (getPos x)}

catch                                        {\x y -> Catch (getPos x)}

var                                          {\x y -> CHP_Var (getPos x)}

proc                                         {\x y -> CHP_Func (getPos x)}

\:                                           {\x y -> CHP_Cast (getPos x)}

readInt                                      {\x y -> PF_readInt (getPos x)}

writeInt                                     {\x y -> PF_writeInt (getPos x)}

readReal                                     {\x y -> PF_readReal (getPos x)}

writeReal                                    {\x y -> PF_writeReal (getPos x)}

readChar                                     {\x y -> PF_readChar (getPos x)}

writeChar                                    {\x y -> PF_writeChar (getPos x)}

readString                                   {\x y -> PF_readString (getPos x)}

writeString                                  {\x y -> PF_writeString (getPos x)}

'\'' ($alp | ('\\' "\n\t")) '\''             {\x y -> Char y (getPos x)}

'"' @string '"'                              {\x y -> String y (getPos x)}

$alp ($alp | $num | '_' )* \$?               {\x y -> Label y (getPos x)} 

\(                                           {\x y -> BK_NOpen (getPos x)}

\)                                           {\x y -> BK_NClos (getPos x)}

\[                                           {\x y -> BK_SOpen (getPos x)}   

\]                                           {\x y -> BK_SClos (getPos x)}

\{                                           {\x y -> BK_COpen (getPos x)}

\}                                           {\x y -> BK_CClos (getPos x)}

\=                                           {\x y -> OP_Assign (getPos x)}

\=\=                                         {\x y -> OP_Equal (getPos x)}

\!\=                                         {\x y -> OP_NEqual (getPos x) }

\<                                           {\x y -> OP_LesThn (getPos x)}

\>                                           {\x y -> OP_GrtThn (getPos x)}

\>\=                                         {\x y -> OP_GrtThnEq (getPos x)}

\<\=                                         {\x y -> OP_LesThnEq (getPos x)}

\+                                           {\x y -> OP_Add (getPos x)}

\-                                           {\x y -> OP_Sub (getPos x)}

\*                                           {\x y -> OP_Mul (getPos x)}

\/                                           {\x y -> OP_Div (getPos x)}

\+\+                                         {\x y -> OP_Incr (getPos x)}

\-\-                                         {\x y -> OP_Decr (getPos x)}

\,                                           {\x y -> Comma (getPos x)}

\;                                           {\x y -> Semicolon (getPos x)}

\&                                           {\x y -> OP_Deref (getPos x) }

\&\&                                         {\x y -> OP_And (getPos x)} 

\|\|                                         {\x y -> OP_Or (getPos x)}

\!                                           {\x y -> OP_Negt (getPos x)}



. ;

{
getPos :: AlexPosn -> Pos
getPos (AlexPn _ x y) = (x,y)

main = do
   s <-getContents
   print (alexScanTokens s)
}
