{
--Parser per la grammatica ad alberi di Double

module ParserD (main) where

--Importo dal lexer di Alex la funzione di scan, poi i token e il tipo 
--di sintassi astratta. Nota bene come prendo anche i costruttori del datatype dei token

import Lexer (alexScanTokens)
import Data (Token(..), Tree(..))

}

--Definizione nome della funzione di parsing, nome del datatype dei token
--e il nome della funzione di errore

%name parseDoubleTree
%tokentype { Token }
%error     { parseError }

--Definisco alias per i costruttori del datatype def. prima

%token
	int		{ Int $$ }
	double	{ Double $$ }
	open	{ ListOpen }
	close	{ ListClose }
	sep		{ Separator }

%% --Begin BNF 

--Lista di produzioni che definiscono la mia grammatica, dove i terminali
--sono i token ricevuti e le produzioni sono definite da variabili a sx. Una funzione
--haskell a dx fra graffe per definire cosa restituisco quando riconosco la produzione,
--$x dove x è [0-9] è la notazione posizionale dell'elemento in pos. x nella prod. e
--restituisce il primo dato nel costruttore del token oppure, se una produzione,
--un dato composito (tipo lista) creato dalle produzioni consecutive.

TreeD		:	Num ChildsD                 { Node (detWeight $2) $1 $2 }
TreeD		:	Num	                        { Leaf 0 $1 }
Num			:	int                         { (read $1 :: Double) } 
            |   double                      { (read $1 :: Double) } --Un Int può essere rappresentato anche con un Double!
ChildsD		:	open TreeD MoreChD close    { $2 : $3 }
MoreChD		:	sep TreeD MoreChD           { $2 : $3 } 
            |   {-empty-}                   { [] }

{

detWeight :: Ord x => [Tree x] -> Integer
detWeight a = (getWeight (foldl1 (max) a)) + 1
 where getWeight (Node x _ _) = x
       getWeight (Leaf _ _) = 0

parse = parseDoubleTree . alexScanTokens

main = do
 x <- getContents
 mapM_ (print . parse) (lines x)



parseError :: [Token] -> a
parseError _ = error "Parse error"

}
