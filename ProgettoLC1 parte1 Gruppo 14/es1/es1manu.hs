
data BST a = Void | Node a (BST a) (BST a) deriving (Show, Ord, Eq)

boundedMaximum :: Ord a => a -> [BST a] -> [a]

boundedMaximum _ [] = []
boundedMaximum n (x:xs) = (maxtn n x) ++ (boundedMaximum n xs)
 where maxtn n (Void) = []
       maxtn n x = foldMe (max) (getMin n x)
                    where foldMe f [] = []
                          foldMe f list = [foldl1 f list]
                          getMin n Void = []
                          getMin n (Node m left right)
                            | n > m = [m] ++ (getMin n right) ++ (getMin n left)
                            | otherwise = (getMin n left)
