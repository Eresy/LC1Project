GCC = gcc
BIS = bison -vdt
FLEX = flex

cfiles = Parser.c Lexer.c
hfiles = Parser.h
gen = $(cfiles) $(hfiles)

all: $(gen) Es3

demo: all
	@echo -e "\nTesting conf with no errors\n"
	./Es3 < example.conf
	@echo -e "\nTesting another conf with no errors\n"
	./Es3 < example-2.conf
	@echo -e "\nTesting conf with Incorrect variable assignment \n"
	./Es3 < example-warn.conf
	@echo -e "\nTesting conf with Multiple sections assignment \n"
	-./Es3 < example-err.conf
	#ritorna errore, lo facciamo ignorare a make 
	#in modo che continui
clean:
	rm -f *.o *.log *.output
	
cleangen:
	rm -f $(gen)

distclean: clean cleangen
	rm -f Es3

Lexer.c: Lexer.l
	$(FLEX) -o $@ $<

Parser.c Parser.h: Parser.y
	$(BIS) $< -o $@

Es3: Lexer.o Parser.o
	$(GCC) $^ -o $@

Lexer.o: Lexer.c Parser.h
	$(GCC) -c $<

Parser.o: Parser.c ABS.c
	$(GCC) -c $<

ABS.c: 
	$(GCC) -c ABS.c

.PHONY : all clean cleangen distclean demo
