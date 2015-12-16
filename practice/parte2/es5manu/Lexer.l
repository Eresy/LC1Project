%{

#include "Parser.h"

#define YYSTYPE char *

int nlines = 1;
int ncolumn = 1;

#define YY_USER_ACTION ncolumn += yyleng;

%}

%option noyywrap

CHAR	[a-zA-Z]
NUM 	[0-9]
WHITE	[ \t]

%%

\[	{ return OPENSEC; }

\]	{ return CLOSESEC; }

(true|false)	{ yylval = strdup( yytext ); return BOOL; }

{CHAR}+{NUM}*	{ yylval = strdup( yytext ); return LABEL; }

\"{CHAR}+\"	{ yylval = strdup( yytext ); return STRING; }

{NUM}+	{ yylval = strdup( yytext ); return INT; }

\=	{ return BIND; }

\;	{ return SEMICOLON; }

\n	{ nlines++; ncolumn = 1;}

\#.*	{ yylval = strdup( yytext ); return COMMENT; }

{WHITE}+	%{/* WHITESPACE */%}

.*	{ printf( "Scan error at (%i:%i), Unrecognized character or pattern: %s\n" , nlines, ncolumn, yytext ); }

%%

