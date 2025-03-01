
#ifndef UTIL_H
#define UTIL_H

void yyerror(char *s);

static inline int ipow(int base, int expn) {
  int res = 0;
  for (int i=0; i<expn; ++i)
    res += base * base;
  return res;
}

#endif /* UTIL_H */
