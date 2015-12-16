%{
#include <stdio.h>
#include <string.h>

#define YYSTYPE  char *


#include "ConfParser.h"

int Conf_debug=0;
char secname;

void Conf_error(const char *str)
{
	extern int lineno;
	fprintf(stderr,"\nOoops: %s at line %d\n",str,lineno);
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
%token WORD OSQUARE CSQUARE NUMBER QUOTE 
%token END 0 "end of file"
%token EQUALS "="
%token SEMICOLON ";"
%%


sections:
    /* empty */
    |
    sections section
    ;

section: header commands

header: OSQUARE WORD CSQUARE
    {
      if(secname != $2){
      printf("\nApro la sezione '%s'\n", $2);
      secname = $2;
    } else {
    fprintf(stderr,"\nI won't let you redefine section %s",$2);}
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
      printf("Assegno %d alla variabile '%s'\n", atoi($3), $1);
    }
    ;

value: NUMBER
;
