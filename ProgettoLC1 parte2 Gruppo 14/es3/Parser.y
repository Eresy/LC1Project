%{

#include "Parser.h"
#include "ABS.c"
#include <stdio.h>

extern int yylineno;
extern int ncolumn;

Section *global = NULL;
Command *local = NULL;
Section *returnAST = NULL;

void yyerror(const char *str){	
	printf("Parse Error at (%i:%i): %s\n", yylineno, ncolumn, str);
}

void main(int argc, char **argv){
	yyparse();
	
	printSections( returnAST );
	
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
%token <str> REFERENCE "$"
%token DOT "."
%token BIND "="
%token OPENSEC "[" 
%token CLOSESEC "]"
%token END 0 "end of file"

%type <sec> Sections 
%type <sec> Section
%type <cmd> Declarations
%type <cmd> Declaration
%type <str> Rvalue

%%

Sections	:	Section Sections { printf("--Sections\n"); if($2 != NULL) $$ = returnAST = addSection($1, $2); } |
			  { printf("--SectionsNULL\n"); $$ = NULL; }

Section 	:	OPENSEC LABEL CLOSESEC Declarations {  printf("--Section\n"); Section *a = newSection( $2 ); local = NULL; if(global == NULL)global = a; if($4 != NULL) $$ = addCommands( a , $4); }

Declarations	:	 {  printf("--DeclarationsNULL\n"); $$ = NULL;} |
			Declaration Declarations { printf("--Declarations\n"); if($2 != NULL) $$ = addCommand( $1 , $2 ); }

Declaration	:	LABEL BIND Rvalue { printf("--Declaration\n"); Command *a = newCommand($1, $3); if(local == NULL)local = a; $$ = a;} |
			COMMENT { printf("--Declaration#\n"); char cmt = '#'; $$ = newCommand( &cmt, $1 ); }

Rvalue		:	INT { $$ = $1; } |
			STRING { $$ = $1; } |
			BOOL { $$ = $1; } |
			REFERENCE LABEL DOT LABEL { printf("Riferimento %s contenuta in %s \n", $4, $2); $$ = $2 } |
			REFERENCE LABEL { printf("Riferisco %s contenuta in %s\n", $2, local -> label); $$ = $2 }
