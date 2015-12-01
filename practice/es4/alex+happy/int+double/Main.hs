
module Main (main) where

import Lexer (alexScanTokens, Token(..))
import ParserI (parseIntTree, IntTree(..))
import ParserD (parseDoubleTree, DoubleTree(..))

main = do
 x <- getContents
 print (either (show) (show) (parse (alexScanTokens x)))
 
parse :: [Token] -> Either IntTree DoubleTree
parse a@(x:_) = case x of
  (Int _) -> (Left (parseIntTree a))
  (Double _) -> (Right (parseDoubleTree a))

