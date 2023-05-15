%{

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define YYDEBUG 1

int yylex();
extern FILE *yyin;

void yyerror(char *s) {
    fprintf(stderr, "Some error may have occured.\nIf you want to learn more about it, please consult the documentation: https://en.wikipedia.org/wiki/Bison\n\n(hint:  %s)\n", s);
    exit(-1);
}

%}

%union {
    double num;
    char *str;
    char *id;
}

%token LF ID NUM STR
%token ECHO_STMT

%type <num> NUM
%type <str> STR
%type <id> ID

%type <num> nexp
%type <str> cexp

%left '-' '+'
%left '*' '/'
%right '^'
%precedence NEG


%%

prog:
  YYEOF             { return 0; }
| exp  ';' prog     { printf("Parsed exp\n");  }
| stmt ';' prog     { printf("Parsed stmt\n"); }
;

exp:
  nexp
| cexp
;

nexp:
  NUM
| nexp '+' nexp   { $$ = $1 + $3; }
| nexp '-' nexp   { $$ = $1 - $3; }
| nexp '*' nexp   { $$ = $1 * $3; }
| nexp '/' nexp   { $$ = $1 / $3; }
;

cexp:
  STR
;

stmt:
    ECHO_STMT cexp     { printf("%s\n", $2); }
;

%%

int main(int argc, char *argv[]) {
    yydebug = 1;
    // Check args
    if (argc != 2) {
        char msg[] = "Invalud number of arguments";
        sprintf(msg, "Usage: %s <file>", argv[0]);
        yyerror(msg);
        return 1;
    }
    // Open input file
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        yyerror("Could not open file");
        return 1;
    }
    // Main loop
    do {
        yyparse();
    } while (!feof(yyin));
    return 0;
}



