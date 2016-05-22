ALEX = alex -g
HAPPY= happy -gca
GHC  = ghc

SRC= $(patsubst %.y,%.hs,$(wildcard *.y)) $(patsubst %.x,%.hs,$(wildcard *.x))


all: $(SRC)
	$(GHC) Parser.hs

#testsymm: Lexer.hs ParserI.hs TestSymm.hs
#	$(GHC) -w -main-is TestSymm --make TestSymm.hs

#demo: testsymm
#	cat ./examples.txt | ./TestSymm

%.hs: %.x
	$(ALEX)  $<
%.hs: %.y
	$(HAPPY) $<

clean :
	echo cleaning
	-rm -f *.o *.hi

distclean : clean
	echo cleaning all
	-rm -f $(SRC) 

.PHONY: all clean distclean demo
