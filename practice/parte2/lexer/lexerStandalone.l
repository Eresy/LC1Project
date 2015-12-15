%{

#include <stdio.h>

#define YYSTYPE char *

#define YYTOKENTYPE
	enum yytokentype {
		INTERO = 258,
		VIRMOB = 259,
		LETTERE = 260,
		ID = 261,
		SEPARATORE = 262,
	};

%}

%option noyywrap

%%

[0-9]+				{return INTERO;}
[0-9]+\.[0-9]+		{return VIRMOB;}
[a-zA-Z]+			{return LETTERE;}
\,					{return SEPARATORE;}

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
