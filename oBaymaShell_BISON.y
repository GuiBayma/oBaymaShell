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
%left SOMA;
%left DIV;
%left SUB;
%left MULT;

%type <ival> EXPRESSAOINT;
%type <fval> EXPRESSAOFLOAT;

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
	| EXPRESSAOFLOAT FIM { printf("%f\n",$1); exibePath(); }
;

COMANDO: LS        { system("ls"); }
	| PS           { system("ps"); }
	| IFCONFIG     { system("ifconfig"); }
	| KILL INT     {
						char *processo;
						processo = malloc(sizeof(*processo) * 1024);
						sprintf(processo,"kill %d",$2);
						system(processo);
				   }
	| MKDIR STRING { printf("comando mkdir\n"); }
	| RMDIR STRING { printf("comando rmdir\n"); }
	| CD STRING    {
				   		int erro = chdir($2);
				   		if (erro != 0) {
				   			printf("cd: %s: Diretorio nao encontrado.\n",$2);
				   		}
				   }
	| TOUCH STRING { printf("comando touch\n"); }
	| START STRING { printf("comando start\n"); }
	| QUIT         { printf("Saindo do shell...\n"); exit(0); }
;

EXPRESSAOINT: INT                        { $$ = $1; }
	| EXPRESSAOINT SOMA EXPRESSAOINT { $$ = $1 + $3; }
	| EXPRESSAOINT SUB EXPRESSAOINT  { $$ = $1 - $3; }
	| EXPRESSAOINT MULT EXPRESSAOINT { $$ = $1 * $3; }
	| EXPRESSAOINT DIV EXPRESSAOINT  { 
					 	if ($3 != 0) {
							$$ = $1 / $3;
						} else {
							printf("Erro. Divisao por zero.\n");
						}
					 }
;

EXPRESSAOFLOAT: FLOAT                        { $$ = $1; }
	| EXPRESSAOFLOAT SOMA EXPRESSAOFLOAT { $$ = $1 + $3; }
	| EXPRESSAOFLOAT SUB EXPRESSAOFLOAT  { $$ = $1 - $3; }
	| EXPRESSAOFLOAT MULT EXPRESSAOFLOAT { $$ = $1 * $3; }
	| EXPRESSAOFLOAT DIV EXPRESSAOFLOAT  { 
					     	if ($3 != 0) {
							$$ = $1 / $3;
						} else {
							printf("Erro. Divisao por zero.\n");
						}
					     }
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
