extern char* yytext;
extern FILE* JavaOutput;
extern SymbolTable* symbol_table;
extern int linenum;
extern int var_num;
extern char *file_name;

typedef struct InstructionList InstructionList;
typedef struct LoopStack LoopStack;

struct InstructionList {
	char *list[1000];
	int data_count;
};

struct LoopStack {
	int stack[1000];
	int data_count;
};

void PushInstructionStack (const char*);
void PopInstructionStack ();
void ClearIntructionStack ();

void ProgramStart(const char*);
void ProgramEnd();
void GenerateMainProcedure();

void GenerateGlobalVariable(IdList*,Type*);

void GenerateLoad (Expr*);
void GenerateConstantLoad (Value*);
void GenerateSave (Expr*,Expr*);

void GeneratePrintPreparation();
void GeneratePrintInvoke (Expr*);
void GenerateReadPreparation ();
void GenerateReadInvoke (Expr*);

void GenerateCalcOp (Expr*,Expr*,char*);
void GenerateUnaryminus (Expr*);
void GenerateBooleanOp (Expr*,Expr*,char*);
void GenerateRelationalOp (Expr*,Expr*,char*);

void GenerateFunctionStart (char*,TypeList*,Type*);
void GenerateReturnFunction (Expr*);
void GenerateFunctionEnd ();
void GenerateFunctionCall (Expr*);

void GenerateConditionalChecking();
void GenerateConditionalJump ();
void GenerateElseConditionalJump();
void GenerateEndConditionalJump ();

void GenerateForLoopPreparation (TableEntry*,int,int);
void GenerateForLoopEnd (TableEntry*);
void GenerateWhileLoopPreparation ();
void GenerateWhileLoopExit ();
void GenerateWhileLoopEnd ();