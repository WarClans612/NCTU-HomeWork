#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include "symbolTable.h"
#include "genCode.h"

InstructionList insList;
LoopStack loopStack;
int label_num = -1;
char insBuf[1000];

void PushInstructionStack (const char* instruction) {
	insList.list[insList.data_count++] = strdup(instruction);
	//fprintf(JavaOutput, "instruction:%s datacount:%d linenum:%d\n", instruction, insList.data_count, linenum);
	return;
}

void PopInstructionStack () {
	int i;
	for (i = 0; i < insList.data_count; ++i) {
		fprintf(JavaOutput, "%s", insList.list[i]);
		//fprintf(JavaOutput, "Pop(i):%d datacount:%d\n", i, insList.data_count);
		//free(insList.list[i]);
	}
	insList.data_count = 0;
	return;
}

void ClearIntructionStack () {
	int i;
	for (i = 0; i < insList.data_count; ++i) {
		free(insList.list[i]);
	}
	insList.data_count = 0;
	return;
}

void ProgramStart(const char* file) {
	setvbuf (JavaOutput, NULL, _IONBF, BUFSIZ);
	insList.data_count = 0;
	loopStack.data_count = -1;
	fprintf(JavaOutput, "; %s.j\n",file);
	fprintf(JavaOutput, ".class public %s\n",file);
	fprintf(JavaOutput, ".super java/lang/Object\n\n");
	fprintf(JavaOutput, ".field public static _sc Ljava/util/Scanner;\n");
	return;
}

void ProgramEnd() {
	fprintf(JavaOutput, "return\n");
	fprintf(JavaOutput, ".end method\n");
	return;
}

void GenerateMainProcedure () {
	fprintf(JavaOutput, ".method public static main([Ljava/lang/String;)V\n");
	fprintf(JavaOutput, ".limit stack 100 ; up to 100 items can be pushed\n");
	fprintf(JavaOutput, ".limit locals 100 ; up to 100 variables can be pushed\n\n");
	return;
}

void GenerateGlobalVariable (IdList* id_list, Type* type) {
	int i;
	char* JavaType;
	if ( strcmp(type->name, "integer") == 0 ) JavaType = strdup("I");
	else if ( strcmp(type->name, "real") == 0 ) JavaType = strdup("F");
	else if ( strcmp(type->name, "boolean") == 0 ) JavaType = strdup("Z");
	
	for (i=0; i < id_list->data_count; ++i) {
		fprintf(JavaOutput, ".field public static %s %s\n",id_list->id[i], JavaType);
	}
	return;
}

