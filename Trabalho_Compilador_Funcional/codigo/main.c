#include "sintatico.tab.h"
#include "lex.yy.h"
#include "stdlib.h"
#include "stdio.h"

int main(int argc, char *argv[]) {
    FILE* saida = fopen("saida.txt", "w");
    FILE* entrada = fopen(argv[1], "r");

    if (saida == NULL) {
        fprintf(stderr, "Erro ao abrir o arquivo de saída.\n");
        return 1;
    }

    if (entrada == NULL) {
        perror("Erro ao abrir o arquivo");
        return 1;
    }
    
    trocaYYIN(entrada);
    trocaYYOUT(saida);
    trocaEntrada(entrada);
    trocaSaida(saida);

    //while(yyparse()!=0);
    //yydebug = 1;
    yyparse();

    printf("Análise Concluída\n");
    fclose(saida);
    fclose(entrada);
    return 0;
}