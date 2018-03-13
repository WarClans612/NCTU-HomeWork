#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>
#include "symbolTable.h"
#include "genCode.h"

SymbolTable* BuildSymbolTable() {
	SymbolTable* table = (SymbolTable*) malloc(sizeof(SymbolTable));
	table->current_level = 0;
	table->data_count = 0;
	table->capacity = 1;
	table->table_entry = (TableEntry**) malloc(sizeof(TableEntry*));
	return table;
}

IdList* BuildIdList() {
	IdList* list = (IdList*) malloc(sizeof(IdList));
	list->data_count = 0;
	list->capacity = 1;
	list->id = (char**) malloc(sizeof(char*));
	return list;
}

void InsertIdList (IdList* list, char* id) {
	char* id_temp = strdup(id);
	
	if(list->data_count == list->capacity) {
		list->capacity *= 2;
		char** temp_id = list->id;
		list->id = (char**) malloc(sizeof(char*) * list->capacity);
		int i;
		for (i = 0; i < list->data_count; ++i) {
			list->id[i]  = temp_id[i];
		}
		free(temp_id);
	}
	list->id[list->data_count++] = id_temp;
	return;
}

void PrintIdList (IdList* list) {
	int i;
	for (i = 0; i < list->data_count; ++i) {
		printf("%s ", list->id[i]);
	}
	printf("\n");
}

void ResetIdList (IdList *list) {
	int i;
	for (i = 0; i < list->data_count; ++i) {
		free(list->id[i]);
	}
	list->data_count = 0;
	list->capacity = 1;
	list->id = (char**) malloc(sizeof(char*));
}

TableEntry* BuildTableEntry (char* name, const char* kind, int level, Type* type, Attribute* attr, int number) {
	TableEntry* entry = (TableEntry*) malloc(sizeof(TableEntry));
	strcpy(entry->name, name);
	strcpy(entry->kind, kind);
	entry->level = level;
	entry->type = type;
	entry->attr = attr;
	entry->number = number;
	return entry;
}

void InsertTableEntry (SymbolTable* table, TableEntry* entry) {
	if (FindEntryInScope(table, entry->name) != NULL || FindEntryLoopVar(table, entry->name) != NULL) {
		printf ("<Error> found in Line %d: symbol %s is redeclared\n", linenum, entry->name);
		return;
	}
	
	if(table->data_count >= table->capacity) {
		table->capacity *= 2;
		TableEntry** entry_temp = table->table_entry;
		table->table_entry = (TableEntry**) malloc(sizeof(TableEntry*) * table->capacity);
		int i;
		for (i = 0; i < table->data_count; ++i) {
			table->table_entry[i] = entry_temp[i];
		}
		free(entry_temp);
	}
	table->table_entry[table->data_count++] = entry;
	return;
}

int InsertLoopTableEntry (SymbolTable* table, TableEntry* entry) {
	if (FindEntryLoopVar(table, entry->name) != NULL) {
		printf ("<Error> found in Line %d: symbol %s is redeclared\n", linenum, entry->name);
		return 0;
	}
	
	if(table->data_count >= table->capacity) {
		table->capacity *= 2;
		TableEntry** entry_temp = table->table_entry;
		table->table_entry = (TableEntry**) malloc(sizeof(TableEntry*) * table->capacity);
		int i;
		for (i = 0; i < table->data_count; ++i) {
			table->table_entry[i] = entry_temp[i];
		}
		free(entry_temp);
	}
	table->table_entry[table->data_count++] = entry;
	return 1;
}

void PopTableEntry (SymbolTable* table) {
	TableEntry* entry;
	int i;
	for (i = 0; i < table->data_count; ++i) {
		entry = table->table_entry[i];
		if (entry->level == table->current_level && strcmp(entry->kind, "loop variable") != 0) {
			free(entry);
			if ( i < table->data_count - 1) {
				--table->data_count;
				table->table_entry[i] = table->table_entry[table->data_count];
				--i;
				continue;
			}
			else {
				--table->data_count;
			}
		}
	}
	return;
}

void PopLoopTableEntry (SymbolTable* table) {
	TableEntry* entry;
	int i;
	for (i = 0; i < table->data_count; ++i) {
		entry = table->table_entry[i];
		if(entry->level == table->current_level && strcmp(entry->kind, "loop variable") == 0) {
			free(entry);
			if ( i < table->data_count - 1) {
				--table->data_count;
				table->table_entry[i] = table->table_entry[table->data_count];
				--i;
				continue;
			}
			else {
				--table->data_count;
			}
		}
	}
	return;
}

