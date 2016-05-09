%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <unistd.h>
	#include <limits.h>

	extern int yylex();
	extern int yyparse();
	extern FILE *yyin;

	void yyerror(const char *menssagem);
	void exibePath();
%}

%union {
	char *sval;
	float fval;
	int ival;
}

%token <sval> STRING;
%token <fval> FLOAT;
%token <ival> INT;
%token SOMA;
%token DIV;
%token SUB;
%token MULT;

%type <ival> EXPRESSAOINT;

%token LS
%token PS
%token IFCONFIG
%token KILL
%token MKDIR
%token RMDIR
%token CD
%token TOUCH
%token START
%token QUIT
%token FIM

%%
S: 
	| S LINHA
;

LINHA: FIM { exibePath(); }
	| COMANDO FIM { exibePath(); }
	| EXPRESSAOINT FIM { printf("%d\n",$1); exibePath(); }
;

COMANDO: LS            { system("ls"); }
	| PS           { system("ps"); }
	| IFCONFIG     { system("ifconfig"); }
	| KILL STRING  { printf("comando kill\n"); }
	| MKDIR STRING { printf("comando mkdir\n"); }
	| RMDIR STRING { printf("comando rmdir\n"); }
	| CD STRING    { printf("comando cd\n"); }
	| TOUCH STRING { printf("comando touch\n"); }
	| START STRING { printf("comando start\n"); }
	| QUIT         { printf("Saindo do shell...\n"); exit(0); }
;

EXPRESSAOINT: INT                        { $$ = $1; }
	| EXPRESSAOINT SOMA EXPRESSAOINT { $$ = $1 + $3; }
	| EXPRESSAOINT SUB EXPRESSAOINT  { $$ = $1 - $3; }
	| EXPRESSAOINT MULT EXPRESSAOINT { $$ = $1 * $3; }
	| EXPRESSAOINT DIV EXPRESSAOINT  { $$ = $1 / $3; }
;

%%

int main(int argc, char **argv) {
	exibePath();
	do {
		yyparse();
	} while (!feof(yyin));
}
void yyerror(const char *menssagem) {
	fprintf(stderr, "Comando Invalido. %s\n", menssagem);
}
void exibePath() {
	char *cwd;
	char buff[PATH_MAX + 1];

	cwd = getcwd(buff, PATH_MAX + 1);
	if (cwd != NULL) {
		printf("oBaymaShell:%s>>",cwd);
	}
}
