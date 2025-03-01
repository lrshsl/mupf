#ifndef INCLUDES_INCLUDED
#define INCLUDES_INCLUDED

#include <ctype.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno;
extern int fileno(FILE *file);

#endif /* INCLUDES_INCLUDED */
