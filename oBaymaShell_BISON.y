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
}

%token <sval> STRING;

%token LS
%token PS
%token IFCONFIG
%token QUIT
%token FIM

%%
S: 
	| S LINHA
;

LINHA: FIM { exibePath(); }
	| COMANDO FIM { exibePath(); }
;

COMANDO: LS        { system("ls"); }
	| PS       { system("ps"); }
	| IFCONFIG { system("ifconfig"); }
	| QUIT     { printf("Saindo do shell...\n"); exit(0); }
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
