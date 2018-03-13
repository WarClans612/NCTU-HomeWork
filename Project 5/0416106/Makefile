all:
	yacc -d -v parser.y
	flex scanner.l
	gcc main.c symbolTable.c genCode.c lex.yy.c y.tab.c -o parser -lfl
