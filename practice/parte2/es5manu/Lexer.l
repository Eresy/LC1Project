%option noyywrap yylineno
%{

#define YYSTYPE char *

#include "Parser.h"

%}


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

=	{ return BIND; }

;	{ return SEMICOLON; }

\n	;

#.*	{ yylval = strdup( yytext ); return COMMENT; }

{WHITE}+	%{/* WHITESPACE */%}

.	{ printf( "Scan error at (%d), Unrecognized character or pattern: %s\n" , yylineno, yytext ); }

%%

