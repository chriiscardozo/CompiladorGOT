all: trabalho entrada.got
	./trabalho < entrada.got

lex.yy.c: trabalho.lex
	lex trabalho.lex

y.tab.c: trabalho.y
	yacc trabalho.y

trabalho: lex.yy.c y.tab.c
	gcc -o trabalho y.tab.c -ll
