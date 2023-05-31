%{
#include <stdlib.h>
#include "y.tab.h"
#include <string.h>

%}

%%

"DRAW"              { return DRAW; }
"if"                { strcpy(yylval.sValue, yytext); return IF; }
"variable"          { strcpy(yylval.sValue, yytext); return VARIABLE; }
"sum"               { strcpy(yylval.sValue, yytext); return SUM; }
"print"             { strcpy(yylval.sValue, yytext); return PRINT; }
                        
[a-z]+[A-Z]*        {
                        strcpy(yylval.sValue, yytext);
                        return STRING_VAL;
                    }
0                   {
                        strcpy(yylval.sValue, yytext);
                        return STRING_VAL;
                    }                  
-?[1-9][0-9]*       {
                        strcpy(yylval.sValue, yytext);
                        return STRING_VAL;
                    }               
[/<>{}=".()]           return yytext[0];
[ \t\n]              ;

%%

int yywrap(void)
{
    return 1;
}
