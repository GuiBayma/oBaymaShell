all :
	@echo "\n==> Removendo arquivos desnecessários";
	rm -rf oBaymaShell oBaymaShell_BISON.tab.h oBaymaShell.tab.c lex.yy.c
	@echo "\n==> Executando BISON para gerar código em linguagem C";
	bison -d oBaymaShell_BISON.y
	@echo "\n==> Executando FLEX para gerar código em linguagem C";
	flex -l oBaymaShell_FLEX.lex
	@echo "\n==> Compilando...";
	gcc oBaymaShell.tab.c lex.yy.c -lfl -o oBaymaShell
	@echo "\n==> Compilado! Executando Shell...";
	./oBaymaShell