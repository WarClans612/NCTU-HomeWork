%{
#include <stdio.h>
#include <stdlib.h>

extern int linenum;             /* declared in lex.l */
extern FILE *yyin;              /* declared by lex */
extern char *yytext;            /* declared by lex */
extern char buf[256];           /* declared in lex.l */
%}

%token COMMA
%token SEMICOLON
%token COLON
%token '(' ')'
%token '[' ']'

%left '+' '-'
%left '*' '/' '%'
%token ASSIGN
%nonassoc LT LE NE GT GE EQ
%left NOT
%left AND
%left OR

%token IF
%token THEN
%token ELSE

%token WHILE
%token FOR
%token DO

%token ARRAY
%token BOOL
%token INT
%token REAL
%token STR

%token BOOL_CONST
%token INT_CONST
%token REAL_CONST
%token STR_CONST

%token ID

%token BEGI
%token END
%token OF
%token PRINT
%token READ
%token RETURN
%token TO
%token VAR
%token DEF

%%

program		: programname SEMICOLON programbody END identifier
		;

programname	: identifier
		;
		
programbody	: data_decls func_decls comp_stmt
		;

data_decls	: var_decl data_decls
		| const_decl data_decls
		|
		;

var_decl	: VAR id_list COLON scalar_type SEMICOLON
		| VAR id_list COLON struct_type SEMICOLON
		;
		
const_decl	: VAR id_list COLON liter_const SEMICOLON
		;
		
func_decls	: func_decl func_decls
		|
		;
		
func_decl	: identifier '(' decl_args ')' COLON type SEMICOLON comp_stmt END identifier
		| proc_decl
		;
		
proc_decl	: identifier '(' decl_args ')' SEMICOLON comp_stmt END identifier
		;
		
decl_args	: decl_list
		|
		;
		
decl_list	: declaration SEMICOLON decl_list
		| declaration
		;
		
declaration	: id_list COLON type
		;
			
id_list		: identifier COMMA id_list
		| identifier
		;

identifier	: ID
		;
		
type		: scalar_type
		| struct_type
		;

scalar_type	: BOOL
		| INT
		| REAL
		| STR
		;

struct_type : ARRAY INT_CONST TO INT_CONST OF type
		;
		
liter_const	: BOOL_CONST
		| INT_CONST
		| REAL_CONST
		| STR_CONST
		;
		
statements	: comp_stmt statements
		| simp_stmt statements
		| cond_stmt statements
		| while_stmt statements
		| for_stmt statements
		| return_stmt statements
		| func_invoc SEMICOLON statements
		|
		;
		
comp_stmt	: BEGI data_decls statements END
		;

simp_stmt	: var_ref ASSIGN expression SEMICOLON
		| PRINT var_ref SEMICOLON
		| PRINT expression SEMICOLON
		| READ var_ref SEMICOLON
		;
		
cond_stmt	: IF bool_expr THEN statements ELSE statements END IF
		| IF bool_expr THEN statements END IF
		;

while_stmt	: WHILE bool_expr DO statements END DO
		;

for_stmt	: FOR identifier ASSIGN INT_CONST TO INT_CONST DO statements END DO
		;

return_stmt	: RETURN expression SEMICOLON
		;

var_ref		: identifier
		| identifier arr_indices
		;

arr_indices	: '[' int_expr ']' arr_indices
		|
		;

func_invoc	: identifier '(' expr_args ')'
		;

expr_args	: expr_list
		|
		;

expr_list	: expression COMMA expr_list
		| expression
		;

bool_expr	: expression
		;

int_expr	: expression
		;

expression	: expression '+' expression
		| expression '-' expression
		| expression '*' expression
		| expression '/' expression
		| expression '%' expression
		| '-' expression %prec '*'
		| '(' expression ')'
		| expression LT expression
		| expression LE expression
		| expression NE expression
		| expression GT expression
		| expression GE expression
		| expression EQ expression
		| NOT expression
		| expression AND expression
		| expression OR expression
		| liter_const
		| func_invoc
		| var_ref
		;

%%

int yyerror( char *msg )
{
        fprintf( stderr, "\n|--------------------------------------------------------------------------\n" );
	fprintf( stderr, "| Error found in Line #%d: %s\n", linenum, buf );
	fprintf( stderr, "|\n" );
	fprintf( stderr, "| Unmatched token: %s\n", yytext );
        fprintf( stderr, "|--------------------------------------------------------------------------\n" );
        exit(-1);
}

int  main( int argc, char **argv )
{
	if( argc != 2 ) {
		fprintf(  stdout,  "Usage:  ./parser  [filename]\n"  );
		exit(0);
	}

	FILE *fp = fopen( argv[1], "r" );
	
	if( fp == NULL )  {
		fprintf( stdout, "Open  file  error\n" );
		exit(-1);
	}
	
	yyin = fp;
	yyparse();

	fprintf( stdout, "\n" );
	fprintf( stdout, "|--------------------------------|\n" );
	fprintf( stdout, "|  There is no syntactic error!  |\n" );
	fprintf( stdout, "|--------------------------------|\n" );
	exit(0);
}
