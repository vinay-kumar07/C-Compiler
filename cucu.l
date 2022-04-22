%{
#include <stdio.h>
#include <string.h>
#define YYSTYPE char*
#include "y.tab.h"
%}

%%

(if)                    { yylval = strdup(yytext); fprintf(yyout,"IF_STATEMENT\n");   return IF;}
(else)                  { yylval = strdup(yytext); fprintf(yyout,"ELSE_STATEMENT\n"); return ELSE;}
(while)                 { yylval = strdup(yytext); fprintf(yyout,"WHILE_STATEMENT\n");    return WHILE;}
(return)                { yylval = strdup(yytext); fprintf(yyout,"RETURN_STATEMENT\n");   return RETURN;}
(\,)                    { yylval = strdup(yytext); fprintf(yyout,"COMMA\n");  return yytext[0];}
(int|char[\t ]*\*)      { yylval = strdup(yytext); fprintf(yyout,"DATATYPE: %s\n",yytext);    return DATATYPE;}
(\}|\))                 { yylval = strdup(yytext); fprintf(yyout,"RIGHT_PANTHESIS: %s\n",yytext); return yytext[0];}
(\{|\()                 { yylval = strdup(yytext); fprintf(yyout,"LEFT_PANTHESIS: %s\n",yytext);  return yytext[0];}
(\;)                    { yylval = strdup(yytext); fprintf(yyout,"SEMI_COLON: ;\n");  return yytext[0];}
([a-zA-Z][a-zA-Z0-9_]*) { yylval = strdup(yytext); fprintf(yyout,"ID: %s\n",yytext);  return ID;}
(\*|\+|\-|\/)           { yylval = strdup(yytext); fprintf(yyout,"OPERATOR: %s\n",yytext);    return yytext[0];}
(\=)                    { yylval = strdup(yytext); fprintf(yyout,"ASSIGN: =\n");  return yytext[0];}
([<>!=]=|>|<)           { yylval = strdup(yytext); fprintf(yyout,"RELATIONAL_OPERATOR: %s\n",yytext);   return REL_OP;}
([0-9]+)                { yylval = strdup(yytext); fprintf(yyout,"NUM: %s\n",yytext); return NUM;}
[\t \n]
<<EOF>>                 {return END;}

%%
