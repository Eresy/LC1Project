--implementazione di oneOf della libreria Parsec
oneOf :: Eq a => [a] -> [a] -> Bool
oneOf char lst = char == (take 1 lst) || (oneOf char (drop 1 lst))

whites = ['\n','\t',' ']
letters= ['a'..'z']++['A'..'Z']
punct  = [',','<','>']
num = ['0'..'9']

isChar :: String -> [Char] -> Bool
isChar str chr = (elem (head str) chr) && (isChar (drop 1 str) chr)


