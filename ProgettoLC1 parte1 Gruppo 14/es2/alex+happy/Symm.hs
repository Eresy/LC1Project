module Symm where

import Data(Tree(..))

--Determina se l'albero passato è simmetrico
isSymm :: Tree x -> Bool
isSymm x = case x of
 (Leaf _ _) -> True
 a@(Node _ _ xs) -> isEq a (trasp a)
 
--Funzione per l'equivalenza strutturale di alberi qualsiasi
isEq :: Tree x -> Tree x -> Bool
isEq (Leaf _ _) (Leaf _ _) = True
isEq (Node _ _ _) (Leaf _ _) = False
isEq (Leaf _ _) (Node _ _ _) = False
isEq (Node _ _ x) (Node _ _ y) 
 | length x == length y = foldl1 (&&) (zipWith (isEq) x y)
 | otherwise = False
 
--Calcola la trasposizione dell'albero
trasp :: Tree x -> Tree x
trasp a@(Leaf _ _ ) = a
trasp (Node a b c) =  (Node a b (reverse (map (trasp) c)))
