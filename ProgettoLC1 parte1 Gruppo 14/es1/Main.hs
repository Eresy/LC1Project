module Main where 
import BoundMax
import System.Environment

main = do
  putStrLn "Imporre il massimo"
  mas <- getLine
  putStrLn "Su quale lista di BST?"
  lista <- getLine
  let n = read mas
      bst = read lista::[BST Int]
  print $ boundedMaximum n bst
