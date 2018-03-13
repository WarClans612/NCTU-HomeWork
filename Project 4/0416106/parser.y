%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbolTable.h"
#define MAX_LINE_LENG			256

extern int linenum;
extern FILE *yyin;
extern char *yytext;
extern char buf[MAX_LINE_LENG];
extern int yylex(void);
extern char *file_name;
int yyerror(char*);

SymbolTable* symbol_table;
TableEntry* entry_buffer;
IdList* id_buffer;
Type* return_buf;
int has_ret = 0;
int loop_counter = 0;
%}

%union {
	char* text;
	int nodetype;
	Value* value;
	Type* type;
	TableEntry* table_entry;
	TypeList* type_list;
	Expr* expression;
	ExprList* expr_list;
}

%token <text> COMMA
%token <text> SEMICOLON
%token <text> COLON

%token <text> ASSIGN
%left <text> OR
%left <text> AND
%nonassoc <text> NE EQ
%nonassoc <text> LT LE GT GE
%left <text> '+' '-'
%left <text> '*' '/' '%'
%left <text> NOT
%token <text> '(' ')' '[' ']'

%token <text> IF
%token <text> THEN
%token <text> ELSE

%token <text> WHILE
%token <text> FOR
%token <text> DO

%token <text> ARRAY
%token <text> BOOL
%token <text> INT
%token <text> REAL
%token <text> STR

%token <text> BOOL_CONST
%token <text> INT_CONST
%token <text> OCTAL_CONST
%token <text> REAL_CONST
%token <text> STR_CONST

%token <text> ID

%token <text> BEGI
%token <text> END
%token <text> OF
%token <text> PRINT
%token <text> READ
%token <text> RETURN
%token <text> TO
%token <text> VAR
%token <text> DEF

%type <text> programname int_const
%type <type> scalar_type type optional_type struct_type
%type <type_list> declaration decl_args decl_list
%type <value> liter_const
%type <expression> var_ref expression return_stmt func_invoc
%type <expr_list> expr_args expr_list


/* Start Symbol */
%start program
%%

program		: programname 
		{
			CheckFileName(file_name, $1);
			TableEntry* entry_temp = BuildTableEntry($1, "program", symbol_table->current_level, BuildType("void"), NULL);
			InsertTableEntry(symbol_table, entry_temp);
			
		}
		SEMICOLON programbody 
		{
			if (has_ret) printf("<Error> found in Line %d: program should not have a return statement\n", linenum);
		}
		END
		{
			PrintSymbolTable(symbol_table);
		}
		ID
		{
			if(strcmp($1, $8) != 0) printf("<Error> found in Line %d: program end ID '%s' inconsistent with beginning ID '%s'\n", linenum, $8, $1);
			CheckFileName(file_name, $8);
		}
		;

programname	: ID
		;
		
programbody	: data_decls func_decls comp_stmt
		;

data_decls	: data_decls var_decl
		| data_decls const_decl
		|
		;

var_decl	: VAR id_list COLON scalar_type SEMICOLON
		{
			if(strcmp($4->name, "err") != 0) {
				InsertTableEntryFromList(symbol_table, id_buffer, "variable", $4, NULL);
			}
			ResetIdList(id_buffer);
		}
		| VAR id_list COLON struct_type SEMICOLON
		{
			if(strcmp($4->name, "err") != 0) {
				InsertTableEntryFromList(symbol_table, id_buffer, "variable", $4, NULL);
			}
			ResetIdList(id_buffer);
		}
		;
		
const_decl	: VAR id_list COLON liter_const SEMICOLON
		{
			Attribute* attr_temp = BuildConstAttribute($4);
			InsertTableEntryFromList(symbol_table, id_buffer, "constant", $4->type, attr_temp);
			ResetIdList(id_buffer);
		}
		;
		
func_decls	: func_decls func_decl
		|
		;
		
func_decl	: ID '(' { ++symbol_table->current_level; }
		decl_args 
		')' { --symbol_table->current_level; }
		optional_type
		{
			return_buf = $7;
			if ($7->array_comp != NULL)
				printf("<Error> found in Line %d: expected return value can only be scalar type\n", linenum);
		}
		SEMICOLON 
		comp_stmt 
		END ID
		{
			if ($7->array_comp == NULL) {
				if (CheckFunctionAttribute($4)) {
					Attribute* func_attr = BuildFuncAttribute($4);
					TableEntry* temp_entry = BuildTableEntry($1, "function", symbol_table->current_level, $7, func_attr);
					InsertTableEntry(symbol_table, temp_entry);
				}
			}
			return_buf = NULL;
			has_ret = 0;
			if(strcmp($1, $12) != 0) printf("<Error> found in Line %d: function end ID '%s' inconsistent with beginning ID '%s'\n", linenum, $12, $1);
		}
		;
		
decl_args	: decl_list { $$ = $1; }
		| { $$ = NULL; }
		;
		
decl_list	: decl_list SEMICOLON declaration
		{ 
			if ($3 != NULL) $$ = ExtendTypeList($1, $3);
			else $$ = $1;
		}
		| declaration { $$ = $1; }
		;
		
declaration	: id_list COLON type
		{
			$$ = AddTypeToList(NULL, $3, id_buffer->data_count);
			if (strcmp($3->name, "err") != 0) {
				InsertTableEntryFromList(symbol_table, id_buffer, "parameter", $3, NULL);
			}
			ResetIdList(id_buffer);
		}
		;
			
