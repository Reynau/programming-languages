all:
	antlr27 -gt bpmn.g
	dlg -ci parser.dlg scan.c
	g++ -Wno-write-strings -Wno-parentheses-equality -std=c++11 -o bpmn bpmn.c scan.c err.c

clean: 
	rm bpmn