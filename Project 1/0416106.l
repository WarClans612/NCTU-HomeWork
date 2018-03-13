%{
#define LIST				strcat(buf, yytext)
#define tokenKeyword			{LIST; if (Opt_T) printf("<KW%s>\n", yytext);}
#define tokenDelimitersAndOperators	{LIST; if (Opt_T) printf("<%s>\n", yytext); }
#define token(t)			{LIST; if (Opt_T) printf("<%s>\n", #t);}
#define tokenChar(t)			{LIST; if (Opt_T) printf("<%c>\n", (t));}
#define tokenInteger(t, i)		{LIST; if (Opt_T) printf("<%s: %d>\n", #t, (i));}
#define tokenString(t, s)		{LIST; if (Opt_T) printf("<%s: %s>\n", #t, (s));}
#define programListing			{LIST; if (Opt_S) printf("%d: %s", linenum, buf); linenum++; buf[0] = '\0';}
#define errorHandler			{printf("error at line %d: bad character \"%s\"\n", linenum, yytext); exit(0);}
#define MAX_LINE_LENG			256

int Opt_S = 1;
int Opt_T = 1;
int linenum = 1;
char buf[MAX_LINE_LENG];
char str[MAX_LINE_LENG];
%}

keywords	array|begin|boolean|def|do|else|end|false|for|integer|if|of|print|read|real|string|then|to|true|return|var|while
delimiters	","|";"|":"|"("|")"|"["|"]"
operators	"+"|"-"|"*"|"/"|"mod"|":="|"<"|"<="|"<>"|">="|">"|"="|"and"|"or"|"not"
integer		0|[1-9][0-9]*
oct_integer	[0][0-7]+
floating	[0-9]+[\.][0-9]+
scientific	[0-9]+([\.][0-9]+)?([eE][\-+]?(0|[1-9][0-9]*))
digit		[0-9]
letter		[a-zA-Z]
identifier	{letter}({letter}|{digit})*


%Start SINGLE_LINE_COMMENT MULTI_LINE_COMMENT STRING

%%
<SINGLE_LINE_COMMENT>\n		{ programListing; BEGIN INITIAL; }
<SINGLE_LINE_COMMENT>.		{ LIST;}

<MULTI_LINE_COMMENT>"*/"	{ LIST; BEGIN INITIAL; }
<MULTI_LINE_COMMENT>\n		{ programListing; }
<MULTI_LINE_COMMENT>.		{ LIST; }

<STRING>\n			{ errorHandler; }
<STRING>"\"\""			{ LIST; strcat(str, "\""); }
<STRING>"\""			{ tokenString(string, str); str[0] = '\0'; BEGIN INITIAL; }
<STRING>.			{ LIST; strcat(str, yytext); } 

<INITIAL>"//&S+"			{ LIST; Opt_S = 1; BEGIN SINGLE_LINE_COMMENT; }
<INITIAL>"//&S-"			{ LIST; Opt_S = 0; BEGIN SINGLE_LINE_COMMENT; }
<INITIAL>"//&T+"			{ LIST; Opt_T = 1; BEGIN SINGLE_LINE_COMMENT; }
<INITIAL>"//&T-"			{ LIST; Opt_T = 0; BEGIN SINGLE_LINE_COMMENT; }
<INITIAL>"//"				{ LIST; BEGIN SINGLE_LINE_COMMENT; }
<INITIAL>"/*"				{ LIST; BEGIN MULTI_LINE_COMMENT; }
<INITIAL>"\""				{ LIST; BEGIN STRING; }
<INITIAL>{keywords}			{ tokenKeyword; }
<INITIAL>{delimiters}|{operators}	{ tokenDelimitersAndOperators; }
<INITIAL>{integer}			{ tokenString(integer, yytext); }
<INITIAL>{oct_integer}			{ tokenString(oct_integer, yytext); }
<INITIAL>{floating}			{ tokenString(float, yytext); }
<INITIAL>{scientific}			{ tokenString(scientific, yytext); }
<INITIAL>{identifier}			{ tokenString(id, yytext); }
<INITIAL>\n				{ programListing; }
<INITIAL>" "|\t				{ LIST; }
<INITIAL>.				{ errorHandler; }

%%
int main( int argc, char **argv )
{
  if( argc != 2 ) {
    fprintf( stderr, "Usage: ./scanner [filename]\n" );
    exit(0);
  }
	
  FILE *fp = fopen( argv[1], "r" );
  if( fp == NULL ) {
    fprintf( stderr, "Open file error\n" );
    exit(-1);
  }
	
  yyin = fp;

  yylex();

  exit(0);
}
