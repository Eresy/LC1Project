%option noyywrap yylineno

%{

#include "Parser.h"

int ncolumn = 1;

#define YY_USER_ACTION ncolumn += yyleng;

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

\n			{ ncolumn = 1;}

#.*			{ yylval.str = strdup( yytext ); return COMMENT; }

{WHITE}+		%{/* WHITESPACE */%}

.			{ printf( "Scan Error at (%i:%i), Unrecognized character or pattern: %s\n" , yylineno, ncolumn, yytext ); }

%%

