%option noyywrap

%{

#include "Parser.h"

/* punto dell'input in cui è arrivato il lexer */
int ncolumn = 1;
int nline = 1;

/* questa è l'azione di default che viene eseguita prima del riconoscimento di un token */
/* viene usata per aggiornare lo struct della posizione cosicchè il parser possa assegnare*/
/* le coordinate giuste ai token nell'input stream. */

#define YY_USER_ACTION	ncolumn += yyleng; \
			yylloc.first_line = yylloc.last_line = nline;\
			yylloc.first_column = ncolumn - yyleng ; yylloc.last_column = ncolumn;

%}

CHAR	[a-zA-Z]
NUM 	[0-9]
WHITE	[ \t]

%%

\[	{ return OPENSEC; }

\]	{ return CLOSESEC; }

(true|false)		{ yylval.str = strdup( yytext ); return BOOL; }

{CHAR}+({CHAR}|{NUM})*	{ yylval.str = strdup( yytext ); return LABEL; }

\"{CHAR}+\"		{ yylval.str = strdup( yytext ); return STRING; }

{NUM}+			{ yylval.str = strdup( yytext ); return INT; }

\$			{ return REFERENCE;}

\=			{ return BIND; }

\.			{ return DOT; }

\n			{ ncolumn = 1; nline++; }

#.*			{ yylval.str = strdup( yytext ); return COMMENT; }

{WHITE}+		%{/* WHITESPACE */%}

.			{ printf( "Scan Error at (%i:%i), Unrecognized character or pattern: %s\n" , yylineno, ncolumn, yytext ); }

%%

