GCC = gcc
BIS = bison -vdt
FLEX = flex

cfiles = Parser.c Lexer.c
hfiles = Parser.h Lexer.h
gen = $(cfiles) $(hfiles)

all: $(gen) test

test : test
	./test | echo "asd"
	
clean:
	-rm -fv *.o *.log *.output
	
cleangen:
	-rm -fv $(gen)

distclean: clean cleangen
	-rm -fv test

%Lexer.c: Lexer.l Parser.h
	$(FLEX) -o $@ $<

%Parser.c %Parser.h: %Parser.y
	$(BIS) $< -o $*Parser.c
	
%tokdef.h: %Parser.y
	%(YACC) $< -o 

test%: %Lexer.o %Parser.o
	$(GCC) $^ -o $@

%Lexer.o: %Lexer.c %Parser.h
	$(GCC) -c $<

%Parser.o: %Parser.c
	$(GCC) -c $<

.PHONY : all test clean cleangen distclean
