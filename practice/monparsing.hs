{--
 - Monadic parsing based on "Functional Pearls: Monadic Parsing in Haskell" by Hutton&Meijer
 --}

{-- parser for `a'
 - i.e.
 - takes an input string
 - yields pairs of results A and REMAINING input string
 - produces a list of Alternative Parsings (possible empty)
 -
 - parser failure ==> empty list
 - parser success ==> non-empty list
 --}
newtype Parser a = Parser (String -> [(a,String)])

--run parser on a input string
parse :: Parser a -> String -> [(a,String)]
parse (Parser f) = f

--Example: parser that consumes the single next character
--e.g. usage: parse next "super"
--result: [('s',"uper")]
next :: Parser Char
next = Parser (\cs -> case cs of
                      "" -> []
                      (c:cs) -> [(c,cs)])
--end example

--we made the type constructor Parser in an istance of the 
--Monad class
--         i.e. (
--              class Monad m where
--                return :: a -> m a
--                (>>=)  :: m a -> (a -> m b) -> m b
--              )

instance Monad Parser where
  return a = Parser (\cs -> [(a,cs)]
  p >>=  f = Parser (\cs -> concat [parse (f a) cs' | (a,cs') <- parse p cs])

{--
 - Failure and Choice
 -
 - mzero is a parser that always fails, build upon a
 - Monad with a zero:
 -  Haskell built-in  class Monad m => MonadZero m where
 -                    zero :: m a
 -  that is, a type constructor m is a member of the class MonadZero if it is a 
 -  member of the class Monad AND if it is also equipped with a value Zero of the specified type.
 -  
 -  mplus tries two parsers in alternative, based on a
 -   Monad with a zero and a plus:
 -  Haskell built-in class MonadZero m => MonadPlus m where
 -                    (++) :: m a -> m a -> m a
 - similarly, MonadPlus builds upon the class MonadZero by adding a (++) operation of the specified type.
 --}

-- The type constructor Parser can be made into instances of these 2 classes as follows:
instance MonadZero Parser where
  zero = Parser (\cs -> [])

instance MonadPlus Parser where
  p ++ q = Parser (\cs -> parse p cs ++ parse q cs)

{-- parser zero fails for all arguments strings returning no results.
 - the (++) is a NON-DETERMINISTIC CHOICE operator for parsers:
 - the parser p ++ q applies BOTH parsers p AND q to the argument string
 - and appends THEIR list of results.
 - --}
--to be continued
