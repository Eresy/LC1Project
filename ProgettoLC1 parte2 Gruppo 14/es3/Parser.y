%{

#include "Parser.h"
#include "ABS.c"
#include <stdio.h>

extern int nline;
extern int ncolumn;

Section *global = NULL;
Command *local = NULL;
Section *prevS = NULL;
Command *prevC = NULL;

void yyerror(char const *str){	
	fprintf(stderr, "Parse Error at  %s\n", str);
}

void main(int argc, char **argv){
	if( yyparse() == 0)
		printSections( global );
}

%}

%define parse.error verbose

%union{
	struct Section *sec;
	struct Command *cmd;
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

Sections	:	Section Sections	{ };
			|	{ };

Section 	:	OPENSEC LABEL CLOSESEC Declarations	{	
									//printf("--Section, local=%i\n", local != NULL);
									if( sectionNameError(global, $2) ){
										YYERROR;
									}
									Section *a = newSection( $2, nline, ncolumn );
									if( local != NULL ) 
										a = addCommands( a , local );
									if ( prevS != NULL ){ 
										addSection( prevS , a );
										prevS = a;
										
									}else{ 
										global = prevS = a;
									}
									local = NULL;
									prevC = NULL;
								};

Declarations	:	Declaration Declarations	{ } 
			|	{ };
				
Declaration	:	LABEL BIND Rvalue	{
							//printf("--Declaration\n");
							localNameWarning(local, $1, nline, ncolumn);
							Command *a = newCommand( $1, $3 );
							if( prevC != NULL ){
								addCommand( prevC, a);
								prevC = a;
							}else{
								local = prevC = a;
							}
						}
			| COMMENT	{ 
						//printf("--Comment\n");
						char *cmt = "#";
						Command *a = newCommand( cmt, $1 );
							if( prevC != NULL ){
								addCommand( prevC, a);
								prevC = a;
							}else{
								local = prevC = a;
							}
					};

Rvalue		:	INT		{ $$ = $1; }
			| STRING	{ $$ = $1; }
			| BOOL		{ $$ = $1; }
			| REFERENCE LABEL DOT LABEL	{ 
								//printf("Riferimento %s contenuta in %s \n", $4, $2);
								$$ = commandValueSearch( sectionSearch( global, $2 ), $4 );
							} 
			| REFERENCE LABEL	{ 
							//printf("Riferisco %s contenuta in %s\n", $2, local -> label);
							$$ = commandValueSearch( local, $2);
						};
