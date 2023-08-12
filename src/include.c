
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define YYDEBUG 0

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno;

void yyerror(char *s) {
	fprintf(stderr, "\nSome error may have occured.\n<ErrMsg>: %s\n", s);
	fprintf(stderr, "Line: %d\n", yylineno);
	exit(-1);
}

