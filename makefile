FLEX = -lfl
ifeq ($(shell uname -s), Darwin)
    FLEX = -ll
endif

all: trabalho entrada.got
	#./trabalho < entrada_prototipos.got > saida.c
	#./trabalho < entrada_funcoes.got > saida.c
	#./trabalho < entrada_fluxos.got > saida.c
	#./trabalho < entrada_expressao.got > saida.c
	./trabalho < entrada_pipes.got > saida.c
	cat saida.c

lex.yy.c: trabalho.lex
	lex trabalho.lex

y.tab.c: trabalho.y
	yacc trabalho.y

trabalho: lex.yy.c y.tab.c
	g++ -std=c++11 -o trabalho y.tab.c $(FLEX)
