ALEX = alex -g
HAPPY= happy -gca
GHC  = ghc

SRC= $(patsubst %.y,%.hs,$(wildcard *.y)) $(patsubst %.x,%.hs,$(wildcard *.x))


all: $(SRC) 
	$(GHC) -w -main-is ParserI --make ParserI.hs
	$(GHC) -w -main-is ParserD --make ParserD.hs
	$(GHC) -w -main-is TestSymm --make TestSymm.hs

demo: TestSymm


%.hs: %.x
	$(ALEX)  $<
%.hs: %.y
	$(HAPPY) $<

clean :
	echo cleaning
	-rm -f *.o *.hi

distclean : clean
	echo cleaning all
	-rm -f $(SRC) ParserD ParserI TestSymm

.PHONY: all clean distclean demo
