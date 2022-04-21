%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}

%%

(if)                    {fprintf(yyout,"IF_STATEMENT\n");   return IF;}
(else)                  {fprintf(yyout,"ELSE_STATEMENT\n"); return ELSE;}
(while)                 {fprintf(yyout,"WHILE_STATEMENT\n");    return WHILE;}
(return)                {fprintf(yyout,"RETURN_STATEMENT\n");   return RETURN;}
(\,)                    {fprintf(yyout,"COMMA\n");  return yytext[0];}
(int|char[\t ]*\*)      {fprintf(yyout,"DATATYPE: %s\n",yytext);    return DATATYPE;}
(\}|\))                 {fprintf(yyout,"RIGHT_PANTHESIS: %s\n",yytext); return yytext[0];}
(\{|\()                 {fprintf(yyout,"LEFT_PANTHESIS: %s\n",yytext);  return yytext[0];}
(\;)                    {fprintf(yyout,"SEMI_COLON: ;\n");  return yytext[0];}
([a-zA-Z][a-zA-Z0-9_]*) {fprintf(yyout,"ID: %s\n",yytext);  return ID;}
(\*|\+|\-|\/)           {fprintf(yyout,"OPERATOR: %s\n",yytext);    return yytext[0];}
(\=)                    {fprintf(yyout,"ASSIGN: =\n");  return yytext[0];}
([<>!=]=|>|<)               {fprintf(yyout,"RELATIONAL_OPERATOR: %s\n",yytext);   return REL_OP;}
([0-9]+)                {fprintf(yyout,"NUM: %s\n",yytext); return NUM;}
[\t \n]

%%
