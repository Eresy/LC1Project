GCC = gcc -Wall
BIS = bison -vdt
FLEX = flex

cfiles = Parser.c Lexer.c
hfiles = Parser.h
gen = $(cfiles) $(hfiles)

all: $(gen) test
	
clean:
	-rm -fv *.o *.log *.output
	
cleangen:
	-rm -fv $(gen)

distclean: clean cleangen
	-rm -fv test

Lexer.c: Lexer.l
	$(FLEX) -o $@ $<

Parser.c Parser.h: Parser.y
	$(BIS) $< -o $@

test: Lexer.o Parser.o
	$(GCC) $^ -o $@

Lexer.o: Lexer.c Parser.h
	$(GCC) -c $<

Parser.o: Parser.c ABS.c
	$(GCC) -c $<

ABS.c: 
	$(GCC) -c ABS.c

.PHONY : all test clean cleangen distclean
