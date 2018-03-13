%{
#include "y.tab.h"

#define LIST				strcat(buf, yytext)
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

integer		0|[1-9][0-9]*
oct_integer	[0][0-7]+
floating	(0|[1-9][0-9]*)[\.](0|[0-9]*)
scientific	({integer}|{floating}|{oct_integer})([eE][\-+]?({integer}|{oct_integer}))
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
<STRING>"\""			{ tokenString(string, str); str[0] = '\0'; BEGIN INITIAL; return STR_CONST;}
<STRING>.			{ LIST; strcat(str, yytext); } 

<INITIAL>"//&S+"			{ LIST; Opt_S = 1; BEGIN SINGLE_LINE_COMMENT; }
<INITIAL>"//&S-"			{ LIST; Opt_S = 0; BEGIN SINGLE_LINE_COMMENT; }
<INITIAL>"//&T+"			{ LIST; Opt_T = 1; BEGIN SINGLE_LINE_COMMENT; }
<INITIAL>"//&T-"			{ LIST; Opt_T = 0; BEGIN SINGLE_LINE_COMMENT; }
<INITIAL>"//"				{ LIST; BEGIN SINGLE_LINE_COMMENT; }
<INITIAL>"/*"				{ LIST; BEGIN MULTI_LINE_COMMENT; }
<INITIAL>"\""				{ LIST; BEGIN STRING; }


<INITIAL>"array"				{ token(KWarray); return ARRAY;}
<INITIAL>"begin"				{ token(KWbegin); return BEGI;}
<INITIAL>"boolean"			{ token(KWboolean); return BOOL;}
<INITIAL>"def"				{ token(KWdef); return DEF;}
<INITIAL>"do"				{ token(KWdo); return DO;}
<INITIAL>"else"				{ token(KWelse); return ELSE;}
<INITIAL>"end"				{ token(KWend); return END;}
<INITIAL>"false"				{ token(KWfalse); return BOOL_CONST;}
<INITIAL>"for"				{ token(KWfor); return FOR;}
<INITIAL>"integer"			{ token(KWinteger); return INT;}
<INITIAL>"if"				{ token(KWif); return IF;}
<INITIAL>"of"				{ token(KWof); return OF;}
<INITIAL>"print"				{ token(KWprint); return PRINT;}
<INITIAL>"read"				{ token(KWread); return READ;}
<INITIAL>"real"				{ token(KWreal); return REAL;}
<INITIAL>"string"			{ token(KWstring); return STR;}
<INITIAL>"then"				{ token(KWthen); return THEN;}
<INITIAL>"to"				{ token(KWto); return TO;}
<INITIAL>"true"				{ token(KWtrue); return BOOL_CONST;}
<INITIAL>"return"			{ token(KWreturn); return RETURN;}
<INITIAL>"var"				{ token(KWvar); return VAR;}
<INITIAL>"while"				{ token(KWwhile); return WHILE;}

<INITIAL>","				{ tokenChar(','); return COMMA;}
<INITIAL>";"				{ tokenChar(';'); return SEMICOLON;}
<INITIAL>":"				{ tokenChar(':'); return COLON;}
<INITIAL>")"				{ tokenChar(')'); return ')';}
<INITIAL>"("				{ tokenChar('('); return '(';}
<INITIAL>"["				{ tokenChar('['); return '[';}
<INITIAL>"]"				{ tokenChar(']'); return ']';}

<INITIAL>"+"				{ tokenChar('+'); return '+';}
<INITIAL>"-"				{ tokenChar('-'); return '-';}
<INITIAL>"*"				{ tokenChar('*'); return '*';}
<INITIAL>"/"				{ tokenChar('/'); return '/';}
<INITIAL>"mod"				{ token(mod); return '%';}
<INITIAL>":="				{ token(:=); return ASSIGN;}
<INITIAL>"<"				{ tokenChar('<'); return LT;}
<INITIAL>"<="				{ token(<=); return LE;}
<INITIAL>"<>"				{ token(<>); return NE;}
<INITIAL>">="				{ token(>=); return GE;}
<INITIAL>">"				{ tokenChar('>'); return GT;}
<INITIAL>"="				{ tokenChar('='); return EQ;}
<INITIAL>"and"				{ token(and); return AND;}
<INITIAL>"or"				{ token(or); return OR;}
<INITIAL>"not"				{ token(not); return NOT;}

<INITIAL>{integer}			{ tokenString(integer, yytext); return INT_CONST;}
<INITIAL>{oct_integer}			{ tokenString(oct_integer, yytext); return INT_CONST;}
<INITIAL>{floating}			{ tokenString(float, yytext); return REAL_CONST;}
<INITIAL>{scientific}			{ tokenString(scientific, yytext); return REAL_CONST;}
<INITIAL>{identifier}			{ tokenString(id, yytext); return ID;}
<INITIAL>\n				{ programListing; }
<INITIAL>" "|\t				{ LIST; }
<INITIAL>.				{ errorHandler; }

%%
/*
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
*/