void GenerateLoad (Expr* exp) {
	if (exp == NULL || exp->table_entry == NULL) return;
	if (strcmp(exp->table_entry->kind, "loop variable") == 0) {
		snprintf(insBuf, sizeof(insBuf), "iload %d\n", exp->table_entry->number);
	}
	else if (strcmp(exp->table_entry->kind, "constant") == 0) {
		if (strcmp(exp->table_entry->attr->val->type->name, "integer") == 0) {
			snprintf(insBuf, sizeof(insBuf), "ldc %d\n", exp->table_entry->attr->val->ival);
		}
		else if (strcmp(exp->table_entry->attr->val->type->name, "real") == 0) {
			snprintf(insBuf, sizeof(insBuf), "ldc %f\n", exp->table_entry->attr->val->dval);
		}
		else if (strcmp(exp->table_entry->attr->val->type->name, "string") == 0) {
			snprintf(insBuf, sizeof(insBuf), "ldc %s\n", exp->table_entry->attr->val->sval);
		}
		else if (strcmp(exp->table_entry->attr->val->type->name, "boolean") == 0) {
			snprintf(insBuf, sizeof(insBuf), "iconst_");
			if (strcmp(exp->table_entry->attr->val->sval, "true") == 0) strcat(insBuf, "1\n");
			else if (strcmp(exp->table_entry->attr->val->sval, "false") == 0) strcat(insBuf, "0\n");
		}
	}
	else if (exp->table_entry->level != 0 && (strcmp(exp->table_entry->kind, "variable") == 0 || strcmp(exp->table_entry->kind, "parameter") == 0)) {
		if (strcmp(exp->table_entry->type->name, "integer") == 0) {
			snprintf(insBuf, sizeof(insBuf), "iload %d\n", exp->table_entry->number);
		}
		else if (strcmp(exp->table_entry->type->name, "real") == 0) {
			snprintf(insBuf, sizeof(insBuf), "fload %d\n", exp->table_entry->number);
		}
		else if (strcmp(exp->table_entry->type->name, "boolean") == 0) {
			snprintf(insBuf, sizeof(insBuf), "iload %d\n", exp->table_entry->number);
		}
	}
	else if (exp->table_entry->level == 0 && strcmp(exp->table_entry->kind, "variable") == 0) {
		if (strcmp(exp->table_entry->type->name, "integer") == 0) {
			snprintf(insBuf, sizeof(insBuf), "getstatic %s/%s I\n", file_name, exp->table_entry->name);
		}
		else if (strcmp(exp->table_entry->type->name, "real") == 0) {
			snprintf(insBuf, sizeof(insBuf), "getstatic %s/%s F\n", file_name, exp->table_entry->name);
		}
		else if (strcmp(exp->table_entry->type->name, "boolean") == 0) {
			snprintf(insBuf, sizeof(insBuf), "getstatic %s/%s Z\n", file_name, exp->table_entry->name);
		}
	}
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	return;
}

void GenerateConstantLoad (Value* val) {
	if(strcmp(val->type->name, "real") == 0) {
		snprintf(insBuf, sizeof(insBuf), "ldc %f\n", val->dval);
	}
	else if (strcmp(val->type->name, "string") == 0) {
		snprintf(insBuf, sizeof(insBuf), "ldc %s\n", val->sval);
	}
	else if (strcmp(val->type->name, "integer") == 0) {
		snprintf(insBuf, sizeof(insBuf), "ldc %d\n", val->ival);
	}
	else if (strcmp(val->type->name, "boolean") == 0) {
		snprintf(insBuf, sizeof(insBuf), "iconst_");
		if (strcmp(val->sval, "true") == 0) strcat(insBuf, "1\n");
		else if (strcmp(val->sval, "false") == 0) strcat(insBuf, "0\n");
	}
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	return;
}

void GenerateSave (Expr* left, Expr* right) {
	if (left == NULL || left->table_entry == NULL) return;
	if (left->table_entry->level != 0 && strcmp(left->table_entry->kind, "variable") == 0) {
		if (strcmp(left->table_entry->type->name, "integer") == 0) {
			snprintf(insBuf, sizeof(insBuf), "istore %d\n", left->table_entry->number);
		}
		else if (strcmp(left->table_entry->type->name, "real") == 0) {
			if (right && strcmp(right->type->name, "integer") == 0) {
				snprintf(insBuf, sizeof(insBuf), "i2f\nfstore %d\n", left->table_entry->number);
			}
			else {
				snprintf(insBuf, sizeof(insBuf), "fstore %d\n", left->table_entry->number);
			}
		}
		else if (strcmp(left->table_entry->type->name, "boolean") == 0) {
			snprintf(insBuf, sizeof(insBuf), "istore %d\n", left->table_entry->number);
		}
	}
	else if (left->table_entry->level == 0 && strcmp(left->table_entry->kind, "variable") == 0) {
		if (strcmp(left->table_entry->type->name, "integer") == 0) {
			snprintf(insBuf, sizeof(insBuf), "putstatic %s/%s I\n", file_name, left->table_entry->name);
		}
		else if (strcmp(left->table_entry->type->name, "real") == 0) {
			if (right && strcmp(right->type->name, "integer") == 0) {
				snprintf(insBuf, sizeof(insBuf), "i2f\nputstatic %s/%s F\n", file_name, left->table_entry->name);
			}
			else {
				snprintf(insBuf, sizeof(insBuf), "putstatic %s/%s F\n", file_name, left->table_entry->name);
			}
		}
		else if (strcmp(left->table_entry->type->name, "boolean") == 0) {
			snprintf(insBuf, sizeof(insBuf), "putstatic %s/%s Z\n", file_name, left->table_entry->name);
		}
	}
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	return;
}

