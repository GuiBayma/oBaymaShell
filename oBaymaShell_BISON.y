%{
	#include <stdio.h>
	#include <stdlib.h>
	$include <string.h>
	#include <unistd.h>

	void yyerror(const char *menssagem);
%}

%token LS
%token LL
%token QUIT
%token FIM
%start S
%%

S: S LINHA;

LINHA: FIM
	| LS FIM   { system("ls"); }
	| LL FIM   { system("ll"); }
	| QUIT FIM { exit(0); }
;

int main() {
	yyin = stdin;
	do {
		yyparse();
	} while (!feof(yyin));
	return 0;
}
void yyerror(const char *menssagem) {
	fprintf(stderr, "Comando Invalido. %s\n", menssagem);
}