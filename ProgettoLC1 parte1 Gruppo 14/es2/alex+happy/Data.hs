
module Data where

data Tree x =  Leaf Integer x | Node Integer x [Tree x] deriving (Show, Eq, Ord)

data Token = Int String |
              Double String |
              ListOpen |
              ListClose |
              Separator