void GeneratePrintPreparation () {
	snprintf(insBuf, sizeof(insBuf), "getstatic java/lang/System/out Ljava/io/PrintStream;\n");
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	return;
}

void GeneratePrintInvoke (Expr* exp) {
	if (exp == NULL) return;
	if (strcmp(exp->type->name, "string") == 0) {
		snprintf(insBuf, sizeof(insBuf), "invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V\n");
	}
	else if (strcmp(exp->type->name, "integer") == 0) {
		snprintf(insBuf, sizeof(insBuf), "invokevirtual java/io/PrintStream/print(I)V\n");
	}
	else if (strcmp(exp->type->name, "real") == 0) {
		snprintf(insBuf, sizeof(insBuf), "invokevirtual java/io/PrintStream/print(F)V\n");
	}
	else if (strcmp(exp->type->name, "boolean") == 0) {
		snprintf(insBuf, sizeof(insBuf), "invokevirtual java/io/PrintStream/print(Z)V\n");
	}
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	return;
}

void GenerateReadPreparation () {
	fprintf(JavaOutput, "new java/util/Scanner\n");
	fprintf(JavaOutput, "dup\n");
	fprintf(JavaOutput, "getstatic java/lang/System/in Ljava/io/InputStream;\n");
	fprintf(JavaOutput, "invokespecial java/util/Scanner/<init>(Ljava/io/InputStream;)V\n");
	fprintf(JavaOutput, "putstatic %s/_sc Ljava/util/Scanner;\n",file_name);
	fprintf(JavaOutput, "\n");
	return;
}

void GenerateReadInvoke (Expr* exp) {
	fprintf(JavaOutput, "getstatic %s/_sc Ljava/util/Scanner;\n",file_name);
	if (exp == NULL) return;
	if (strcmp(exp->table_entry->kind, "variable") == 0) {
		if (strcmp(exp->table_entry->type->name, "integer") == 0) {
			fprintf(JavaOutput, "invokevirtual java/util/Scanner/nextInt()I\n");
		}
		else if (strcmp(exp->table_entry->type->name, "real") == 0) {
			fprintf(JavaOutput, "invokevirtual java/util/Scanner/nextFloat()F\n");
		}
		else if (strcmp(exp->table_entry->type->name, "boolean") == 0) {
			fprintf(JavaOutput, "invokevirtual java/util/Scanner/nextBoolean()Z\n");
		}
	}
	ClearIntructionStack();
	GenerateSave(exp, NULL);
	return;
}

