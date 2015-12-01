
Main : Lexer.hs ParserI.hs ParserD.hs
	ghc --make Main.hs

Lexer.hs : 
	alex Lexer.x

ParserI.hs :
	happy ParserI.y

ParserD.hs :
	happy ParserD.y
	
clean :
	rm *.o *.hi
	
reset :
	rm *.o *.hi Lexer.hs ParserI.hs ParserD.hs Main
	
