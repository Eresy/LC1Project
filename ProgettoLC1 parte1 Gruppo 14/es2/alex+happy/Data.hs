
module Data where

data Tree x = Node Integer x [Tree x] | Leaf Integer x deriving (Show)

data Tokens = Int String |
              Double String |
              ListOpen |
              ListClose |
              Separator
