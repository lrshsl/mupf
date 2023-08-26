
%{

    #include "stdio.h"
    #include "../build/mupf.tab.h"
    #include "../include/includes.h"
    #include "../include/util.h"

    // TODO: fix id regex

    #define MAX_STR_CONST 1000
%}

%option noyywrap
%option yylineno
%option nomain


ws          [ \t]+
cmt         \/\/[^\n\r\cr]*
lf          [\r\n\cr{cmt}]+
id          [a-zA-Z_][a-zA-Z0-9_]*
num         [0-9][0-9_]*(\.?[0-9_]+)?


        char string_buf[MAX_STR_CONST];
        char *string_buf_ptr;

%x str
%x cmt

%%



{ws}          /* ignore whitespace */
{lf}          /* return LF;        */

echo          return ECHO_STMT;

{id}          { yylval.id = yytext; return ID; }
{num}         { yylval.num = atoi(yytext); return NUM; }


"//"          BEGIN(cmt);

<cmt>{
   [^\n\/]+  while (*yytext++) { }

   "//" BEGIN(INITIAL);
   "\n" BEGIN(INITIAL);

   "/"  yytext++;
}


\"           { string_buf_ptr = string_buf; BEGIN(str); }

<str>{
   [^\\\n\"]+ {
      /* default: no escape sequence, newline or closing quote */
      char *yptr = yytext;

      while ( *yptr ) {
         *string_buf_ptr++ = *yptr++;
      }
   }


   \n {
      fprintf(stderr, "Unterminated string: Line %d", yylineno);
      BEGIN(INITIAL);
      return STR;
   }

   \\n  *string_buf_ptr++ = '\n';
   \\t  *string_buf_ptr++ = '\t';
   \\r  *string_buf_ptr++ = '\r';
   \\b  *string_buf_ptr++ = '\b';
   \\f  *string_buf_ptr++ = '\f';

   \\(.|\n)  *string_buf_ptr++ = yytext[1];

   \" {
      /* string ended */
      BEGIN(INITIAL);
      *string_buf_ptr = '\0';
      return STR;
   }
}


"**"                { return POW; }
"<>"                { return OP_CONCAT; }
"+"|"-"|"*"|"/"     { return yytext[0]; }
"("|")"|"["|"]"     { return yytext[0]; }
"{"|"}"|"<"|">"     { return yytext[0]; }
";"|"="|","|"."     { return yytext[0]; }


<<EOF>>       return EOF;

.             { 
                char s[24];
                sprintf(s, "Unexpected character: %c", yytext[0]);
                yyerror(s);
                return 0;
              }
