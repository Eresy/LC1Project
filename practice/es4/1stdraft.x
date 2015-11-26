{
  module Main (main) where
}

%wrapper "basic"

$digit = 0-9    -- NODE VALUE

tokens :-

-- Each action has type :: String -> Token

$digit+    { \s -> Int (read s) }
\<         { \s -> OpenF }
\>         { \s -> CloseF }
\,         { \s -> Sep }
$white+ ;

{

data Token =
  Int Int   |
  OpenF     |
  CloseF    |
  Sep
  deriving (Eq, Show)


main =
  do s <- getContents
     print (alexScanTokens s)
}
