ALEX = alex -g
HAPPY= happy -gca
GHC  = ghc

SRC= $(patsubst %.y,%.hs,$(wildcard *.y)) $(patsubst %.x,%.hs,$(wildcard *.x))

LIST= ParserD ParserI TestSymm

all: $(SRC)
	for i in $(LIST); do \
	$(GHC) -w -main-is $$i  $$i.hs; \
	done

testsymm: Lexer.hs ParserI.hs TestSymm.hs
	$(GHC) -w -main-is TestSymm --make TestSymm.hs

demo: testsymm
	cat ./examples.txt | ./TestSymm

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
