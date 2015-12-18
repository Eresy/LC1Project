%{

#include "Parser.h"
#include "ABS.c"
#include <stdio.h>

extern int yylineno;
extern int ncolumn;
extern Section *global;
extern Section *local;

void yyerror(const char *str){	
	printf("Parse Error at (%i:%i): %s\n", yylineno, ncolumn, str);
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
%token <str> REFERENCE
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
%type <str> SectionName

%%

Sections	:	 { printf("SectionsNULL\n"); $$ = NULL; } |
			Section Sections { printf("--Sections\n"); if($2 != NULL) $$ = addSection($1, $2); }

Section 	:	SectionName Declarations {  printf("--Section\n"); if($2 != NULL) $$ = addCommands( newSection( $1 ), $2); }

SectionName	:	OPENSEC LABEL CLOSESEC { $$ = $2; }

Declarations	:	 {  printf("--DeclarationsNULL\n"); $$ = NULL;} |
			Declaration Declarations { printf("--Declarations\n"); if($2 != NULL) $$ = addCommand( $2 , $1 ); }

Declaration	:	LABEL BIND Rvalue { printf("--Declaration\n"); $$ = newCommand($1, $3); } |
			COMMENT { char cmt = '#'; $$ = newCommand( &cmt, $1 ); }

Rvalue		:	INT { $$ = $1; } |
			STRING { $$ = $1; } |
			BOOL { $$ = $1; } |
			REFERENCE LABEL DOT LABEL { commandValueSearch( sectionSearch( global, $2 ), $4 ); } |
			REFERENCE LABEL { commandValueSearch( local , $2 ); }
