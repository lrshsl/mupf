
%{

#ifndef MUPF_L
#define MUPF_L

#include "stdio.h"
#include "../build/mupf.tab.h"
#include "../include/includes.h"
#include "../include/util.h"

   // TODO: fix id regex

#define MAX_STR_CONST 1000

char string_buf[MAX_STR_CONST];
char *strbuf_ptr;

#endif

%}

%option noyywrap
%option yylineno
%option nomain


ws          [ \t]+
lf          [\r\n\cr]+
id          [a-zA-Z_][a-zA-Z0-9_]*
num         [0-9][0-9_]*(\.?[0-9_]+)?

%x lstate_str
%x lstate_cmt

%%



{ws}          /* ignore whitespace */
{lf}          /* return LF;        */

echo          return ECHO_STMT;

{id}          { yylval.id = yytext; return ID; }
{num}         { yylval.num = atoi(yytext); return NUM; }


"//"          BEGIN(lstate_cmt);

<lstate_cmt>{
   [^\n\/]+    while (*yytext++) { }

   "//"        BEGIN(INITIAL);
   {lf}        BEGIN(INITIAL);

   "/"         yytext++;
}


\"           { strbuf_ptr = string_buf; BEGIN(lstate_str); }

<lstate_str>{
   [^\\\n\"]+ {
      /* Default: no escape sequence, newline or closing quote */
      char *yptr = yytext;

      while ( *yptr ) {
         *strbuf_ptr++ = *yptr++;
      }
   }


   \n {
      /* Error */
      char s[28];
      sprintf(s, "Unterminated string: Line %d", yylineno);
      yyerror(s);
      /* Recover */
      BEGIN(INITIAL);
      yylval.str = string_buf;
      return STR;
   }

   \\n  *strbuf_ptr++ = '\n';
   \\t  *strbuf_ptr++ = '\t';
   \\r  *strbuf_ptr++ = '\r';
   \\b  *strbuf_ptr++ = '\b';
   \\f  *strbuf_ptr++ = '\f';

   \\(.|\n)  *strbuf_ptr++ = yytext[1];

   \" {
      /* string ended */
      BEGIN(INITIAL);
      *strbuf_ptr = '\0';
      yylval.str = string_buf;
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

