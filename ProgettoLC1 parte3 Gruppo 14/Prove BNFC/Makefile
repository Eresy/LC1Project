all:
	happy -gca ParBnfcProva.y
	alex -g LexBnfcProva.x
	ghc --make TestBnfcProva.hs -o TestBnfcProva

clean:
	-rm -f *.log *.aux *.hi *.o *.dvi

distclean: clean
	-rm -f DocBnfcProva.* LexBnfcProva.* ParBnfcProva.* LayoutBnfcProva.* SkelBnfcProva.* PrintBnfcProva.* TestBnfcProva.* AbsBnfcProva.* TestBnfcProva ErrM.* SharedString.* ComposOp.* bnfcProva.dtd XMLBnfcProva.* Makefile*
	

