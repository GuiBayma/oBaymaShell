%{
	#include <stdio.h>
	#include "oBaymaShell_BISON.tab.h"

	#define YY_DECL int yylex()
%}

%option noyywrap

%%

[ \t]        { ; }
"ls"         { return LS; }
"ps"         { return PS; }
"ifconfig"   { return IFCONFIG; }
"quit"       { return QUIT; }
[a-zA-Z0-9]+ { yylval.sval = strdup(yytext); return STRING; }
"\n"         { return FIM; }

%%
