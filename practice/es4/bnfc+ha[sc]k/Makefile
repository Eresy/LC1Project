BNFC = bnfc
ALEX = alex -g
HAPPY= happy -gca
GHC  = ghc --make


Source = $(patsubst %.y,%.hs,$(wildcard *.y)) $(patsubst %.x,%.hs,$(wildcard *.x))

.PHONY : all

all:  $(Source) 
#	ghc --make Test%.hs 
	
%.hs: %.x
	$(ALEX) -i$*.alexlog  $<
%.hs: %.y
	$(HAPPY) -i$*.happylog $<

clean :
	rm -f *.o *.hi
	
distclean : clean
	rm -f *.hs *.txt *.alex* *.happy*
	