void InsertTableEntryFromList (SymbolTable* table, IdList* id_list, const char* kind, Type* type, Attribute* attr) {
	int i;
	for (i=0; i < id_list->data_count; ++i) {
		if(type->array_comp != NULL || strcmp(kind, "constant") == 0 || table->current_level == 0) var_num--;//Just to prevent array from increasing the number
		TableEntry* entry = BuildTableEntry(id_list->id[i], kind, table->current_level, type, attr, var_num++);
		InsertTableEntry(table, entry);
	}
	return;
}

void PrintSymbolTable (SymbolTable* table) {
	if( !Opt_D ) return;
	
	int i;
	for(i=0;i< 110;i++)
		printf("=");
	printf("\n");
	printf("%-33s%-11s%-11s%-17s%-11s\n","Name","Kind","Level","Type","Attribute");
	for(i=0;i< 110;i++)
		printf("-");
	printf("\n");
	
	TableEntry* entry;
	for (i = 0; i < table->data_count; ++i) {
		entry = table->table_entry[i];
		if(entry->level == table->current_level) {
			printf("%-33s%-11s", entry->name, entry->kind);
			if(entry->level == 0) printf("%d%-10s", entry->level, "(global)");
			else printf("%d%-10s", entry->level, "(local)");
			printf("%-17s", GetType(entry->type, 0));
			PrintAttribute(entry->attr);
			printf("\n");
		}
	}
	
	for(i=0;i< 110;i++)
		printf("-");
	printf("\n");
	return;
}

char* GetType (const Type* t, int dimension) {
	if (t == NULL) return "err";
	ArrayComp* arr = t->array_comp;
	char* answer = (char*) malloc(sizeof(char) * 1000);
	char* buffer = (char*) malloc(sizeof(char) * 1000);
	answer[0] = '\0';
	buffer[0] = '\0';
	
	while(arr != NULL) {
		if (dimension) --dimension;
		else {
			snprintf(buffer, 1000, "[%d]", arr->right - arr->left + 1);
			strcat(buffer, answer);
			strcpy(answer, buffer);
		}
		arr = arr->next;
	}
	
	strcpy(buffer, answer);
	memset(answer, 0, 1000);
	snprintf(answer, strlen(t->name) + 2, "%s", t->name);
	if (strlen(buffer) != 0) {
		strcat(answer, " ");
		strcat(answer, buffer);
	}
	
	free(buffer);
	if(dimension != 0) return "err";
	return answer;
}

int GetActualDimension (const Type* t) {
	if (t == NULL) return 0;
	int i = 0;
	ArrayComp* arr = t->array_comp;
	
	while(arr != NULL) {
		arr = arr->next;
		++i;
	}
	return i;
}

void PrintAttribute (Attribute* attri) {
	if (attri == NULL) return;
	else if (attri->val != NULL) {
		if (strcmp(attri->val->type->name, "string") == 0)
			printf("%s", attri->val->sval);
		else if(strcmp(attri->val->type->name, "integer") == 0)
			printf("%d", attri->val->ival);
		else if(strcmp(attri->val->type->name, "real") == 0)
			printf("%f", attri->val->dval);
		else if(strcmp(attri->val->type->name, "boolean") == 0)
			printf("%s", attri->val->sval);
	}
	else if(attri->type_list != NULL) {
		TypeList* list = attri->type_list;
		printf("%s", GetType(list->type[0], 0));
		int i;
		for (i = 1; i < list->data_count; ++i) {
			printf(", %s", GetType(list->type[i], 0));
		}
	}
	return;
}

Type* BuildType (const char* name) {
	Type* type = (Type*) malloc(sizeof(Type));
	strcpy(type->name, name);
	type->array_comp = NULL;
	return type;
}

