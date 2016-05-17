%{

#include "Parser.h"
#include "ABS.c"
#include <stdio.h>

extern int nlines;
extern int ncolumn;

void yyerror(const char *str){	
	printf("Parse Error at (%i:%i): %s\n", nlines, ncolumn, str);
}

void main(int argc, char **argv){
	yyparse();
}


%}

%define parse.error verbose

%union{
	struct Section *sec;
	struct Command *cmd;
	struct Value *val;
	char *str;
}

%token <str> INT
%token <str> STRING
%token <str> BOOL
%token <str> LABEL
%token <str> COMMENT
%token BIND "="
%token SEMICOLON ";"
%token OPENSEC "[" 
%token CLOSESEC "]"

%type <sec> Sections
%type <sec> Section
%type <cmd> Declarations
%type <cmd> Declaration
%type <str> Rvalue
%type <str> SectionName

%%

Sections	:	{ $$ = (void *)0; } |
			Section Sections { $$ = addNextSections($1, $2); }

Section 	:	SectionName Declarations { $$ = addCommandList( newSection( $1 ), $2); }

SectionName	:	OPENSEC LABEL CLOSESEC { $$ = $2; }

Declarations	:	{ $$ = (void *)0; } |
			Declaration Declarations { $$ = addNextCommands($2, $1); }

Declaration	:	LABEL BIND Rvalue SEMICOLON { $$ = newCommand($1, $3); } |
			COMMENT {$$ = newCommand( (char *)'#', $1 ); }

Rvalue		:	INT { $$ = $1; } |
			STRING { $$ = $1; } |
			BOOL { $$ = $1; }
	
