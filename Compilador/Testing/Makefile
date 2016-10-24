all:
	antlr27 -gt example1.g
	dlg -ci parser.dlg scan.c
	g++ -o example1 example1.c scan.c err.c

clean: 
	rm example1