Type* AddArrayToType (Type* type, char* l, char* r) {
	int left = atoi(l);
	int right = atoi(r);
	if (right <= left || left < 0 || right < 0) strcpy(type->name, "err");
	if(type->array_comp == NULL) {
		type->array_comp = (ArrayComp*) malloc(sizeof(ArrayComp));
		type->array_comp->left = left;
		type->array_comp->right = right;
		type->array_comp->next = NULL;
	}
	else {
		ArrayComp* arr = type->array_comp;
		while(arr->next != NULL) arr = arr->next;
		arr->next = (ArrayComp*) malloc(sizeof(ArrayComp));
		arr->next->left = left;
		arr->next->right = right;
		arr->next->next = NULL;
	}
	return type;
}

TypeList* AddTypeToList (TypeList* list, Type* type, int count) {
	if(list == NULL) {
		list = (TypeList*) malloc(sizeof(TypeList));
		list->type = (Type**) malloc(sizeof(Type*));
		list->data_count = 0;
		list->capacity = 1;
	}
	int i;
	if(list->data_count + count >= list->capacity) {
		while (list->data_count + count >= list->capacity) list->capacity *= 2;
		Type** type_temp = list->type;
		list->type = (Type**) malloc(sizeof(Type*) * list->capacity);
		for (i = 0; i < list->data_count; ++i) {
			list->type[i] = type_temp[i];
		}
		free(type_temp);
	}
	for(i = 0; i < count; ++i) {
		list->type[list->data_count++] = type;
	}
	return list;
}

TypeList* ExtendTypeList (TypeList* dest, TypeList* src) {
	int i;
	if (dest->capacity - dest->data_count < src->data_count) {
		while (dest->capacity - dest->data_count < src->data_count) {
			dest->capacity *= 2;
		}
		Type** type_temp = dest->type;
		dest->type = (Type**) malloc(sizeof(Type*) * dest->capacity);
		for( i = 0; i < dest->data_count; ++i) {
			dest->type[i] = type_temp[i];
		}
		free(type_temp);
	}
	for( i = 0; i < src->data_count; ++i) {
		dest->type[dest->data_count++] = src->type[i];
	}
	free(src);
	return dest;
}

Value* BuildValue (const char* name, const char* value) {
	Type* type = BuildType(name);
	Value* val = (Value*) malloc(sizeof(Value));
	val->type = type;
	val->sval = NULL;
	val->ival = 0;
	if(strcmp(type->name, "real") == 0) {
		val->dval = atof(value);
		val->sval = strdup(value);
	}
	else if (strcmp(type->name, "string") == 0) {
		val->sval = strdup("\"");
		strcat(val->sval, value);
		strcat(val->sval, "\"");
	}
	else if (strcmp(type->name, "integer") == 0) {
		val->ival =  atoi(value);
	}
	else if (strcmp(type->name, "boolean") == 0) {
		val->sval = strdup(value);
	}
	return val;
}

Value* SubOp (Value* val) {
	if (val == NULL) return NULL;
	Type* type = val->type;
	if(strcmp(type->name, "real") == 0) {
		val->dval *= -1.0;
		char* temp = val->sval;
		val->sval = (char*) malloc((strlen(val->sval) + 2) * sizeof(char));
		val->sval[0] = '-';
		strcat(val->sval, temp);
		free(temp);
	}
	else if (strcmp(type->name, "integer") == 0) {
		val->ival *= -1;
	}
	return val;
}

Attribute* BuildConstAttribute (Value* val) {
	Attribute* attri = (Attribute*) malloc(sizeof(Attribute));
	attri->val = val;
	attri->type_list = NULL;
	return attri;
}

Attribute* BuildFuncAttribute (TypeList* list) {
	Attribute* attri = (Attribute*) malloc(sizeof(Attribute));
	attri->type_list = list;
	attri->val = NULL;
	return attri;
}

TableEntry* FindEntryInScope (SymbolTable* table, char* name) {
	int i;
	for (i = 0; i < table->data_count; ++i) {
		TableEntry* entry = table->table_entry[i];
		if(strcmp(name, entry->name) == 0 && entry->level == table->current_level  && strcmp(entry->kind, "loop variable") != 0) {
			return entry;
		}
	}
	return NULL;
}

TableEntry* FindEntryInRange (SymbolTable* table, char* name) {
	int i, level;
	for (level = table->current_level; level >= 0; --level) {	
		for (i = 0; i < table->data_count; ++i) {
			TableEntry* entry = table->table_entry[i];
			if(strcmp(name, entry->name) == 0 && entry->level == level && strcmp(entry->kind, "function") != 0) {
				return entry;
			}
		}
	}
	return NULL;
}

