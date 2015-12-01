{
--Parser standalone per la grammatica ad alberi di interi
module Main(main) where

--Importo dal lexer di Alex la funzione di scan e i token: molto importante!!
 --Nota bene come prendo anche i costruttori del datatype dei token
import Lexer (alexScanTokens, Token(..))

}

--Definizione nome della funzione di parsing, nome del datatype dei token
--e il nome della funzione di errore
%name parseIntTree
%tokentype { Token }
%error { parseError }

--Definisco alias per i costruttori del datatype def. prima
%token
	int		{ Int $$ }
	open	{ TreeOpen }
	close	{ TreeClose }
	sep		{ Separator }

%% --Begin BNF :D

--Lista di produzioni che definiscono la mia grammatica, dove i terminali
--sono i token ricevuti e le produzioni sono definite da variabili a sx. Una funzione
--haskell a dx fra graffe per definire cosa restituisco quando riconosco la produzione,
--$x dove x è [0-9] è la notazione posizionale dell'elemento in pos. x nella prod. e
--restituisce il primo dato nel costruttore del token oppure, se una produzione,
--un dato composito (tipo lista) creato dalle produzioni consecutive.
TreeI		:	int ChildsI { ITree $1 $2 }
TreeI		:	int	{ ILeaf $1 }
ChildsI		:	open TreeI MoreChI close { $2 : $3 }
MoreChI		:	sep TreeI MoreChI { $2 : $3 } | { [] } 

{

--Definisco il tipo di dato che rappresenta più da vicino l'albero di sintassi astratta
data IntTree = ITree Int [IntTree] | ILeaf Int deriving (Show)

--Il main non è fondamentale, basta esportare la funz. di parsing all'esterno ad un altro Main
main = do
 x <- getContents
 print (parseIntTree (alexScanTokens x))

--E` molto bare, non serve tanto se il lexer non e` posn, però deve esserci per compilare bene
parseError :: [Token] -> a
parseError _ = error "Parse error"

}
