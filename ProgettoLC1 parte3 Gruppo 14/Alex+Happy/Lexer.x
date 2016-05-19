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

$num+ 


. ;

{
getPos :: AlexPosn -> Pos
getPos (AlexPn _ x y) = (x,y)

main = do
   s <-getContents
   print (alexScanTokens s)
}