TableEntry* FindEntryInGlobal (SymbolTable* table, char* name) {
	int i;
	for (i = 0; i < table->data_count; ++i) {
		TableEntry* entry = table->table_entry[i];
		if (strcmp(name, entry->name) == 0 && entry->level == 0  && strcmp(entry->kind, "function") == 0) {
			return entry;
		}
	}
	return NULL;
}

TableEntry* FindEntryLoopVar (SymbolTable* table, char* name) {
	int i;
	for ( i = 0; i < table->data_count; ++i) {
		TableEntry* entry = table->table_entry[i];
		if(strcmp(name, entry->name) == 0 && strcmp(entry->kind, "loop variable") == 0) {
			return entry;
		}
	}
	return NULL;
}

Expr* FindVarRef (SymbolTable* table, char* name) {
	Expr* exp = (Expr*) malloc(sizeof(Expr));
	TableEntry* table_temp = FindEntryInRange(table, name);
	if (table_temp == NULL) {
		strcpy(exp->kind, "err");
		strcpy(exp->kind, name);
		exp->current_dimension = 0;
		exp->table_entry = NULL;
		exp->para = NULL;
		printf("<Error> found in Line %d: symbol %s is not declared\n", linenum, name);
		return exp;
	}
	strcpy(exp->kind, "variable");
	strcpy(exp->name, name);
	exp->current_dimension = 0;
	exp->table_entry = table_temp;
	exp->type = exp->table_entry->type;
	return exp;
}

Expr* ConstExpr (Value* val) {
	Expr* exp = (Expr*) malloc(sizeof(Expr));
	strcpy(exp->kind, "const");
	exp->current_dimension = 0;
	exp->table_entry = NULL;
	exp->type = val->type;
	return exp;
}

Expr* FunctionCall (char* name, ExprList* list) {
	int i;
	Expr* exp = (Expr*) malloc(sizeof(Expr));
	strcpy(exp->kind, "function");
	strcpy(exp->name, name);
	exp->current_dimension = 0;
	exp->table_entry = FindEntryInGlobal (symbol_table, name);
	if(exp->table_entry == NULL) {
		printf("<Error> found in Line %d: function %s is not declared\n", linenum, name);
		strcpy(exp->kind, "err");
		exp->para = NULL;
		return exp;
	}
	else {
		exp->type = exp->table_entry->type;
	}
	if(list == NULL) {
		exp->para = NULL;
	}
	else {
		TypeList* para = AddTypeToList(NULL, list->expr[0]->type, 1);
		for (i = 1; i < list->data_count; ++i) {
			AddTypeToList(para, list->expr[i]->type, 1);
		}
		exp->para = para;
	}
	if (CheckParameterNumber(exp)) {
		for (i = 0; i < exp->para->data_count && i < exp->table_entry->attr->type_list->data_count; ++i) {
			char* actual = GetType(exp->table_entry->attr->type_list->type[i], 0);
			char* received = GetType(list->expr[i]->type, list->expr[i]->current_dimension);
			if(strcmp(actual, received) != 0) {
				if (!(strcmp(actual, "real") == 0 && strcmp(received, "integer") == 0)) {
					printf("<Error> found in Line %d: function parameter mismatched, ", linenum);
					printf("actual: %s, received: %s\n", actual, received);
					return exp;
				}
			}
		}
	}
	return exp;
}

ExprList* BuildExprList (ExprList* list, Expr* exp) {
	int i;
	if(list == NULL) {
		list = (ExprList*) malloc(sizeof(ExprList));
		list->expr = (Expr**) malloc(sizeof(Expr*));
		list->capacity = 1;
		list->data_count = 0;
	}
	if(list->data_count == list->capacity) {
		list->capacity *= 2;
		Expr** exp_temp = list->expr;
		list->expr = (Expr**) malloc(sizeof(Expr*) * list->capacity);
		for (i = 0; i < list->data_count; ++i) {
			list->expr[i] = exp_temp[i];
		}
		free(exp_temp);
	}
	list->expr[list->data_count++] = exp;
	return list;
}

