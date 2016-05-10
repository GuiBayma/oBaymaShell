%{
	#include <stdio.h>
	#include "oBaymaShell_BISON.tab.h"

	#define YY_DECL int yylex()
%}

%option noyywrap

%%

[ \t]          { ; }
"ls"           { return LS; }
"ps"           { return PS; }
"ifconfig"     { return IFCONFIG; }
"kill"         { return KILL; }
"mkdir"        { return MKDIR; }
"rmdir"        { return RMDIR; }
"cd"           { return CD; }
"touch"        { return TOUCH; }
"start"        { return START; }
"quit"         { return QUIT; }
"+"            { return SOMA; }
"-"            { return SUB; }
"/"            { return DIV; }
"*"            { return MULT; }
[0-9]+\.[0-9]+ { yylval.fval = atof(yytext); return FLOAT; }
[0-9]+         { yylval.ival = atoi(yytext); return INT; }
[a-zA-Z0-9./]+ { yylval.sval = strdup(yytext); return STRING; }
"\n"           { return FIM; }

%%
