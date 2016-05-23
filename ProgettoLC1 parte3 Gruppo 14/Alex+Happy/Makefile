ALEX = alex -g
HAPPY= happy -gca
GHC  = ghc

SRC= $(patsubst %.y,%.hs,$(wildcard *.y)) $(patsubst %.x,%.hs,$(wildcard *.x))


all: $(SRC)
	$(GHC) Parser.hs -o subChapel
SubC: all

demo: SubC
	for i in ./test/* ; do \
		./subChapel < $$i; \
	done

%.hs: %.x
	$(ALEX)  $<
%.hs: %.y
	$(HAPPY) $<

clean :
	echo cleaning
	-rm -f *.o *.hi

distclean : clean
	echo cleaning all
	-rm -f $(SRC) subChapel 

.PHONY: all clean distclean demo
