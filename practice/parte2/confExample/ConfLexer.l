%{
#include <stdio.h>

#define YYSTYPE  char *

#include "ConfParser.h"

int lineno = 1;
%}

%%

[0-9]*                  Conf_lval=strdup(Conf_text); return NUMBER;
[a-zA-Z][a-zA-Z0-9]*    Conf_lval=strdup(Conf_text); return WORD;
\"                      return QUOTE;
\[                      return OSQUARE;
\]                      return CSQUARE;
;                       return SEMICOLON;
=                       return EQUALS;
\n                      lineno++/*Ignore EOL*/;
[ \t]+                  /* ignore whitespace */;
#.*                     /* ignore comments */
%%