id_list		: id_list COMMA ID { InsertIdList(id_buffer, $3); }
		| ID { InsertIdList(id_buffer, $1); }
		;
		
optional_type	: 	COLON type { $$ = $2; }
		| { $$ = BuildType("void"); }
		;

type		: scalar_type { $$ = $1; }
		| struct_type { $$ = $1; }
		;

scalar_type	: BOOL { $$ = BuildType("boolean"); }
		| INT { $$ = BuildType("integer"); }
		| REAL { $$ = BuildType("real"); }
		| STR { $$ = BuildType("string"); }
		;

int_const : INT_CONST { $$ = $1; }
		| OCTAL_CONST { $$ = $1; }
		;
		
struct_type : ARRAY int_const TO int_const OF type
		{
			Type* temp = AddArrayToType($6, $2, $4);
			if(strcmp(temp->name, "err") == 0) {
				printf("<Error> found in Line %d: incorrect dimension declaration for array ", linenum);
				PrintIdList(id_buffer);
			}
			$$ = temp;
		}
		;
		
liter_const	: BOOL_CONST { $$ = BuildValue("boolean", $1); }
		| int_const { $$ = BuildValue("integer", $1); }
		| '-' int_const { $$ = SubOp(BuildValue("integer", $1)); }
		| REAL_CONST { $$ = BuildValue("real", $1); }
		| '-' REAL_CONST { $$ = SubOp(BuildValue("real", $1)); }
		| STR_CONST { $$ = BuildValue("string", $1); }
		;
		
statements	: statements comp_stmt
		| statements simp_stmt
		| statements cond_stmt
		| statements while_stmt
		| statements for_stmt
		| statements return_stmt
		{
			CheckReturnStatement(return_buf, $2);
			has_ret = 1;
		}
		| statements func_invoc SEMICOLON
		|
		;
		
comp_stmt	: BEGI { ++symbol_table->current_level; }
		data_decls
		statements 
		END
		{
			PrintSymbolTable(symbol_table);
			PopTableEntry(symbol_table);
			--symbol_table->current_level;
		}
		;

simp_stmt	: var_ref ASSIGN expression SEMICOLON
		{
			int a = SimpleScalarCheck($1);
			int b = SimpleScalarCheck($3);
			if ( a && b ) AssignmentCheck($1, $3);
		}
		| PRINT expression SEMICOLON { SimpleScalarCheck($2); }
		| READ var_ref SEMICOLON { SimpleScalarCheck($2); }
		;
		
cond_stmt	: IF expression
		{
			CheckCondExpression($2);
		}
		THEN statements optional_cond_stmt END IF
		;
		
optional_cond_stmt	: ELSE statements
		|
		;

while_stmt	: WHILE expression
		{
			CheckCondExpression($2);
		}
		 DO statements END DO
		;

for_stmt	: FOR ID ASSIGN int_const TO int_const DO 
		{
			TableEntry* entry_temp = BuildTableEntry($2, "loop variable", symbol_table->current_level, BuildType("integer"), NULL);
			++loop_counter;
			InsertLoopTableEntry(symbol_table, entry_temp);
			if ($6 < $4) printf("<Error> found in Line %d: loop parameter is not incremental\n", linenum);
		}
		statements END DO
		{
			PopLoopTableEntry(symbol_table);
		}
		;

return_stmt	: RETURN expression SEMICOLON { $$ = $2; }
		;

var_ref	: ID { $$ = FindVarRef(symbol_table, $1); }
		| var_ref arr_indices
		{
			$1->current_dimension += 1;
			$$ = $1;
		}
		;

arr_indices	: '[' expression ']' { CheckArrayIndex($2); }
		;

func_invoc	: ID '(' expr_args ')' { $$ = FunctionCall($1, $3); }
		;

expr_args	: expr_list
		| { $$ = NULL; }
		;

expr_list	: expr_list COMMA expression { $$ = BuildExprList($1, $3); }
		| expression { $$ = BuildExprList(NULL, $1); }
		;

expression	: expression '+' expression { $$ = CalcOp($1, $3, $2); }
		| expression '-' expression { $$ = CalcOp($1, $3, $2); }
		| expression '*' expression { $$ = CalcOp($1, $3, $2); }
		| expression '/' expression { $$ = CalcOp($1, $3, $2); }
		| expression '%' expression { $$ = CalcOp($1, $3, $2); }
		| '-' expression %prec '*'  { $$ = $2; }
		| '(' expression ')' { $$ = $2; }
		| expression LT expression { $$ = RelationalOp($1, $3, $2); }
		| expression LE expression { $$ = RelationalOp($1, $3, $2); }
		| expression NE expression { $$ = RelationalOp($1, $3, $2); }
		| expression GT expression { $$ = RelationalOp($1, $3, $2); }
		| expression GE expression { $$ = RelationalOp($1, $3, $2); }
		| expression EQ expression { $$ = RelationalOp($1, $3, $2); }
		| NOT expression { $$ = BooleanOp($2, $2, $1); }
		| expression AND expression { $$ = BooleanOp($1, $3, $2); }
		| expression OR expression { $$ = BooleanOp($1, $3, $2); }
		| liter_const { $$ = ConstExpr($1); }
		| func_invoc { $$ = $1; }
		| var_ref {$$ = $1; }
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
