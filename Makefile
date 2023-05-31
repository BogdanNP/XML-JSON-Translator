all:	lex yacc compile

lex:	translator.l
	lex translator.l

yacc:	translator.y
	yacc -d translator.y

compile: y.tab.c lex.yy.c
	 gcc -o TRANSLATOR lex.yy.c y.tab.c -ly -ll

clean:	
	rm -rf y.tab.c y.tab.h lex.yy.c TRANSLATOR
