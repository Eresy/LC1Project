module Data where

data Token = Integer Int
           | OpSym Char
           | Lett String
           | BrackOpen
           | BrackClos
           | Separat
           deriving Eq

instance Show Token where
  show (Integer x) = "i:" ++ show x
  show (OpSym x) = "o:" ++ show x  
  show (Lett x) = "v:" ++ x 
  show BrackOpen = "{"
  show BrackClos = "}" 
  show Separat = ";" 
