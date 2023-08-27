%{

   #include "../include/includes.h"
   #include "../include/util.h"
   #include "../include/main.h"

%}



%union {
	int num;
	char *str;
	char *id;
}

%token LF ID NUM STR
%token POW OP_CONCAT
%token ECHO_STMT

%type <num> NUM
%type <str> STR
%type <id> ID

%type <num> n_exp
%type <str> ch_exp

%left OP_CONCAT
%left '-' '+'
%left '*' '/'
%right POW
//%precedence NEG




%%




prog:
  line
| line ';' prog
;

line:
  %empty
| exp
| stmt
;


exp:
  n_exp           { printf("<Parser::exp>Parsed n_exp: %d\n", $1); }
| ch_exp          { printf("<Parser::exp>Paresd ch_exp: %s\n", $1); $<str>$ = $1; }
;

n_exp:
  '(' n_exp ')'     { $$ = $2; }
| n_exp POW n_exp   { $$ = ipow($1, $3); }
| n_exp '*' n_exp   { $$ = $1 * $3; }
| n_exp '/' n_exp   { $$ = $1 / $3; }
| n_exp '+' n_exp   { $$ = $1 + $3; }
| n_exp '-' n_exp   { $$ = $1 - $3; }
| '-' NUM           { $$ = -$2; }
| NUM
;

ch_exp:
  ch_exp OP_CONCAT ch_exp {
    char *result = (char *)malloc((strlen($1) + strlen($3)) * sizeof(char));
    if (!$$) {
      yyerror("<Parser::ch_exp>Can't allocate more memory for str concatenation!\n");
      exit(2);
    } else {
      strcpy(result, $1);
      strcat(result, $3);
    }
    printf("<Parser::ch_exp>Concatenating strings: %s + %s = %s\n", $1, $3, result);
    $$ = result;
  }
| STR
;

stmt:
	ECHO_STMT ch_exp     { fprintf(prog_output_file, "%s\n", $2); }
;



