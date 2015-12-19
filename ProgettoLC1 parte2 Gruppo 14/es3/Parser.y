%{

#include "Parser.h"
#include "ABS.c"
#include <stdio.h>

/*Numero di linee e colonne correnti del lexer*/
extern int nline;
extern int ncolumn;

/*Puntatori alla struttura:*/
Section *global = NULL;
Command *local = NULL;
Section *prevS = NULL;
Command *prevC = NULL;

/*Funzione di errore che di base fornisce la posizione del lexer*/
void yyerror(char const *str){	
	fprintf(stderr, "[%i:%i] %s\n", nline, ncolumn, str);
}

void main(int argc, char **argv){
	if( yyparse() == 0)
		printSections( global );
}

%}

/*Aumento la verbosità dei messaggi di errore del parser e le location dei token*/
%define parse.error verbose
%locations

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

Section 	:	OPENSEC LABEL CLOSESEC Declarations	{	/* controllo delle duplicazioni */
									if( sectionNameError(global, $2, @2.first_line, @2.first_column) ){
										YYERROR;
									}
									/* creo la singola sezione */
									Section *a = newSection( $2, @2.first_line , @2.first_column );
									if( local != NULL ){
										a = addCommands( a , local );	/* aggancio la lista di comandi alla sezione */
									}					/* in ordine, prima il parser crea la lista, poi la sezione a cui riferiscono */
									if ( prevS != NULL ){ 
										addSection( prevS , a ); /* la concateno alla sez. precedente se esiste */
										prevS = a;
										
									}else{ 
										global = prevS = a; /* altrimenti se il precedente non esiste allora è la prima sezione */
									}
									local = NULL; /* pulizia per un nuovo corpo di sezione */
									prevC = NULL;
								};

Declarations	:	Declaration Declarations	{ } 
			|	{ };
				
Declaration	:	LABEL BIND Rvalue	{
							/* gestisco warning vari per le redifinizioni */
							localNameWarning(local, $1, @1.first_line, @1.first_column);
							Command *a = newCommand( $1, $3 );
							if( prevC != NULL ){	/* aggiungo il comando creato al precedente */
								addCommand( prevC, a);
								prevC = a;
							}else{
								local = prevC = a; /* se il precedente non esiste allora è il primo */
							}
						}
			| COMMENT	{ 
						char *cmt = "#"; /* i commenti sono inseriti nella struttura dati con simbolo riservato nella label*/
						Command *a = newCommand( cmt, $1 );
							if( prevC != NULL ){	/* stesso ragionamento come sopra */
								addCommand( prevC, a);
								prevC = a;
							}else{
								local = prevC = a;
							}
					};

Rvalue		:	INT		{ $$ = $1; }
			| STRING	{ $$ = $1; }
			| BOOL		{ $$ = $1; }
			| REFERENCE LABEL DOT LABEL	{ 	/* Per un riferimento, faccio il fetch della variabile, con errore irreversibile se non esiste */
								char *c = commandValueSearch( sectionSearch( global, $2 ), $4 );
								if(c != NULL){
									$$ = c;
								}else{
									char buf[50];
									sprintf(buf, "FATAL: Variable \"%s.%s\" does not exist\n", $2, $4);
									yyerror( buf );
									YYERROR;
								}
							} 
			| REFERENCE LABEL	{ 	/* stesso ragionamento */
							char *c = commandValueSearch( local, $2);
							if(c != NULL){
								$$ = c;
							}else{
								char buf[50];
								sprintf(buf, "FATAL: Variable \"%s\" does not exist\n", $2);
								yyerror( buf );
								YYERROR;
							}
						};
