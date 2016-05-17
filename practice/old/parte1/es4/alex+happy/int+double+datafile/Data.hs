module Data where

--Definisco il tipo di dato che rappresenta più da vicino l'albero di sintassi astratta
data Tree x = 
 Node x [Tree x] | 
 Leaf x 
 deriving (Show)

data Token = 
 Int String |
 Double String |
 TreeOpen |
 TreeClose |
 Separator
