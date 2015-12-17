%{

#include <stdio.h>

#define YYSTYPE char *

#define YYTOKENTYPE
	enum yytokentype {
		COGNOME = 258,
		NOME = 259,
		DATA = 260,
		MATRICOLA = 261,
		COMMENTI = 262,
	};

%}

%option noyywrap

COGNOME		[a-zA-Z\-\']+[ ]+
NOME		[a-zA-Z\-]+([ ]+[a-zA-Z\-]+){1,}[ ]+
DATA		(([0]?[0-9])|([1-3][0-9]))"/"(([0]?[0-9])|([1-3][0-9]))"/"(([0]?[0-9])|([1-9][0-9]))[ ]+
MATRICOLA	([0-9]+){6}[ ]+
COMMENTI	.*

%%

{COGNOME}{NOME}{DATA}{MATRICOLA}{COMMENTI}	{ return 1; }

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
		printf( "(%i)" , curTok );
	}
}
