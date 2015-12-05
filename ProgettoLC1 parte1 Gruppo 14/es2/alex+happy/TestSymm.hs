module TestSymm where

import ParserI(parseIntTree, parse)
import Symm

test = isSymm . parse

printTests x = do
 let parsedStr = (parse x)
 putStr "Albero: "
 print parsedStr
 putStr "Invertito: "
 print (trasp parsedStr)
 putStr "E` simmetrico: "
 print (test x)
 putStr "\n"

main = do
 x <- getContents
 mapM_ (printTests) (lines x)
