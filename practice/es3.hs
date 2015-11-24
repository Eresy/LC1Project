data Matrix a = Mat { nexp :: Int, mat :: QT a}
  deriving(Show)
data QT a = C a | Q (QT a) (QT a) (QT a) (QT a)
  deriving(Show)

--createQT ::
createQT :: Int -> [b] -> QT b
createQT _ [] = error "List not divisible by 4"
createQT 0 (x: []) = C x

createQT n ls = Q ( createQT (n-1) (take num ls))
                  ( createQT (n-1) (take num (drop num ls)))
                  ( createQT (n-1) (take num (drop (2*num) ls )))
                  ( createQT (n-1) (take num (drop (3*num) ls )))
                    where num =( 2^((2*n) - 2))

createMat :: Int -> [a] -> Matrix a 
createMat 0 [a] = Mat 0 (C a)
createMat n ls = Mat n (createQT n ls)

