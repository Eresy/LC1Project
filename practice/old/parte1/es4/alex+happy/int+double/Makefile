ALEX = alex -g
HAPPY= happy -gca
GHC  = ghc --make


generatedHS = $(patsubst %.y,%.hs,$(wildcard *.y)) $(patsubst %.x,%.hs,$(wildcard *.x))

.PHONY : all

all:  $(generatedHS) 
	ghc --make Main.hs -o Main
	
%.hs: %.x
	$(ALEX)  $<
%.hs: %.y
	$(HAPPY) $<

clean :
	rm -f *.o *.hi
	
distclean : clean
	rm -f [PL]*.hs Main
	
