
#include "../include/main.h"
#include "../include/includes.h"
#include "../include/util.h"

int main(int argc, char *argv[]) {
  // yydebug = 1;

  // Check args
  if (argc == 1) {

    /* Interactive */
    yyin = stdin;

  } else if (argc == 2) {

    /* Open input file */
    yyin = fopen(argv[1], "r");
    if (!yyin) {
      char msg[100];
      sprintf(msg, "Could not open file: '%s'", argv[1]);
      yyerror(msg);
      return 1;
    }

  } else {
    /* Error */
    char msg[1100] = "Invalid number of arguments:";
    int i = 1, len = 0;
    char argstr[1000] = {'\0'};
    for (; i < argc; ++i) { /* TODO: strcat */
      strcpy(argstr + len, argv[i]);
      len += strlen(argv[i]);
      argstr[len++] = ' ';
      if (len > 1000) {
        yyerror("<<Internal Error>> msg of 'file-not-found error' longer than "
                "1000 chars\n");
        return 2;
      }
    }
    argstr[len + 1] = '\0';
    sprintf(msg + 28, "Usage: %s <file>\nWas called with those arguments: %s",
            argv[0], argstr);
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
