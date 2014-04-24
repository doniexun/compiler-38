all: lex.yy.c/parser 
ex1.l/ex1.tab.c: ex1.l
	flex ex1.l
ex1.y/lex.yy.c: ex1.l/ex1.tab.c ex1.y 
	bison -d ex1.y  
lex.yy.c/parser:ex1.y/lex.yy.c lex.yy.c
	gcc -o parser ex1.tab.c -ll
clean:
	rm -rf *.[co]
	rm -rf parser
	rm -rf ex1.tab.h
	rm -rf *~


