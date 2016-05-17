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
   putStr $ makeString $ (indent 0) $ readToks (alexScanTokens s)



readToks :: [Token] -> [String]   
readToks = map readTok

readTok :: Token -> String
readTok t
   | t == BrackOpen = "{ \n"
   | t == BrackClos = "} \n"
   | t == Separat   = "; \n"
   | otherwise      = show t ++ " "


indent :: Int -> [String] -> [String]
indent n [] = []
indent n (x:xs)
   | x == "{ \n" = (addSpace (n*3) x) : (indent (n+1) xs)
   | x == "} \n" = (addSpace ((n-1)*3) x) : (indent (n-1) xs)
   | otherwise   = (addSpace (n*3) x) : (indent2 n xs)


indent2 :: Int -> [String] -> [String]
indent2 n [] = []
indent2 n (x:xs)
   | x == "; \n" = x : (indent n xs)
   | otherwise   = x : (indent2 n xs)


addSpace :: Int -> String -> String
addSpace 0 txt = txt
addSpace x txt = " " ++ addSpace (x-1) txt


makeString :: [String] -> String
makeString = foldl1 (++)
}
