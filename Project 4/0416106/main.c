#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbolTable.h"

extern int yyparse();
extern FILE* yyin;
extern SymbolTable* symbol_table;
extern TableEntry* entry_buffer;
extern IdList* id_buffer;
char* file_name;

int main( int argc, char **argv )
{
	symbol_table = BuildSymbolTable();
	id_buffer = BuildIdList();
	
	if( argc != 2 ) {
		fprintf(  stdout,  "Usage:  ./parser  [filename]\n"  );
		exit(0);
	}

	FILE *fp = fopen( argv[1], "r" );
	file_name = strdup(argv[1]);

	if( fp == NULL )  {
		fprintf( stdout, "Open  file  error\n" );
		exit(-1);
	}
	
	yyin = fp;
	yyparse();	/* primary procedure of parser */
	
	/*
	fprintf( stdout, "\n|--------------------------------|\n" );
	fprintf( stdout, "|  There is no syntactic error!  |\n" );
	fprintf( stdout, "|--------------------------------|\n" );
	*/
	exit(0);
}