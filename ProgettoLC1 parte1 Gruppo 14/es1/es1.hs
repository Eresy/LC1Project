module Main where 

import System.Environment

data BST a = Void | Node a (BST a) (BST a)
  deriving (Eq, Ord, Show, Read)

boundedMaximum :: Ord a => a -> [BST a] -> [a]
boundedMaximum _ [] = []

boundedMaximum n (x:xs) = (maxNT n x) ++ ( boundedMaximum n xs)
  where
    maxNT n x = foldBST (max) (getmin n x)
      where
        foldBST f [] = []
        foldBST f list = [ foldl1 f list ]
        getmin n Void  = []
        getmin n (Node m l r) | n <= m = getmin n l
                              | n >= m = [m] ++ (getmin n l) 

main = do
  putStrLn "imporre il massimo"
  mas <- getLine
  putStrLn "su quale lista di BST?"
  lista <- getLine
  let n = read mas
      bst = read lista::[BST Int]
  print mas
  print lista
  print $ boundedMaximum n bst