Expr* RelationalOp (Expr* left, Expr* right, char* op) {
	if (left == NULL || right == NULL)
		return NULL;
	Expr* exp = (Expr*) malloc(sizeof(Expr));
	strcpy(exp->kind, "variable");
	exp->current_dimension = 0;
	exp->table_entry = NULL;
	exp->type = BuildType("boolean");
	if (strcmp(left->kind, "err") == 0 || strcmp(right->kind, "err") == 0) {
		strcpy(exp->kind, "err");
		return exp;
	}
	char* left_type = GetType(left->type, left->current_dimension);
	char* right_type = GetType(right->type, right->current_dimension);
	if(!((strcmp(left_type, "real") == 0 && strcmp(right_type, "real") == 0) || 
		(strcmp(left_type, "integer") == 0 && strcmp(right_type, "integer") == 0))) {
		printf("<Error> found in Line %d: between relational operator are not integer or real\n", linenum);
		strcpy(exp->kind, "err");
		exp->type = BuildType(left->type->name);
		return exp;
	}
	return exp;
}

Expr* CalcOp (Expr* left, Expr* right, char* op) {
	if (left == NULL || right == NULL )
		return NULL;
	if (strcmp(left->kind, "err") == 0 || strcmp(right->kind, "err") == 0)
		return NULL;
	Expr* exp = (Expr*) malloc(sizeof(Expr));
	exp->current_dimension = 0;
	exp->table_entry = NULL;
	strcpy(exp->kind, "variable");
	char* left_type = GetType(left->type, left->current_dimension);
	char* right_type = GetType(right->type, right->current_dimension);
	
	if (strcmp(op, "+") == 0 && strcmp(left_type, "string") == 0 && strcmp(right_type, "string") == 0) {
		exp->type = BuildType("string");	
		return exp;
	}
	if (strcmp(op, "mod") == 0 && (strcmp(left_type, "integer") != 0 || strcmp(right_type, "integer") != 0)) {
		printf("<Error> found in Line %d: between 'mod' operator are not integer\n", linenum);
		strcpy(exp->kind, "err");
		exp->type = BuildType(left->type->name);
		return exp;
	}
	if(!((strcmp(left_type, "real") == 0 && strcmp(right_type, "integer") == 0) || 
		(strcmp(left_type, "integer") == 0 && strcmp(right_type, "real") == 0) ||
		(strcmp(left_type, "integer") == 0 && strcmp(right_type, "integer") == 0) ||
		(strcmp(left_type, "real") == 0 && strcmp(right_type, "real") == 0))) {
		printf("<Error> found in Line %d: between arithmetic operator are not integer or real\n", linenum);
		strcpy(exp->kind, "err");
		exp->type = BuildType(left->type->name);
		return exp;
	}
	
	if (strcmp(left_type, "real") == 0  || strcmp(right_type, "real") == 0) {
		exp->type = BuildType("real");
		return exp;
	}
	
	free(exp->type);
	free(exp);
	return left;
}

Expr* UnaryMinus(Expr* op)
{
	char* op_type = GetType(op->type, op->current_dimension);
	if (strcmp(op_type, "integer") == 0 || strcmp(op_type, "real") == 0) {
		return op;
	}
	Expr* exp = (Expr*) malloc(sizeof(Expr));
	exp->current_dimension = 0;
	exp->table_entry = NULL;
	strcpy(exp->kind, "err");
	exp->type = BuildType(op->type->name);
	return exp;
}

Expr* BooleanOp (Expr* left, Expr* right, char *op) {
	if (left == NULL || right == NULL)
		return NULL;
	if (strcmp(left->kind, "err") == 0 || strcmp(right->kind, "err") == 0)
		return NULL;
	Expr* exp = (Expr*) malloc(sizeof(Expr));
	exp->current_dimension = 0;
	exp->table_entry = NULL;
	strcpy(exp->kind, "variable");
	
	char* left_type = GetType(left->type, left->current_dimension);
	char* right_type = GetType(right->type, right->current_dimension);
	if(strcmp(left_type, "boolean") != 0 || strcmp(right_type, "boolean") != 0) {
		printf("<Error> found in Line %d: between boolean operator are not boolean\n", linenum);
		strcpy(exp->kind, "err");
		exp->type = BuildType("err");
		exp->type = BuildType(left->type->name);
		return exp;
	}
	
	free(exp->type);
	free(exp);
	return left;
}

void CheckFileName (char* file, char* name) {
	if(strcmp(file, name) != 0) printf("<Error> found in Line %d: program ID inconsistent with file name\n", linenum);
	return;
}

