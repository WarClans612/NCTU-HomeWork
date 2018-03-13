extern char* yytext;
extern int linenum;
extern int Opt_D;

typedef struct SymbolTable SymbolTable;
typedef struct TableEntry TableEntry;
typedef struct ArrayComp ArrayComp;
typedef struct Attribute Attribute;
typedef struct Type Type;
typedef struct TypeList TypeList;
typedef struct Expr Expr;
typedef struct ExprList ExprList;
typedef struct IdList IdList;
typedef struct Value Value;
extern SymbolTable* symbol_table;

struct SymbolTable {
	int current_level;
	int data_count;
	int capacity;
	TableEntry** table_entry;
};

struct TableEntry {
	char name[33];
	char kind[33];
	int level;
	Type* type;
	Attribute* attr;
};

struct ArrayComp {
	int left;
	int right;
	ArrayComp* next;
};

struct Attribute {
	Value* val;
	TypeList* type_list;
};

struct Type {
	char name[33];
	ArrayComp* array_comp;
};

struct TypeList {
	int data_count;
	int capacity;
	Type** type;
};

struct Expr {
	char kind[33];
	char name[33];
	Type* type;
	TableEntry* table_entry;
	int current_dimension;
	TypeList* para;
};

struct ExprList {
	int data_count;
	int capacity;
	Expr** expr;
};

struct IdList {
	int data_count;
	int capacity;
	char** id;
};

struct Value {
	Type* type;
	int ival;
	double dval;
	char* sval;
};

SymbolTable* BuildSymbolTable();
void InsertTableEntry(SymbolTable*,TableEntry*);
void InsertLoopTableEntry (SymbolTable*, TableEntry*);
void InsertTableEntryFromList(SymbolTable*,IdList*,const char*,Type*,Attribute*);
void PopTableEntry(SymbolTable*);
void PopLoopTableEntry(SymbolTable*);
TableEntry* BuildTableEntry(char*,const char*,int,Type*,Attribute*);

void PrintSymbolTable(SymbolTable*);
char* GetType(const Type*,int);
void PrintIdList(IdList*);
void PrintAttribute(Attribute*);

Attribute* BuildConstAttribute(Value*);
Attribute* BuildFuncAttribute(TypeList*);

Expr* FindVarRef(SymbolTable*,char*);
Expr* FindFuncRef(SymbolTable*,char*);
Expr* ConstExpr(Value*);
Expr* FunctionCall(char*,ExprList*);
Expr* RelationalOp(Expr*,Expr*,char*);
Expr* CalcOp(Expr*,Expr*,char*);
Expr* BooleanOp(Expr*,Expr*,char*);

ExprList* BuildExprList(ExprList*,Expr*);

TableEntry* FindEntryInScope(SymbolTable*,char*);
TableEntry* FindEntryInGlobal(SymbolTable*,char*);
TableEntry* FindEntryLoopVar(SymbolTable*,char*);

IdList* BuildIdList();
void ResetIdList(IdList*);
void InsertIdList(IdList*,char*);

Type* BuildType(const char*);
Type* AddArrayToType(Type*,char*,char*);

TypeList* AddTypeToList(TypeList*,Type*,int);
TypeList* ExtendTypeList(TypeList*,TypeList*);

Value* BuildValue(const char*,const char*);
Value* SubOp(Value*);