ALEX = alex -g
HAPPY= happy -gca
GHC  = ghc

SRC= $(patsubst %.y,%.hs,$(wildcard *.y)) $(patsubst %.x,%.hs,$(wildcard *.x))



.PHONY: all
all: %.hs
#	@echo $(SRC)
#	@echo $<
	ghc -w -main-is $@ --make $(SRC)


%.hs: %.x
	$(ALEX)  $<
%.hs: %.y
	$(HAPPY) $<

.PHONY: clean
clean :
	-rm -f *.o *.hi
	
.PHONY: distclean
distclean : clean
	-rm -f [LP]*.hs ParserD ParserI TestSymm
