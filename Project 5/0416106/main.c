#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbolTable.h"
#include "genCode.h"

extern int yyparse();
extern FILE* yyin;
extern SymbolTable* symbol_table;
extern TableEntry* entry_buffer;
extern IdList* id_buffer;
char* file_name;
FILE* JavaOutput;

int main( int argc, char **argv )
{
	symbol_table = BuildSymbolTable();
	id_buffer = BuildIdList();
	
	if( argc != 2 ) {
		fprintf(  stdout,  "Usage:  ./parser  [filename]\n"  );
		exit(0);
	}

	FILE *fp = fopen( argv[1], "r" );
	if( fp == NULL )  {
		fprintf( stdout, "Open  file  error\n" );
		exit(-1);
	}
	
	//Retrieving only file name without extension
	char* fn = strdup(argv[1]);
	fn[strlen(fn) - 2] = '\0';
	char* JavaOutName = strstr(fn, "/");
	if (JavaOutName != NULL) ++JavaOutName;
	else JavaOutName = fn;
	file_name = strdup(JavaOutName);
	strcat(JavaOutName, ".j");
	
	//Opening file for Jasmin Java ByteCode
	JavaOutput = fopen(JavaOutName, "w");
	
	yyin = fp;
	yyparse();	/* primary procedure of parser */
	
	fprintf( stdout, "\n|--------------------------------|\n" );
	fprintf( stdout, "|  There is no syntactic error!  |\n" );
	fprintf( stdout, "|--------------------------------|\n" );
	
	fclose(JavaOutput);
	exit(0);
}