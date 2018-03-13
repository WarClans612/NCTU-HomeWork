all:
	yacc -d -v parser.y
	lex scanner.l
	gcc lex.yy.c y.tab.c -ly -ll -o parser
