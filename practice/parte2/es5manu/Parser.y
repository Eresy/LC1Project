%{

//#include "Parser.h"

#define YYSTYPE char *

extern int nlines;
extern int ncolumn;

void yyerror(const char *str){	
	printf("Parse Error at (%i:%i): %s", nlines, ncolumn, str);
}

void main(int argc, char **argv){
	/*argc--;
	argv++;
	if ( argc > 0 ){
		yyin = fopen( argv[0], "r" );
	}else{
		yyin = stdin;
	}*/
	yyparse();
}


%}

%define parse.error verbose

%token INT STRING BOOL LABEL
%token BIND "="
%token SEMICOLON ";"
%token OPENSEC "[" 
%token CLOSESEC "]"
%token COMMENT "#"

%%

Sections	:	|
				Sections Section {}

Section 	:	SectionName Declarations {}

SectionName	:	OPENSEC LABEL CLOSESEC {}

Declarations:	{} |
				Declarations Declaration {} |
				COMMENT Declarations {}

Declaration	:	LABEL BIND Rvalue SEMICOLON {}

Rvalue		:	INT {} |
				STRING {} |
				BOOL {}
