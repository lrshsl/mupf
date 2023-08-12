%{

#ifndef INCLUDE_C_INCLUDED
#define INCLUDE_C_INCLUDED

#include "../src/include.c"

#endif


%}




/* Bison/Yacc definitions and declarations */

%union {
	int num;
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
//%right '^'
//%precedence NEG






/* Grammar */

%%



prog:
  linecontent ';' prog
| linecontent YYEOF
;

linecontent:
  %empty
| exp
| stmt
;


exp:
  n_exp           { printf("[[ParsedNumExpression]] %d\n", $<num>$); }
| ch_exp          { printf("[[ParsedCharExpression]] %s\n", $<str>$); }
;

n_exp:
  '(' n_exp ')'     { $$ = $2; }
| n_exp '+' n_exp   { $$ = $1 + $3; printf("<<FoundAddition>> %d + %d = %d\n", $1, $3, $$); }
| n_exp '-' n_exp   { $$ = $1 - $3; }
| n_exp '*' n_exp   { $$ = $1 * $3; }
| n_exp '/' n_exp   { $$ = $1 / $3; }
| '-' NUM           { $$ = -$2; }
| NUM
;

ch_exp:
  STR
;

stmt:
	ECHO_STMT ch_exp     { printf("%s\n", $2); }
;

%%



/* Loaded afterwards */

#include "../src/main.c"



