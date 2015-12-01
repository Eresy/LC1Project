{

module Main (main) where

}

%wrapper "basic"

$lett = [a-zA-Z]
$int = [0-9]

rules:-

$white+ ;
$int {\x -> (Integ (read x))}
$int+ \. $int+ (e (\-)? $int+)? {\x -> FlPoint (read x)}
\< {\x -> TreeOpen}
\> {\x -> TreeClose}

{

data Token = 
 Integ Int |
 FlPoint Double |
 TreeOpen |
 TreeClose deriving (Show)

main = do s <- getContents
          print (alexScanTokens s)
}
