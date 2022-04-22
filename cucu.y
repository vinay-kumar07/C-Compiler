%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYSTYPE char*
extern void yyerror(const char* message);
extern int yylex();
extern FILE* yyin;
extern FILE* yyout;
%}

%token IF ELSE WHILE RETURN DATATYPE ID NUM REL_OP END

%%
START:      PROGRAM END                 {printf("Correct Syntax\n%s",$1); return 1;}

PROGRAM:    PROGRAM_ELEMENT             {$$ = malloc(strlen($1)+100); sprintf($$, "%s\n", $1);}        
|           PROGRAM PROGRAM_ELEMENT     {$$ = malloc(strlen($2) + strlen($1) +100); sprintf($$, "%s\n%s\n", $1, $2);}      
;

PROGRAM_ELEMENT:    VAR_DEC             {$$ = malloc(sizeof(char)*(strlen($1) + 100)); sprintf($$, "%s", $1);}       
|                   FUNC_DEC            {$$ = malloc(sizeof(char)*(strlen($1) + 100)); sprintf($$, "Function Declaration:\n%s", $1);}          
|                   FUNC_DEF            {$$ = $1;}           
;

VAR_DEC:    DATATYPE ID ';'             {$$ = malloc(sizeof(char)*100); sprintf($$, "Variable Declaration: Type: %s, Id: %s", $1, $2);}
;

FUNC_DEC:   DATATYPE ID '(' FUNC_ARG ')' ';'    {$$ = malloc(sizeof(char)*100); sprintf($$, "Function Return Type: %s Function Name: %s Function Arguments: %s", $1, $2, $4);}
|           DATATYPE ID '(' ')' ';'             {$$ = malloc(sizeof(char)*100); sprintf($$, "Function Return Type: %s Function Name: %s", $1, $2);}
;

FUNC_DEF:   DATATYPE ID '(' FUNC_ARG ')' '{' FUNC_BODY '}' {$$ = malloc(sizeof(char)*(strlen($1) + strlen($2) + strlen($4) + strlen($7) + 100)); sprintf($$,"Function Definition:\nFunction Return Type: %s Function Name: %s Function Arguments: %s\n%s\n",$1,$2,$4,$7);}
|           DATATYPE ID '(' ')' '{' FUNC_BODY '}'          {$$ = malloc(sizeof(char)*(strlen($1) + strlen($2) + strlen($6) + 100)); sprintf($$,"Function Definition:\nFunction Return Type: %s Function Name: %s\n%s\n",$1,$2,$6);}
;

FUNC_ARG:   ARG                     {$$=$1;}                                    
|           FUNC_ARG ',' ARG        {$$=malloc(strlen($1) + strlen($3) + 5); sprintf($$,"%s , %s",$1,$3);}         
;

ARG:        DATATYPE ID             {$$ = malloc(sizeof(char)*200); sprintf($$, "%s", $2);}
;

FUNC_BODY:  STATEMENTS              {$$=$1;}
|           FUNC_BODY STATEMENTS    {$$ = malloc(sizeof(strlen($1)+strlen($2)+5)); sprintf($$,"%s\n%s",$1,$2);}
;

STATEMENTS: ASSIGNMENT_STAT         {$$=$1;}
|           FUNCTION_CALL           {$$=$1;}
|           RETURN_STAT             {$$=$1;}
|           COMP_STAT               {$$=$1;}
;

ASSIGNMENT_STAT:    ID '=' EXP ';'     {$$ = malloc(sizeof(char)*((strlen($1) + strlen($3) + 100))); sprintf($$, "Assignment Statement: LHS=%s,RHS=%s\n", $1, $3);}
;

EXP:        TERM                    {$$ = malloc(sizeof(char)*100); sprintf($$, "%s", $1);}
|           EXP '+' TERM            {$$ = malloc(sizeof(strlen($1)+strlen($3)+50)); sprintf($$, "%s and %s",$1,$3);}
|           EXP '-' TERM            {$$ = malloc(sizeof(strlen($1)+strlen($3)+50)); sprintf($$, "of %s and %s",$1,$3);}
;

TERM:       TERM '*' FACTOR         {$$ = malloc(sizeof(strlen($1)+strlen($3)+50)); sprintf($$, "Multiplication of %s and %s",$1,$3);}
|           TERM '/' FACTOR         {$$ = malloc(sizeof(strlen($1)+strlen($3)+50)); sprintf($$, "Division of %s and %s",$1,$3);}
|           FACTOR                  {$$ = $1;}
;

FACTOR:     ID                      {$$ = $1;}
|           NUM                     {$$ = $1;}
|           FUNCTION_CALL           {$$ = $1;}
|           '(' EXP ')'             {$$ = malloc(sizeof(char)*(strlen($2)+3)); sprintf($$, "(%s)", $2);}
;

RETURN_STAT:    RETURN EXP ';'      {&& = malloc(sizeof(strlen($2)+10); sprintf($$, "Return: %s\n",%2));}
;

COMP_STAT:  IF '(' BOOL_EXP ')' '{' STATEMENTS '}'      
|           IF '(' BOOL_EXP ')' '{' STATEMENTS '}' ELSE '{' STATEMENTS '}'
|           WHILE '(' BOOL_EXP ')' '{' STATEMENTS '}'
;

FUNCTION_CALL: ID '(' ')' ';'                       {$$ = malloc(sizeof(char)*100); sprintf($$, "FUNC_CALL(name: %s, parameters: NONE)", $1);}
|              ID '(' PARAMETER_LIST ')' ';'        {$$ = malloc(sizeof(char)*100); sprintf($$, "FUNC_CALL(name: %s, parameters: %s)", $1, $3);}
;

PARAMETER_LIST:     PARAMETER
|                   PARAMETER_LIST ',' PARAMETER   
;

PARAMETER:          EXP                             {$$=$1;}
|                   ID '(' PARAMETER_LIST ')'       {}
;

BOOL_EXP: EXP REL_OP EXP                            {$$ = malloc(sizeof(char)*(strlen($1) + strlen($2) + strlen($3) + 5)); sprintf($$, "%s %s %s", $1, $2, $3);}
;

%%
int main()
{
    yyin = fopen("Sample1.cu","r");
    yyout = fopen("Lexer.txt","w");
    stdout = fopen("Parser.txt","w");
    yyparse();
    fclose(yyin);
    fclose(yyout);
}

void yyerror(const char* message)
{
    printf("%s\n",message);
}