void GenerateCalcOp (Expr* left, Expr* right, char* op) {
	char type[100];
	if (strcmp(left->type->name, "integer") == 0 && strcmp(right->type->name, "real") == 0) {
		snprintf(insBuf, sizeof(insBuf), "fstore %d\n", var_num);
		PushInstructionStack (insBuf);
		memset(insBuf, 0, sizeof(insBuf));
		snprintf(insBuf, sizeof(insBuf), "i2f\n");
		PushInstructionStack (insBuf);
		memset(insBuf, 0, sizeof(insBuf));
		snprintf(insBuf, sizeof(insBuf), "fload %d\n", var_num++);
		PushInstructionStack (insBuf);
		memset(insBuf, 0, sizeof(insBuf));
		PopInstructionStack();
		strcpy(type, "real");
	}
	else if(strcmp(left->type->name, "real") == 0 && strcmp(right->type->name, "integer") == 0) {
		snprintf(insBuf, sizeof(insBuf), "i2f\n");
		PushInstructionStack (insBuf);
		memset(insBuf, 0, sizeof(insBuf));
		strcpy(type, "real");
	}
	else {
		strcpy(type, left->type->name);
	}
	
	if (strcmp(op, "+") == 0) {
		if (strcmp(type, "integer") == 0) {
			snprintf(insBuf, sizeof(insBuf), "iadd\n");
		}
		else if (strcmp(type, "real") == 0) {
			snprintf(insBuf, sizeof(insBuf), "fadd\n");
		}
	}
	else if (strcmp(op, "-") == 0) {
		if (strcmp(type, "integer") == 0) {
			snprintf(insBuf, sizeof(insBuf), "isub\n");
		}
		else if (strcmp(type, "real") == 0) {
			snprintf(insBuf, sizeof(insBuf), "fsub\n");
		}
	}
	else if (strcmp(op, "*") == 0) {
		if (strcmp(type, "integer") == 0) {
			snprintf(insBuf, sizeof(insBuf), "imul\n");
		}
		else if (strcmp(type, "real") == 0) {
			snprintf(insBuf, sizeof(insBuf), "fmul\n");
		}
	}
	else if (strcmp(op, "/") == 0) {
		if (strcmp(type, "integer") == 0) {
			snprintf(insBuf, sizeof(insBuf), "idiv\n");
		}
		else if (strcmp(type, "real") == 0) {
			snprintf(insBuf, sizeof(insBuf), "fdiv\n");
		}
	}
	else if (strcmp(op, "mod") == 0) {
		snprintf(insBuf, sizeof(insBuf), "irem\n");
	}
	
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	PopInstructionStack();
	return;
}

void GenerateUnaryminus (Expr* exp) {
	if (strcmp(exp->type->name, "integer") == 0) {
		snprintf(insBuf, sizeof(insBuf), "ineg\n");
	}
	else if (strcmp(exp->type->name, "real") == 0) {
		snprintf(insBuf, sizeof(insBuf), "fneg\n");
	}
	else return;
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	return;
}

void GenerateBooleanOp (Expr* left, Expr* right, char *op) {
	PopInstructionStack();
	if (strcmp(op, "and") == 0) {
		snprintf(insBuf, sizeof(insBuf), "iand\n");
	}
	else if (strcmp(op, "or") == 0) {
		snprintf(insBuf, sizeof(insBuf), "ior\n");
	}
	else if (strcmp(op, "not") == 0) {
		snprintf(insBuf, sizeof(insBuf), "iconst_1\nixor\n");
	}
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	return;
}

void GenerateRelationalOp (Expr* left, Expr* right, char *op) {
	loopStack.stack[++loopStack.data_count] = ++label_num;
	if (strcmp(left->type->name, "integer") == 0) {
		PushInstructionStack("isub\n");
	}
	else if (strcmp(left->type->name, "real") == 0) {
		PushInstructionStack("fcmpl\n");
	}
	if (strcmp(op, "<") == 0) {
		snprintf(insBuf, sizeof(insBuf), "iflt Ltrue_%d\n", loopStack.stack[loopStack.data_count]);
	}
	else if (strcmp(op, "<=") == 0) {
		snprintf(insBuf, sizeof(insBuf), "ifle Ltrue_%d\n", loopStack.stack[loopStack.data_count]);
	}
	else if (strcmp(op, "<>") == 0) {
		snprintf(insBuf, sizeof(insBuf), "ifne Ltrue_%d\n", loopStack.stack[loopStack.data_count]);
	}
	else if (strcmp(op, ">=") == 0) {
		snprintf(insBuf, sizeof(insBuf), "ifge Ltrue_%d\n", loopStack.stack[loopStack.data_count]);
	}
	else if (strcmp(op, ">") == 0) {
		snprintf(insBuf, sizeof(insBuf), "ifgt Ltrue_%d\n", loopStack.stack[loopStack.data_count]);
	}
	else if (strcmp(op, "=") == 0) {
		snprintf(insBuf, sizeof(insBuf), "ifeq Ltrue_%d\n", loopStack.stack[loopStack.data_count]);
	}
	strcat(insBuf, "iconst_0\n");
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	snprintf(insBuf, sizeof(insBuf), "goto Lfalse_%d\n",loopStack.stack[loopStack.data_count]);
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	snprintf(insBuf, sizeof(insBuf), "Ltrue_%d:\n",loopStack.stack[loopStack.data_count]);
	strcat(insBuf, "iconst_1\n");
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	snprintf(insBuf, sizeof(insBuf), "Lfalse_%d:\n",loopStack.stack[loopStack.data_count]);
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	--loopStack.data_count;
	return;
}

