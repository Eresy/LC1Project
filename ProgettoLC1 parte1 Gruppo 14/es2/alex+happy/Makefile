ALEX = alex -g
HAPPY= happy --gca
GHC  = ghc

generatedHS = $(patsubst %.y,%.hs,$(wildcard *.y)) $(patsubst %.x,%.hs,$(wildcard *.x))

all: Lexer.hs ParserI.hs ParserD.hs
	ghc -w -main-is $@ --make $<
#	ghc -w -main-is ParserD --make ParserD.hs
#	ghc -w -main-is TestSymm --make TestSymm.hs
%.hs: %.x
	$(ALEX)  $<
%.hs: %.y
	$(HAPPY) $<


%.hs : %.x
	alex Lexer.x

%.hs : %.y
	happy ParserD.y
	
clean :
	-rm -f *.o *.hi
	
distclean : clean
	-rm -f Lexer.hs ParserI.hs ParserD.hs ParserD ParserI
