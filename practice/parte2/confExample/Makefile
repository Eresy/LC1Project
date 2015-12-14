base = Conf

LEX = flex -P$(base)_
YACC = bison -vdt -p$(base)_
CC = gcc -Wall

generatedC    = $(base)Lexer.c $(base)Parser.c
generatedH    = $(base)Parser.h
generated     = $(generatedC) $(generatedH)

all: $(generated) test$(base)

test: test$(base)
	./test$(base) < example.conf

clean:
	-rm -fv *.o *.log *.output

cleanGen:
	-rm -fv *.h *.c $(generated)

distclean: clean cleanGen
	-rm -fv test$(base)*

%Lexer.c: %Lexer.l %Parser.h
	$(LEX) -o $@ $<

%Parser.c %Parser.h: %Parser.y
	$(YACC) $< -o $*Parser.c 

test%: %Lexer.o %Parser.o
	@echo "Linking $@..."
	$(CC) $^ -o $@

%Lexer.o: %Lexer.c %Parser.h
	$(CC) -c $<

%Parser.o: %Parser.c
	$(CC) -c $<
.PHONY : all test clean cleanGen distclean
