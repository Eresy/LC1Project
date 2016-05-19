module Data where

data Token = SComment String Pos
           | MComment String Pos
           deriving(Eq, Ord, Show)

type Pos = (Int, Int)
