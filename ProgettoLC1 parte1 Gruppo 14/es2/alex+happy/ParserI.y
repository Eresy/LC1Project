{
--Parser per la grammatica ad alberi di Int

module ParserI (main) where

--Importo dal lexer di Alex la funzione di scan, poi i token e il tipo 
--di sintassi astratta. Nota bene come prendo anche i costruttori del datatype dei token

import Lexer (alexScanTokens)
import Data (Token(..), Tree(..))

}

--Definizione nome della funzione di parsing, nome del datatype dei token
--e il nome della funzione di errore

%name parseIntTree
%tokentype { Token }
%error     { parseError }

--Definisco alias per i costruttori del datatype def. prima

%token
	int		{ Int $$ }
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

TreeD		:	Num ChildsD               { Node (detWeight $2) $1 $2 }
TreeD		:	Num	                      { Leaf 0 $1 }
Num			:	int                       { (read $1 :: Int) }
ChildsD		:	open TreeD MoreChD close  { $2 : $3 }
MoreChD		:	sep TreeD MoreChD         { $2 : $3 } 
            |   {-empty-}                 { [] }

{

detWeight :: Ord x => [Tree x] -> Integer
detWeight a = (getWeight (foldl1 (max) a)) + 1
 where getWeight (Node x _ _) = x
       getWeight (Leaf _ _) = 0

--Determina se l'albero passato è simmetrico
isSymm :: Tree x -> Bool
isSymm x = case x of
 (Leaf _ _) -> True
 a@(Node _ _ xs) -> isEq a (trasp a)
 
--Funzione per l'equivalenza strutturale di alberi qualsiasi
isEq :: Tree x -> Tree x -> Bool
isEq (Leaf _ _) (Leaf _ _) = True
isEq (Node _ _ _) (Leaf _ _) = False
isEq (Leaf _ _) (Node _ _ _) = False
isEq (Node _ _ x) (Node _ _ y) 
 | length x == length y = foldl1 (&&) (zipWith (isEq) x y)
 | otherwise = False
 
--Calcola la trasposizione dell'albero
trasp :: Tree x -> Tree x
trasp a@(Leaf _ _ ) = a
trasp (Node a b c) =  (Node a b (reverse (map (trasp) c)))

test = isSymm . parseIntTree . alexScanTokens
parse = parseIntTree . alexScanTokens

main = do
 x <- getContents
 print (parseIntTree (alexScanTokens x))
 print (trasp (parse x))
 print (test x)

--E` molto bare, non serve tanto se il lexer non e` posn, però deve esserci per compilare bene

parseError :: [Token] -> a
parseError _ = error "Parse error"

}
