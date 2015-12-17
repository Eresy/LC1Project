#include <stdlib.h>

typedef int bool;
enum{false, true};


typedef struct Command {
	char *label;
	char *value;
	struct Command *nextCommand;
}Command;

typedef struct Section {
	char *label;
	struct Command *listCommand;
	struct Section *nextSection;
}Section;

Section * newSection(char *label){
	Section *a = malloc( sizeof( Section ) );
	if(!a){
		yyerror("Out of Memory error while allocating: Section struct");
		exit(1);
	}
	a -> label = label;
	return (Section *) a;
}

Command * newCommand(char *label, char *value){
	Command *a = malloc( sizeof( Command ) );
	if(!a){
		yyerror("Out of Memory error while allocating: Command struct");
		exit(1);
	}
	a -> label = label;
	a -> value = value;
	return (Command *)a;
}

Command * addNextCommands(Command *cmd, Command *next){
	cmd -> nextCommand = next;
	return cmd;
}


Section * addCommandList(Section *cmd, Command *list){
	cmd -> listCommand = list;
	return cmd;
}

Section * addNextSections(Section *sec, Section *next){
	sec -> nextSection = next;
	return sec;
}
