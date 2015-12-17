%{
#include <stdio.h>

#define YYSTYPE char *

#include "Parser.h"

extern int yylineno;
extern char yytext;

void yyerror(char *str){	
	printf("%d: %s at %s \n",yylineno,str,yytext);
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
				STRING {printf("%s",$1);} |
				BOOL {}
