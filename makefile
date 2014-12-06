FLEX = -lfl
ifeq ($(shell uname -s), Darwin)
    FLEX = -ll
endif

all: trabalho
	./trabalho < ./Exemplos/mdc.got > ./Exemplos/mdc.c
	./trabalho < ./Exemplos/multiplicacaodematrizes.got > ./Exemplos/multiplicacaodematrizes.c
	./trabalho < ./Exemplos/equacaosegundograu.got > ./Exemplos/equacaosegundograu.c
	./trabalho < ./Exemplos/leituraArrayPipe.got > ./Exemplos/leituraArrayPipe.c
	./trabalho < ./Exemplos/todosPipes.got > ./Exemplos/todosPipes.c
	g++ Exemplos/mdc.c -o Exemplos/mdc
	g++ Exemplos/multiplicacaodematrizes.c -o Exemplos/multiplicacaodematrizes
	g++ Exemplos/equacaosegundograu.c -o Exemplos/equacaosegundograu
	g++ Exemplos/leituraArrayPipe.c -o Exemplos/leituraArrayPipe
	g++ Exemplos/todosPipes.c -o Exemplos/todosPipes

lex.yy.c: trabalho.lex
	lex trabalho.lex

y.tab.c: trabalho.y
	yacc trabalho.y

trabalho: lex.yy.c y.tab.c
	g++ -std=c++11 -o trabalho y.tab.c $(FLEX)
