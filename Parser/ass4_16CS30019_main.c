#include <stdio.h>
#include "y.tab.h"
extern char* yytext;
yydebug=1;

extern int yyparse();
int main() {
  int token;
  yyparse();
  return 0;

}
