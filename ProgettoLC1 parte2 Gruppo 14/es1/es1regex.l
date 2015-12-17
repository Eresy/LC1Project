%{

#include <stdio.h>

#define YYSTYPE char *

#define YYTOKENTYPE
	enum yytokentype {
		COGNOME = 258,
		NOME = 259,
		DATA = 260,
		MATRICOLA = 261,
		WHITESPACE = 262,
		COMMENTI = 263,
	};

%}

%option noyywrap

COGNOME		[a-zA-Z\-\']+
NOME		([a-zA-Z\-])+([ ]+[a-zA-Z\-]+)*
GIORNO		(0[1-9])|([1-2][0-9])|(3[0-1])
MESE		(0[1-9])|(1[0-2])
ANNO		([0-9][0-9])
SEP		"/"
MATRICOLA	([0-9]+){6}
WHITESPACE	[ ]+
COMMENTI	.*

%%

{COGNOME}{WHITESPACE}{NOME}{WHITESPACE}{GIORNO}{SEP}{MESE}{SEP}{ANNO}{WHITESPACE}{MATRICOLA}{WHITESPACE}{COMMENTI} { return 1; }

%%

void main(int argc, char **argv){
	argc--;
	argv++;
	if ( argc > 0 ){
		yyin = fopen( argv[0], "r" );
	}else{
		yyin = stdin;
	}
	int curTok;
	while( (curTok = yylex()) > 0){
		printf( "\n(%i)" , curTok );
		printf( "\n%s",yytext);
	}
}
