%{
#include <stdio.h>
#include <string.h>

#define YYSTYPE  char *


#include "ConfParser.h"

int Conf_debug=0;

void Conf_error(const char *str)
{
	extern int lineno;
	fprintf(stderr,"%s at line %d\n",str,lineno);
}

int Conf_wrap()
{
    return 1;
}

main()
{
    Conf_parse();
}

%}

%define parse.error verbose
%token WORD OSQUARE CSQUARE SEMICOLON NUMBER QUOTE EQUALS
%token END 0 "end of file"
%token EQUALS "="
%%


sections:
    /* empty */
    |
    sections section
    ;

section: header commands

header: OSQUARE WORD CSQUARE
    {
      printf("\nApro la sezione '%s'\n", $2);
    }
;


commands:
    /* empty */
    |
    commands command SEMICOLON
    ;


command:
    assignment 
    ;

assignment:
    WORD EQUALS value
    {
      printf("Assegno %d alla variabile '%s'\n", atoi($3), $2);
    }
    ;

value: NUMBER
;
