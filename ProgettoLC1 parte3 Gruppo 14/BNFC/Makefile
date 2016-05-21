all:
	happy -gca ParChapel.y
	alex -g LexChapel.x
	ghc --make TestChapel.hs -o TestChapel

clean:
	-rm -f *.log *.aux *.hi *.o *.dvi

distclean: clean
	-rm -f DocChapel.* LexChapel.* ParChapel.* LayoutChapel.* SkelChapel.* PrintChapel.* TestChapel.* AbsChapel.* TestChapel ErrM.* SharedString.* ComposOp.* chapel.dtd XMLChapel.* Makefile*
	

