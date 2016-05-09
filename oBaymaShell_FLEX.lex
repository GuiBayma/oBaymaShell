%{
	#include <stdio.h>
	#include "oBaymaShell_BISON.tab.h"

	#define YY_DECL int yylex()
%}

%option noyywrap

%%

/* Entradas validas (Tokens) */
"ls"   {return LS;}
"ll"   {return LL;}
"quit" {return QUIT;}
[ \t]  {;}
"\n"   {return FIM;}

%%