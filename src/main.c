
#ifndef INCLUDE_C_INCLUDED
#define INCLUDE_C_INCLUDED

#include "../src/include.c"

#endif


int main(int argc, char *argv[]) {
  //yydebug = 1;

  // Check args
  if (argc == 1) {
    /* Interactive */
    yyin = stdin;
  } else if (argc == 2) {
    /* Open input file */
    yyin = fopen(argv[1], "r");
    if (!yyin) {
      yyerror("Could not open file");
      return 1;
    }
  } else {
    /* Error */
    char msg[1100] = "Invalid number of arguments:";
    int i=0, len=0;
    char argstr[1000] = {'\0'};
    for (; i<argc; ++i) {
      strcpy(argstr+len, argv[i]);
      len += strlen(argv[i]);
      if (len > 1000) {
        yyerror("<<Internal Error>> msg longer than 1000 chars\n");
        return 2;
      }
    }
    argstr[len+1] = '\0';
    sprintf(msg+28, "Usage: %s <file>\nWas called with those arguments: %s", argv[0], argstr);
    yyerror(msg);
    return 1;
  }

  // Main loop
  do {
    yyparse();
  } while (!feof(yyin));
  fclose(yyin);
  return 0;
}

