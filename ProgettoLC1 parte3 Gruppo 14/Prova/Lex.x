{
-- STANDALONE
module Main (main) where

-- CON PARSER
--module Lex(alexScanTokens) where
import Data(Token(..))
}

%wrapper "basic"

$digit = 0-9
$alpha = [a-zA-Z]

tokens :-

   $white+        ;
   [\=\+\-\*\/]   { \s -> OpSym (head s)}
   \{             { \s -> BrackOpen }
   \}             { \s -> BrackClos }
   \;             { \s -> Separat }
   $digit+        { \s -> Integer (read s) }
   $alpha+        { \s -> Lett s }

   .              ;

{
main = do
   s <- getContents
   putStr $ makeString $ readToks (alexScanTokens s)

readToks :: [Token] -> [String]   
readToks = map readTok

readTok :: Token -> String
readTok t
   | t == BrackOpen = "{ \n"
   | t == BrackClos = "} \n"
   | t == Separat   = "; \n"
   | otherwise      = show t ++ " "

--indent 0 x:xs 
--   | x == "{ \n" = indent 1 xs
--   | otherwise   = indent 0 xs
--indent n x:xs

addSpace :: Int -> String -> String
addSpace 0 txt = txt
addSpace x txt = " " ++ addSpace (x-1) txt

makeString :: [String] -> String
makeString = foldl1 (++)
--makeString = foldl1 (concat)

}
