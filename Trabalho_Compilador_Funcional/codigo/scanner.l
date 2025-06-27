%{
#include "stdio.h"
#include "tokens.h"
FILE *saida;
FILE *entrada;
%}

%x COMMENT
%option nounistd
%option yylineno
%option noyywrap

dgt [0-9]
inteiro (-)?{dgt}+
real (-)?{inteiro}\.{inteiro}

op (!=|==|<=|>=)

id ([a-zA-Z]|\.|_)*[a-zA-Z]([a-zA-Z]|\.|_)*
char '.'
string \"(\\\"|\\n|[^\n\"])+\"
char_especial [,;\(\)\[\]\{\}=\-+*\/%<>&\|~]
ignorar [ \t\n\r]
erro [^{inteiro}{real}{op}{id}{string}{char}{char_especial}{ignorar}]

%%

\\\\\\ { 
    fprintf(saida, "li comentario multiplas linhas\n");
    BEGIN(COMMENT); 
}
<COMMENT>{
   "///" {
        BEGIN(INITIAL);
    }
    (.|\n) { /* Ignorar todos os outros caracteres enquanto estiver no estado IGNORE_SLASHES */ }
}

char {
    fprintf(saida, "%s - KW_CHAR\n", yytext);
    return KW_CHAR;
}
int {
    fprintf(saida, "%s - KW_INT\n", yytext);
    return KW_INT;
}
real {
    fprintf(saida, "%s - KW_REAL\n", yytext);
    return KW_REAL;
}
bool {
    fprintf(saida, "%s - KW_BOOL\n", yytext);
    return KW_BOOL;
}
if {
    fprintf(saida, "%s - KW_IF \n", yytext);
    return KW_IF;
}
then {
    fprintf(saida, "%s - KW_THEN\n", yytext);
    return KW_THEN;
}
else {
    fprintf(saida, "%s - KW_ELSE\n", yytext);
    return KW_ELSE;
}
while {
    fprintf(saida, "%s - KW_LOOP\n", yytext);
    return KW_LOOP;
}
input {
    fprintf(saida, "%s - KW_INPUT\n", yytext);
    return KW_INPUT;
}
output {
    fprintf(saida, "%s - KW_OUTPUT\n", yytext);
    return KW_OUTPUT;
}
return {
    fprintf(saida, "%s - KW_RETURN\n", yytext);
    return KW_RETURN;
}

{op} {
    if (strcmp(yytext, "<=") == 0) {
        fprintf(saida, "%s - OPERATOR_LE\n", yytext);
        return OPERATOR_LE;
    } else if (strcmp(yytext, ">=") == 0) {
        fprintf(saida, "%s - OPERATOR_GE\n", yytext);
        return OPERATOR_GE;
    } else if (strcmp(yytext, "==") == 0) {
        fprintf(saida, "%s - OPERATOR_EQ\n", yytext);
        return OPERATOR_EQ;
    } else {
        fprintf(saida, "%s - OPERATOR_DIF\n", yytext);
        return OPERATOR_DIF;
    }
}

{ignorar} {/* Ignorar espaço em branco, tabulação ou quebra de linha */
    if(strcmp(yytext, "\n") == 0){ // com \r ele contava linhas mais de uma vez, esperimenta

    fprintf(saida, "\nlinha: %d\n", yylineno);
    }
}


\\\\[^\\][^\n]* { /* comentário de uma linha*/ 
    fprintf(saida, "\nli comentario uma linha\nlinha: %d\n", yylineno);
}

{real} {
    fprintf(saida, "%s - LIT_REAL\n", yytext);
    return LIT_REAL;
}
{inteiro} {
    fprintf(saida, "%s - LIT_INT\n", yytext);
    return LIT_INT;
}
{char_especial} {
    fprintf(saida, "%s - %s\n", yytext, yytext);
    return yytext[0]; // Retorna o próprio caractere
}
{id} {
    fprintf(saida, "%s - TK_IDENTIFIER\n", yytext);
    return TK_IDENTIFIER;
}
{char} {
    fprintf(saida, "%s - LIT_CHAR\n", yytext);
    return LIT_CHAR;
}
{string} {
    fprintf(saida, "%s - LIT_STRING\n", yytext);
    return LIT_STRING;
}
{erro} {
    int linhaErro = getLineNumber();
    fprintf(saida, "Erro na linha %d\n",linhaErro);
    return TOKEN_ERROR;
}
%%
void trocaYYIN(FILE *arq){
    yyin = arq;
}

void trocaYYOUT(FILE *arq){
    yyout = arq;
}

void trocaEntrada(FILE *arq){
    entrada = arq;
}

void trocaSaida(FILE *arq){
    saida = arq;
}

int getLineNumber(){
    return yylineno;
}


    
   