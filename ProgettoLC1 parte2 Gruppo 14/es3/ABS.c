#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef int bool;
enum{false, true};



typedef struct Command {
	char *label;
	char *value;
	int nline, ncol;
	struct Command *nextCommand;
}Command;

typedef struct Section {
	char *label;
	int nline, ncol;
	struct Command *listCommand;
	struct Section *nextSection;
}Section;

Section *newSection(char *label){
	printf("Creo la sezione %s\n", label);
	Section *a = malloc( sizeof( Section ) );
	if(!a){
		yyerror("Out of Memory error while allocating: Section struct");
		exit(1);
	}
	a -> label = label;
	a -> nextSection = NULL;
	a -> listCommand = NULL;
	return a;
}

Command *newCommand(char *label, char *value){
	printf("Creo il comando %s\n", label);
	Command *a = malloc( sizeof( Command ) );
	if(!a){
		yyerror("Out of Memory error while allocating: Command struct");
		exit(1);
	}
	a -> label = label;
	a -> value = value;
	return a;
}

Command *addCommand(Command *cmd, Command *next){
	printf("---Concateno il comando %s davanti a %s\n",  next -> label, cmd -> label);
	cmd -> nextCommand = next;
	return cmd;
}


Section *addCommands(Section *sec, Command *cmd){
	printf("---Aggiungo la lista di comandi %s davanti a %s\n", cmd -> label, sec -> label);
	sec -> listCommand = cmd;
	return sec;
}

Section *addSection(Section *sec, Section *next){
	printf("---Aggiungo la sezione %s davanti a %s\n", next -> label ,sec -> label );
	sec -> nextSection = next;
	return sec;
}

Command *sectionSearch(Section *list, char *key){
	if( strcmp(list -> label, key) == 0 ){
		return list -> listCommand;
	}else{
		if( list -> nextSection != NULL ){
			return sectionSearch( list -> nextSection, key );
		}else{
			return NULL;
		}
	}
}

char *commandValueSearch(Command *list, char *key){
	if(list != NULL){
		if( strcmp(list -> label, key) == 0){
			return list -> value;
		}else{
			if( list -> nextCommand != NULL ){
				return commandValueSearch( list -> nextCommand, key );
			}else{
				return NULL;
			}
		}
	}
	return NULL;
}

void printSections(Section *sec){
	if(sec != NULL){
		printf("[%s]\n", sec -> label);
		printCommands( sec -> listCommand );
		printSections( sec -> nextSection );
	}
}

void printCommands(Command *com){
	if(com != NULL){
		if(*(com -> value) == '#'){
			printf("%s\n", com->value);
		}else{
			printf("%s=%s\n", com -> label , com -> value );
		}
		printCommands( com -> nextCommand );
	}
}