void GenerateFunctionStart (char* id, TypeList* list, Type* ret) {
	snprintf(insBuf, sizeof(insBuf), ".method public static %s(", id);
	if (list != NULL) {
		int i;
		for (i = 0; i < list->data_count; ++i) {
			if (strcmp(list->type[i]->name, "integer") == 0) {
				strncat(insBuf, "I", sizeof(insBuf)-strlen(insBuf));
			}
			else if (strcmp(list->type[i]->name, "real") == 0) {
				strncat(insBuf, "F", sizeof(insBuf)-strlen(insBuf));
			}
			else if (strcmp(list->type[i]->name, "boolean") == 0) {
				strncat(insBuf, "Z", sizeof(insBuf)-strlen(insBuf));
			}
		}
	}
	
	if (strcmp(ret->name, "integer") == 0) {
		strncat(insBuf, ")I\n", sizeof(insBuf)-strlen(insBuf));
	}
	else if (strcmp(ret->name, "real") == 0) {
		strncat(insBuf, ")F\n", sizeof(insBuf)-strlen(insBuf));
	}
	else if (strcmp(ret->name, "boolean") == 0) {
		strncat(insBuf, ")Z\n", sizeof(insBuf)-strlen(insBuf));
	}
	else {
		strncat(insBuf, ")V\n", sizeof(insBuf)-strlen(insBuf));
	}
	
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	PushInstructionStack(".limit stack 128 ; Sets the maximum size of the operand stack required by the method\n");
	PushInstructionStack(".limit locals 128 ; Sets the maximum size of the operand stack required by the method\n");
	PopInstructionStack();
	return;
}

void GenerateReturnFunction (Expr* exp) {
	Type* ret = exp->type;
	if (strcmp(ret->name, "integer") == 0) {
		snprintf(insBuf, sizeof(insBuf), "ireturn\n");
	}
	else if (strcmp(ret->name, "real") == 0) {
		snprintf(insBuf, sizeof(insBuf), "freturn\n");
	}
	else if (strcmp(ret->name, "boolean") == 0) {
		snprintf(insBuf, sizeof(insBuf), "ireturn\n");
	}
	else {
		snprintf(insBuf, sizeof(insBuf), "return\n");
	}
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	PopInstructionStack();
	return;
}

void GenerateFunctionEnd () {
	strncat(insBuf, "return\n", sizeof(insBuf)-strlen(insBuf));
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	strncat(insBuf, ".end method\n\n", sizeof(insBuf)-strlen(insBuf));
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	PopInstructionStack();
	return;
}

