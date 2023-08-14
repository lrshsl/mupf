
#include "../include/includes.h"
#include "../include/util.h"


void yyerror(char *msg) {
	fprintf(stderr, "\nSome error may have occured.\n<ErrMsg>: %s\n", msg);
	fprintf(stderr, "Line: %d\n", yylineno);
	exit(-1);
}


