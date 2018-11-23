a.out: lex.yy.o y.tab.o ass4_16CS30019_main.o
	gcc lex.yy.o y.tab.o ass4_16CS30019_main.o -lfl

ass4_16CS30019_main.o: ass4_16CS30019_main.c
	gcc -c ass4_16CS30019_main.c

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

y.tab.o: y.tab.c
	gcc -c y.tab.c

lex.yy.c: ass4_16CS30019.l y.tab.h
	flex ass4_16CS30019.l

y.tab.c: ass4_16CS30019.y
	yacc -dtv ass4_16CS30019.y -W

y.tab.h: ass4_16CS30019.y
	yacc -dtv ass4_16CS30019.y -W

clean:
	rm lex.yy.c y.tab.c y.tab.h lex.yy.o y.tab.o ass4_16CS30019_main.o y.output a.out

test: 
	./a.out < ass4_16CS30019_test.c