void GenerateFunctionCall (Expr* func) {
	snprintf(insBuf, sizeof(insBuf), "invokestatic %s/%s(", file_name, func->table_entry->name);
	TypeList* list = func->table_entry->attr->type_list;
	if (list != NULL) {
		int i;
		for (i = 0; i < list->data_count; ++i) {
			if (strcmp(list->type[i]->name, "integer") == 0) {
				strncat(insBuf, "I", sizeof(insBuf)-strlen(insBuf));
			}
			else if (strcmp(list->type[i]->name, "real") == 0) {
				strncat(insBuf, "F", sizeof(insBuf)-strlen(insBuf));
			}
			else if (strcmp(list->type[i]->name, "boolean") == 0) {
				strncat(insBuf, "Z", sizeof(insBuf)-strlen(insBuf));
			}
		}
	}
	
	if (strcmp(func->table_entry->type->name, "integer") == 0) {
		strncat(insBuf, ")I\n", sizeof(insBuf)-strlen(insBuf));
	}
	else if (strcmp(func->table_entry->type->name, "real") == 0) {
		strncat(insBuf, ")F\n", sizeof(insBuf)-strlen(insBuf));
	}
	else if (strcmp(func->table_entry->type->name, "boolean") == 0) {
		strncat(insBuf, ")Z\n", sizeof(insBuf)-strlen(insBuf));
	}
	else {
		strncat(insBuf, ")V\n", sizeof(insBuf)-strlen(insBuf));
	}
	
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	return;
}

void GenerateConditionalChecking() {
	loopStack.stack[++loopStack.data_count] = ++label_num;
	snprintf(insBuf, sizeof(insBuf), "ifeq Lfalse_%d\n", loopStack.stack[loopStack.data_count]);
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	return;
}

void GenerateConditionalJump () {
	snprintf(insBuf, sizeof(insBuf), "goto Lcondexit_%d\nLfalse_%d:\n", loopStack.stack[loopStack.data_count], loopStack.stack[loopStack.data_count]);
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	return;
}

void GenerateElseConditionalJump() {
	snprintf(insBuf, sizeof(insBuf), "Lcondexit_%d:\n", loopStack.stack[loopStack.data_count]);
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	loopStack.data_count--;
	return;
}

void GenerateEndConditionalJump () {
	snprintf(insBuf, sizeof(insBuf), "Lfalse_%d:\n", loopStack.stack[loopStack.data_count]);
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	loopStack.data_count--;
	return;
}

void GenerateForLoopPreparation (TableEntry* table, int left, int right) {
	if (table == NULL) return;
	loopStack.stack[++loopStack.data_count] = ++label_num;
	snprintf(insBuf, sizeof(insBuf), \
		"\nldc %d\nistore %d\nLbegin_%d:\niload %d\nldc %d\nisub\nifle Ltrue_%d\niconst_0\ngoto Lfalse_%d\nLtrue_%d:\niconst_1\nLfalse_%d:\nifeq Lexit_%d\n" \
	, left, table->number, loopStack.stack[loopStack.data_count], table->number \
	, right, loopStack.stack[loopStack.data_count], loopStack.stack[loopStack.data_count], loopStack.stack[loopStack.data_count],loopStack.stack[loopStack.data_count],loopStack.stack[loopStack.data_count]);

	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	return;
}

void GenerateForLoopEnd (TableEntry* table) {
	if (table == NULL) return;
	snprintf(insBuf, sizeof(insBuf), "iload %d\nldc 1\niadd\nistore %d\ngoto Lbegin_%d\nLexit_%d:\n" \
	,table->number, table->number, loopStack.stack[loopStack.data_count],loopStack.stack[loopStack.data_count]);
	
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	loopStack.data_count--;
	return;
}

void GenerateWhileLoopPreparation () {
	loopStack.stack[++loopStack.data_count] = ++label_num;
	snprintf(insBuf, sizeof(insBuf), "Lbegin_%d:\n",loopStack.stack[loopStack.data_count]);
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	return;
}

void GenerateWhileLoopExit () {
	snprintf(insBuf, sizeof(insBuf), "ifeq Lexit_%d\n",loopStack.stack[loopStack.data_count]);
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	return;
}

void GenerateWhileLoopEnd () {
	snprintf(insBuf, sizeof(insBuf), "goto Lbegin_%d\nLexit_%d:\n",loopStack.stack[loopStack.data_count],loopStack.stack[loopStack.data_count]);
	PushInstructionStack (insBuf);
	memset(insBuf, 0, sizeof(insBuf));
	loopStack.data_count--;
	return;
}