#
#  - Compiladores  - Etapa analisador Léxico
#
# Makefile for single compiler call
# All source files must be included from code embedded in scanner.l
# In our case, you probably need #include "hash.c" at the beginning
# and #include "main.c" in the last part of the scanner.l
#


etapa1: sintatico.tab.o lex.yy.o
	gcc -o etapa1 lex.yy.o sintatico.tab.o -lfl
sintatico.tab.o: sintatico.tab.c lex.yy.o
	gcc -c sintatico.tab.c
lex.yy.o: lex.yy.c
	gcc -c lex.yy.c
sintatico.tab.c: sintatico.y 
	bison --header=sintatico.tab.h sintatico.y
lex.yy.c: scanner.l
	flex --header-file=lex.yy.h scanner.l
clean:
	rm lex.yy.c lex.yy.h lex.yy.o sintatico.tab.c sintatico.tab.o sintatico.tab.h saida.txt etapa1