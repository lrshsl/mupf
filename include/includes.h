

#ifndef INCLUDES_INCLUDED
#define INCLUDES_INCLUDED

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <bits/types/FILE.h>

#define YYDEBUG 0

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno;
extern int fileno(FILE *file);


#endif /* INCLUDES_INCLUDED */
