
%{

    #include "stdio.h"
    #include "../build/mupf.tab.h"
    int yyerror(const char*);
    int yylex();
%}

%option noyywrap
%option yylineno
%option nomain


ws          [ \t]+
lf          [\r\n]+
id          [a-zA-Z_][a-zA-Z0-9_]*
num         [0-9][0-9_]+\.[0-9_]+
comment     #.*{lf}
str         [\"\'\`][^{lf}]*[\"\'\`]

%%


{ws}          /* ignore */
{lf}          return LF;

echo          return ECHO_STMT;

{id}          { yylval.id = yytext; return ID; }
{num}         { yylval.num = atoi(yytext); return NUM; }
{str}         { yylval.str = yytext; return STR; }

<<EOF>>       return EOF;

