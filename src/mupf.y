%{

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define YYDEBUG 1

int yylex();
extern FILE *yyin;
extern int yylineno;

void yyerror(char *s) {
    fprintf(stderr, "\nSome error may have occured.\nIf you want to learn more about it, please consult the documentation: https://en.wikipedia.org/wiki/Bison\n\n(hint:  %s)\n", s);
    fprintf(stderr, "Line: %d\n", yylineno);
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

%type <num> n_exp
%type <str> ch_exp

%left '-' '+'
%left '*' '/'
%right '^'
%precedence NEG


%%

prog:
  YYEOF             { printf("Parsed till the end of file\n"); return 0; }
| exp  ';'          { printf("Parsed exp\n");  }
| stmt ';'          { printf("Parsed stmt\n"); }
;

exp:
  n_exp
| ch_exp
;

n_exp:
  NUM
| n_exp '+' n_exp   { $$ = $1 + $3; }
| n_exp '-' n_exp   { $$ = $1 - $3; }
| n_exp '*' n_exp   { $$ = $1 * $3; }
| n_exp '/' n_exp   { $$ = $1 / $3; }
;

ch_exp:
  STR
;

stmt:
    ECHO_STMT ch_exp     { printf("%s\n", $2); }
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



