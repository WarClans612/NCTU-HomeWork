%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbolTable.h"
#include "genCode.h"
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
int var_num = 1;
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
			TableEntry* entry_temp = BuildTableEntry($1, "program", symbol_table->current_level, BuildType("void"), NULL, var_num);
			InsertTableEntry(symbol_table, entry_temp);
			ProgramStart(file_name);
			
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
			ProgramEnd();
		}
		;

programname	: ID
		;
		
programbody	: data_decls func_decls 
		{
			GenerateMainProcedure();
			GenerateReadPreparation();
		}
		comp_stmt
		;

data_decls	: data_decls var_decl
		| data_decls const_decl
		|
		;

var_decl	: VAR id_list COLON scalar_type SEMICOLON
		{
			if(strcmp($4->name, "err") != 0) {
				InsertTableEntryFromList(symbol_table, id_buffer, "variable", $4, NULL);
				if (symbol_table->current_level == 0) GenerateGlobalVariable (id_buffer, $4);
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
		
func_decl	: ID '(' 
		{
			++symbol_table->current_level;
			var_num = 0;
		}
		decl_args 
		')' { --symbol_table->current_level; }
		optional_type
		{
			return_buf = $7;
			if ($7->array_comp != NULL) {
				printf("<Error> found in Line %d: expected return value can only be scalar type\n", linenum);
			}
			GenerateFunctionStart ($1, $4, $7);
			if ($7->array_comp == NULL && CheckFunctionAttribute($4)) {
				Attribute* func_attr = BuildFuncAttribute($4);
				TableEntry* temp_entry = BuildTableEntry($1, "function", symbol_table->current_level, $7, func_attr, var_num);
				InsertTableEntry(symbol_table, temp_entry);
			}
		}
		SEMICOLON 
		comp_stmt 
		END ID
		{
			GenerateFunctionEnd();
			return_buf = NULL;
			has_ret = 0;
			var_num = 1;
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
			GenerateReturnFunction($2);
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
			if ( a && b ) {
				if (AssignmentCheck($1, $3)) GenerateSave($1, $3);
			}
			PopInstructionStack();
		}
		| PRINT
		{
			GeneratePrintPreparation();
		}
		expression SEMICOLON
		{
			if (SimpleScalarCheck($3)) GeneratePrintInvoke ($3);
			PopInstructionStack();
		}
		| READ var_ref SEMICOLON
		{
			if (SimpleScalarCheck($2)) GenerateReadInvoke ($2);
			PopInstructionStack();
		}
		;
	
cond_stmt	: IF expression
		{
			GenerateConditionalChecking();
			CheckCondExpression($2);
		}
		THEN statements optional_cond_stmt END IF
		;
		
optional_cond_stmt	: 
		{
			PopInstructionStack();
			GenerateConditionalJump();
			PopInstructionStack();
		}
		ELSE statements
		{
			PopInstructionStack();
			GenerateElseConditionalJump();
			PopInstructionStack();
		}
		|
		{
			PopInstructionStack();
			GenerateEndConditionalJump();
			PopInstructionStack();
		}
		;

while_stmt	: WHILE 
		{
			GenerateWhileLoopPreparation();
			PopInstructionStack();
		}
		expression
		{
			GenerateWhileLoopExit();
			PopInstructionStack();
			CheckCondExpression($3);
		}
		 DO statements
		{
			GenerateWhileLoopEnd();
			PopInstructionStack();
		}
		END DO
		;

for_stmt	: FOR ID ASSIGN int_const TO int_const DO 
		{
			++symbol_table->current_level;
			TableEntry* entry_temp = BuildTableEntry($2, "loop variable", symbol_table->current_level, BuildType("integer"), NULL, var_num++);
			InsertLoopTableEntry(symbol_table, entry_temp);
			GenerateForLoopPreparation (entry_temp, atoi($4), atoi($6));
			if (atoi($6) < atoi($4)) printf("<Error> found in Line %d: loop parameter is not incremental\n", linenum);
			PopInstructionStack();
		}
		statements END DO
		{
			GenerateForLoopEnd (FindEntryLoopVar(symbol_table, $2));
			PopInstructionStack();
			PopLoopTableEntry(symbol_table);
			--symbol_table->current_level;
		}
		;

return_stmt	: RETURN expression SEMICOLON
		{
			PopInstructionStack();
			$$ = $2;
		}
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

func_invoc	: ID '(' expr_args ')'
		{
			Expr* temp_exp = FunctionCall($1, $3);
			if (temp_exp->table_entry != NULL) GenerateFunctionCall (temp_exp);
			$$ = temp_exp;
		}
		;

expr_args	: expr_list
		| { $$ = NULL; }
		;

expr_list	: expr_list COMMA expression { $$ = BuildExprList($1, $3); }
		| expression { $$ = BuildExprList(NULL, $1); }
		;

expression	: expression '+' expression
		{
			Expr* temp_exp = CalcOp($1, $3, $2);
			if (temp_exp != NULL && strcmp(temp_exp->kind, "err") != 0) GenerateCalcOp($1, $3, $2);
			$$ = temp_exp;
		}
		| expression '-' expression
		{
			Expr* temp_exp = CalcOp($1, $3, $2);
			if (temp_exp != NULL && strcmp(temp_exp->kind, "err") != 0) GenerateCalcOp($1, $3, $2);
			$$ = temp_exp;
		}
		| expression '*' expression
		{
			Expr* temp_exp = CalcOp($1, $3, $2);
			if (temp_exp != NULL && strcmp(temp_exp->kind, "err") != 0) GenerateCalcOp($1, $3, $2);
			$$ = temp_exp;
		}
		| expression '/' expression 
		{
			Expr* temp_exp = CalcOp($1, $3, $2);
			if (temp_exp != NULL && strcmp(temp_exp->kind, "err") != 0) GenerateCalcOp($1, $3, $2);
			$$ = temp_exp;
		}
		| expression '%' expression 
		{
			Expr* temp_exp = CalcOp($1, $3, $2);
			if (temp_exp != NULL && strcmp(temp_exp->kind, "err") != 0) GenerateCalcOp($1, $3, $2);
			$$ = temp_exp;
		}
		| '-' expression %prec '*' 
		{
			Expr* temp_exp = UnaryMinus($2);
			if (temp_exp != NULL && strcmp(temp_exp->kind, "err") != 0) GenerateUnaryminus($2);
			$$ = temp_exp;
		}
		| '(' expression ')' { $$ = $2; }
		| expression LT expression
		{
			Expr* temp_exp = RelationalOp($1, $3, $2);
			if (temp_exp != NULL && strcmp(temp_exp->kind, "err") != 0) GenerateRelationalOp($1, $3, $2);
			$$ = temp_exp;
		}
		| expression LE expression
		{
			Expr* temp_exp = RelationalOp($1, $3, $2);
			if (temp_exp != NULL && strcmp(temp_exp->kind, "err") != 0) GenerateRelationalOp($1, $3, $2);
			$$ = temp_exp;
		}
		| expression NE expression
		{
			Expr* temp_exp = RelationalOp($1, $3, $2);
			if (temp_exp != NULL && strcmp(temp_exp->kind, "err") != 0) GenerateRelationalOp($1, $3, $2);
			$$ = temp_exp;
		}
		| expression GT expression
		{
			Expr* temp_exp = RelationalOp($1, $3, $2);
			if (temp_exp != NULL && strcmp(temp_exp->kind, "err") != 0) GenerateRelationalOp($1, $3, $2);
			$$ = temp_exp;
		}
		| expression GE expression
		{
			Expr* temp_exp = RelationalOp($1, $3, $2);
			if (temp_exp != NULL && strcmp(temp_exp->kind, "err") != 0) GenerateRelationalOp($1, $3, $2);
			$$ = temp_exp;
		}
		| expression EQ expression
		{
			Expr* temp_exp = RelationalOp($1, $3, $2);
			if (temp_exp != NULL && strcmp(temp_exp->kind, "err") != 0) GenerateRelationalOp($1, $3, $2);
			$$ = temp_exp;
		}
		| NOT expression
		{
			Expr *temp_exp = BooleanOp($2, $2, $1);
			if (temp_exp != NULL && strcmp(temp_exp->kind, "err") != 0) GenerateBooleanOp($2, $2, $1);
			$$ = temp_exp;
		}
		| expression AND expression
		{
			Expr *temp_exp = BooleanOp($1, $3, $2);
			if (temp_exp != NULL && strcmp(temp_exp->kind, "err") != 0) GenerateBooleanOp($1, $3, $2);
			$$ = temp_exp;
		}
		| expression OR expression
		{
			Expr *temp_exp = BooleanOp($1, $3, $2);
			if (temp_exp != NULL && strcmp(temp_exp->kind, "err") != 0) GenerateBooleanOp($1, $3, $2);
			$$ = temp_exp;
		}
		| liter_const { GenerateConstantLoad($1); $$ = ConstExpr($1); }
		| func_invoc { $$ = $1; }
		| var_ref { GenerateLoad($1); $$ = $1; }
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
