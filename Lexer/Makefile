a.out: lex.yy.o
		gcc lex.yy.o -lfl

lex.yy.o: lex.yy.c
		gcc -c lex.yy.c -lfl

lex.yy.c: ass3_16CS30019.l ass3_16CS30019_main.c
		flex ass3_16CS30019.l ass3_16CS30019_main.c

clean: 
		rm -rf a.out lex.yy.c lex.yy.o