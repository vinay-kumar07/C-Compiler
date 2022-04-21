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

%token IF ELSE WHILE RETURN DATATYPE ID NUM REL_OP

%%

PROGRAM:    PROGRAM_ELEMENT 
|           PROGRAM PROGRAM_ELEMENT 
;

PROGRAM_ELEMENT:    VAR_DEC 
|                   FUNC_DEC 
|                   FUNC_DEF
;

VAR_DEC:    DATATYPE ID ';'
;

FUNC_DEC:   DATATYPE ID '(' FUNC_ARG ')' ';' 
|           DATATYPE ID '(' ')' ';'
;

FUNC_DEF:   DATATYPE ID '(' FUNC_ARG ')' '{' FUNC_BODY '}'
|           DATATYPE ID '(' ')' '{' FUNC_BODY '}'
;

FUNC_ARG:   ARG 
|           FUNC_ARG ',' ARG
;

ARG:        DATATYPE ID
;

FUNC_BODY:  STATEMENTS 
|           FUNC_BODY STATEMENTS
;

STATEMENTS: ASSIGNMENT_STAT 
|           FUNCTION_CALL 
|           RETURN_STAT 
|           COMP_STAT
;

ASSIGNMENT_STAT:    ID '=' EXP ';'
;

EXP:        TERM 
|           EXP '+' TERM 
|           EXP '-' TERM    
;

TERM:       TERM '*' FACTOR 
|           TERM '/' FACTOR 
|           FACTOR
;

FACTOR:     ID 
|           NUM 
|           '(' EXP ')'
;

RETURN_STAT:    RETURN EXP ';'
;

COMP_STAT:  IF '(' BOOL_EXP ')' '{' STATEMENTS '}' 
|           IF '(' BOOL_EXP ')' '{' STATEMENTS '}' ELSE '{' STATEMENTS '}'
|           WHILE '(' BOOL_EXP ')' '{' STATEMENTS '}'
;

FUNCTION_CALL: ID '(' ')' ';' 
|              ID '(' PARAMETER_LIST ')' ';'
;

PARAMETER_LIST:     PARAMETER
|                   PARAMETER_LIST ',' PARAMETER   
;

PARAMETER:          EXP
|                   ID '(' PARAMETER_LIST ')'
;

BOOL_EXP: EXP REL_OP EXP 
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