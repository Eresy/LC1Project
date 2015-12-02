
make : Lexer.hs ParserI.hs ParserD.hs
	ghc -w -main-is ParserI --make ParserI.hs
	ghc -w -main-is ParserD --make ParserD.hs

Lexer.hs : 
	alex Lexer.x

ParserI.hs :
	happy ParserI.y

ParserD.hs :
	happy ParserD.y
	
clean :
	-rm -f *.o *.hi
	
reset :
	-rm -f *.o *.hi Lexer.hs ParserI.hs ParserD.hs ParserD ParserI
