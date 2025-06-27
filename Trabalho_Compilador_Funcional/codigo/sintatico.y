%{
#include "lex.yy.h"
#include "stdio.h"
void yyerror(char const *s){
        fprintf(stderr, "%s\n",s);
}
%}

%define parse.trace

%token KW_CHAR           256
%token KW_INT            257
%token KW_REAL           258
%token KW_BOOL           259

%token KW_IF             261
%token KW_THEN           262
%token KW_ELSE           263
%token KW_LOOP           264
%token KW_INPUT          266
%token KW_OUTPUT         267
%token KW_RETURN         268

%token OPERATOR_LE       270
%token OPERATOR_GE       271
%token OPERATOR_EQ       272
%token OPERATOR_DIF      273
%token OPERATOR_ATRIB    274

%token TK_IDENTIFIER     280

%token LIT_INT           281
%token LIT_REAL          282
%token LIT_CHAR          285
%token LIT_STRING        286

%token SG_SEMICOLON      290

%token TOKEN_ERROR       390

%%

programa        : programa lista-decl 
                | programa lista-com
                | %empty
                ;
lista-decl      : lista-decl decl
                | decl
                ;
decl            : decl-var
                | decl-func
                ;
decl-var        : espec-tipo var ';'
                | espec-tipo var '=' exp ';'
                | espec-tipo var '=' vetor ';'
                ;
espec-tipo      : KW_INT
                | KW_REAL
                | KW_CHAR
                ;
decl-func       : espec-tipo TK_IDENTIFIER '(' params ')' com-comp
                ;
params          : lista-param
                | %empty
                ;
lista-param     : lista-param ',' param
                | param
                ;
param           : espec-tipo var
                ;
decl-locais     : decl-locais decl-var
                | %empty
                ;
lista-com       : comando lista-com
                | %empty
                ;
comando         : com-expr
                | com-atrib
                | com-comp
                | com-selecao
                | com-repeticao
                | com-retorno
                | com-output
                ;
com-expr        : exp ';'
                | ';'
                ;
com-atrib       : var '=' exp ';'
                | var '=' vetor ';'
                ;
com-comp        : '{' decl-locais lista-com '}'
                ;
com-selecao     : KW_IF '(' exp ')' comando 
                | KW_IF '(' exp ')' com-comp KW_ELSE comando
                ;
com-repeticao   : KW_LOOP '(' exp ')' comando 
                ;
com-retorno     : KW_RETURN ';'
                | KW_RETURN exp ';'
                ;
com-output      : KW_OUTPUT '(' lista-out ')' ';'
                ;
lista-out       : lista-out ',' LIT_STRING 
                | lista-out ',' exp 
                | LIT_STRING
                | exp
                ;
exp             : exp-soma op-relac exp-soma
                | exp-soma
                ;
op-relac        : OPERATOR_LE
                | '<'
                | '>'
                | OPERATOR_GE
                | OPERATOR_EQ
                | OPERATOR_DIF
                ;
exp-soma        : exp-soma op-soma exp-mult
                | exp-mult
                ;
op-soma         : '+'
                | '-'
                ;
exp-mult        : exp-mult op-mult exp-logic 
                | exp-logic
                ;
op-mult         : '*'
                | '/'
                | '%'
                ;
exp-logic       : exp-logic op-logic exp-simples
                | exp-simples
                | '~' exp-simples
                ;
op-logic        : '&'
                | '|'
                ;
exp-simples     : '(' exp ')'
                | var
                | cham-func
                | literais
                ;
vetor           : '{' lista-elem '}'
                ;
lista-elem      : lista-elem literais
                | literais
                ;
literais        : LIT_INT
                | LIT_REAL
                | LIT_CHAR
                ;
cham-func       : TK_IDENTIFIER '(' args ')'
                | KW_INPUT '(' espec-tipo ')'
                ;
var             : TK_IDENTIFIER
                | TK_IDENTIFIER '[' LIT_INT ']'
                | TK_IDENTIFIER '[' exp ']' 
                ;
args            : lista-arg
                | %empty
                ;
lista-arg       : lista-arg ',' exp
                | exp
                ;
%%

#include "main.c"
