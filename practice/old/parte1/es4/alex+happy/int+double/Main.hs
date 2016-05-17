
module Main (main) where

--Importo tutto quello che sta` in parsers/lexer
import Lexer (alexScanTokens, Token(..))
import ParserI (parseIntTree, IntTree(..), parseError)
import ParserD (parseDoubleTree, DoubleTree(..))

--data Either a b = Left a | Right b
--either :: (a -> c) -> (b -> c) -> Either a b -> c
--Quindi seleziona uno dei due e applica:
--se Either a b è Left a, allora applica (a -> c) a
--se Either a b è Right b allora applica (b -> c) b
main = do
 x <- getContents
 (either (print) (print) (parse (alexScanTokens x)))
 
--La magia dell'either! Non si possono restituire dati di due tipi diversi,
--quindi si usa Either per incapsulare entrambi allo stesso tempo, ma alla fine ho uno o l'altro.
--Nel main eseguo il print di quella che occorre, visto che print è una monad non gli interessa
--che il tipo restituito da parse sia di un tipo o un altro, ma solo che derivi Show.
parse :: [Token] -> Either IntTree DoubleTree 
parse a@(x:_) = case x of
  (Int _) -> Left (parseIntTree a)
  (Double _) -> Right (parseDoubleTree a)
  _ -> parseError a
--nella versione precedente usavo show al posto di print e printavo gli show, ma mi davano fastidio le \"\"
--Si dovrà usare annotate discriminando se è Left o Right...complicazione, ma non ho idea per ora di come semplificare

