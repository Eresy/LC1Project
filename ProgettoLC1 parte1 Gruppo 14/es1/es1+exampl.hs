module Main (main) where

-- Struttura dati
data BST a = Void | Node a (BST a) (BST a)
  deriving (Show, Eq, Ord)

-- Metodi 
boundedMaximum :: Ord a => a -> [BST a] -> [a]
boundedMaximum _ [] = []
boundedMaximum n (l:ls) = (maxInterMin n l) ++ (boundedMaximum n ls)
  
maxInterMin :: Ord a => a -> BST a -> [a]
maxInterMin _ Void = []
maxInterMin n t@(Node a l r)
  | n > a   = bigSing $ toList t []
  | n <= a  = bigSing $ toList l [] 

toList :: BST a -> [a] -> [a]  
toList Void ls = ls  
toList (Node a l r) ls = toList l [] ++ toList r [] ++ (a:ls)

bigSing :: Ord a => [a] -> [a]
bigSing [] = []
bigSing xs = (foldl1 (max) xs) : []

-- MAIN
main = do 
  putStrLn "boundedMaximum 3 [Void]"
  print $ boundedMaximum 3 [Void]

  putStrLn "boundedMaximum 3 [Node 3 Void Void]"
  print $ boundedMaximum 3 [Node 3 Void Void]

  putStrLn "boundedMaximum 3 [Node 3 Void Void, Node 5 (Node 2 Void Void) Void]"
  print $ boundedMaximum 3 [Node 3 Void Void, Node 5 (Node 2 Void Void) Void]

  putStrLn "boundedMaximum 4 [Node 3 Void Void, Node 5 (Node 2 Void Void) Void]"
  print $ boundedMaximum 4 [Node 3 Void Void, Node 5 (Node 2 Void Void) Void]

  putStrLn "boundedMaximum 7 [Node 7 (Node 5 (Node 4 Void Void) (Node 6 Void Void)) Void, \n\t\t  Node 2 Void Void, \n\t\t  Node 15 Void (Node 5 (Node 3 Void Void) Void)]"
  print $ boundedMaximum 7 [Node 7 (Node 5 (Node 4 Void Void) (Node 6 Void Void)) Void, Node 2 Void Void, Node 15 Void (Node 25 (Node 23 Void Void) Void)]


