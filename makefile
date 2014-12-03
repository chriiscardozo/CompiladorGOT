FLEX = -lfl
ifeq ($(shell uname -s), Darwin)
    FLEX = -ll
endif

all: trabalho entrada.got
	#./trabalho < entrada.got > saida.c
	./trabalho < entrada_prototipos.got > saida.c
	#./trabalho < entrada_funcoes.got > saida.c
	#./trabalho < entrada_fluxos.got > saida.c
	#./trabalho < entrada_expressoes.got > saida.c
	#./trabalho < entrada_pipes.got > saida.c
	cat saida.c

lex.yy.c: trabalho.lex
	lex trabalho.lex

y.tab.c: trabalho.y
	yacc trabalho.y

trabalho: lex.yy.c y.tab.c
	g++ -std=c++11 -o trabalho y.tab.c $(FLEX)

e_prototipos:	entrada_prototipos.got
e_funcoes:	entrada_funcoes.got
e_fluxos:	entrada_fluxos.got
e_expressoes:	entrada_expressoes.got
e_pipes:	entrada_pipes.got
entradas:	e_prototipos e_funcoes e_fluxos e_expressoes e_pipes

test: trabalho entradas
	./trabalho < entrada_prototipos.got > saida.c
	./../gabarito/trabalho < saida.c
	gcc saida.c
	./trabalho < entrada_funcoes.got > saida.c
	./../gabarito/trabalho < saida.c
	gcc saida.c
	./trabalho < entrada_fluxos.got > saida.c
	./../gabarito/trabalho < saida.c
	gcc saida.c
	./trabalho < entrada_expressoes.got > saida.c
	./../gabarito/trabalho < saida.c
	gcc saida.c
	./trabalho < entrada_pipes.got > saida.c
	./../gabarito/trabalho < saida.c
	gcc saida.c
