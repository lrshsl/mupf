
%{

    #include "stdio.h"
    #include "../build/mupf.tab.h"
    int yyerror(const char*);
    int yylex();

    // TODO: fix id regex
%}

%option noyywrap
%option yylineno
%option nomain


ws          [ \t]+
cmt         [/]{2}[^\n\r\cr]*
lf          [\r\n\cr{cmt}]+
id          [a-zA-Z_][a-zA-Z0-9_]*
num         [0-9][0-9_]*(\.?[0-9_]+)?
str         \"[^{lf}\"]*\"

%%


{ws}          /* ignore */
{cmt}         /* ignore */
{lf}          //return LF;

echo          return ECHO_STMT;

{id}          { yylval.id = yytext; return ID; }
{num}         { yylval.num = atoi(yytext); return NUM; }
{str}         { yylval.str = yytext; return STR; }

"+"|"-"|"*"|"/"     { return yytext[0]; }
"("|")"|"["|"]"     { return yytext[0]; }
"{"|"}"|"<"|">"     { return yytext[0]; }
";"                 { return yytext[0]; }

<<EOF>>       return EOF;

.             { 
                char s[24];
                sprintf(s, "Unexpected character: %c", yytext[0]);
                yyerror(s);
                return 0;
              }