void CheckReturnStatement (Type* type, Expr* exp) {
	if (type == NULL || exp == NULL) return;
	if (strcmp(exp->kind, "err") == 0) return;
	
	if(strcmp(GetType(type, 0), GetType(exp->type, exp->current_dimension)) != 0) {
		printf("<Error> found in Line %d: return type mismatch, ", linenum);
	}
	return;
}

int CheckConstAssign (Expr* exp) {
	if (exp == NULL || exp->table_entry == NULL) return 1;
	if (strcmp(exp->kind, "err") == 0) return 1;
	if (strcmp(exp->table_entry->kind, "constant") == 0) {
		printf("<Error> found in Line %d: constant variable %s cannot be assigned\n", linenum, exp->table_entry->name);
		return 0;
	}
	if (strcmp(exp->table_entry->kind, "loop variable") == 0) {
		printf("<Error> found in Line %d: loop variable %s cannot be assigned\n", linenum, exp->table_entry->name);
		return 0;
	}
	return 1;
}

int CheckAssignmentType (Expr* left, Expr* right) {
	if (left == NULL || right == NULL) return 0;
	if (strcmp(left->kind, "err") == 0 || strcmp(right->kind, "err") == 0) return 0;
	char* left_type = GetType(left->type, left->current_dimension);
	char* right_type = GetType(right->type, right->current_dimension);
	if (strcmp(left_type, right_type) != 0) {
		if (strcmp(left_type, "real") != 0 || strcmp(right_type, "integer") != 0) {
			printf("<Error> found in Line %d: assignment type mismatch, ", linenum);
			printf("LHS %s, but RHS %s\n", left_type, right_type);
			return 0;
		}
	}
	return 1;
}

int AssignmentCheck (Expr* left, Expr* right) {
	if (CheckConstAssign(left)) return CheckAssignmentType(left, right);
	return 0;
}

int SimpleScalarCheck (Expr* exp) {
	if (exp == NULL) return 1;
	char* type = GetType(exp->type, exp->current_dimension);
	if (strcmp(type, "integer") != 0 && strcmp(type, "real") != 0 && strcmp(type, "boolean") != 0 && strcmp(type, "string") != 0) {
		printf("<Error> found in Line %d: expression must be scalar type\n", linenum);
		return 0;
	}
	return 1;
}

int CheckParameterNumber (Expr* exp) {
	if (exp == NULL) return 1;
	if (strcmp(exp->kind, "err") == 0) return 1;
	if (strcmp(exp->kind, "function") != 0) return 1;
	

	if (exp->para == NULL && exp->table_entry->attr->type_list != NULL) {
		printf("<Error> found in Line %d: function '%s' received too few arguments\n", linenum, exp->name);
		return 0;
	}
	if (exp->para != NULL && exp->table_entry->attr->type_list == NULL) {
		printf("<Error> found in Line %d: function '%s' received too many arguments\n", linenum, exp->name);
		return 0;
	}
	if (exp->para == NULL && exp->table_entry->attr->type_list == NULL) {
		return 0;
	}
	if (exp->para->data_count > exp->table_entry->attr->type_list->data_count) {
		printf("<Error> found in Line %d: function '%s' received too many arguments\n", linenum, exp->name);
		return 0;
	}
	if (exp->para->data_count < exp->table_entry->attr->type_list->data_count) {
		printf("<Error> found in Line %d: function '%s' received too few arguments\n", linenum, exp->name);
		return 0;
	}
	
	return 1;
}

void CheckCondExpression (Expr* exp) {
	if(exp == NULL || strcmp(exp->kind, "err") == 0 || 
		strcmp(GetType(exp->type, exp->current_dimension), "boolean") != 0) {
		printf("<Error> found in Line %d: not boolean types for condition\n", linenum);
	}
	return;
}

void CheckArrayIndex (Expr* exp) {
	char* type = GetType(exp->type, exp->current_dimension);
	if (strcmp(type, "integer") != 0)
		printf("<Error> found in Line %d: array index is not integer value, received: '%s'\n", linenum, type);
	return;
}

int CheckFunctionAttribute (TypeList* list) {
	if(list == NULL) return 1;
	int i;
	for (i = 0; i < list->data_count; ++i) {
		if( strcmp (list->type[i]->name, "err") == 0) return 0;
	}
	return 1;
}