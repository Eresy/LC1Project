#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef int bool;
enum{false, true};

typedef struct Command {
	char *label;
	char *value;
	struct Command *nextCommand;
}Command;

typedef struct Section {
	char *label;
	int nlines;
	int ncolumn;
	struct Command *listCommand;
	struct Section *nextSection;
}Section;

Section *newSection(char *label, int line, int col){
	//printf("Creo la sezione %s\n", label);
	Section *a = malloc( sizeof( Section ) );
	if(!a){
		yyerror("Out of Memory error while allocating: Section struct");
	}
	a -> label = label;
	a -> nlines = line;
	a -> ncolumn = col;
	a -> nextSection = NULL;
	a -> listCommand = NULL;
	return a;
}

Command *newCommand(char *label, char *value){
	//printf("Creo il comando %s\n", label);
	Command *a = malloc( sizeof( Command ) );
	if(!a){
		yyerror("Out of Memory error while allocating: Command struct");
	}
	a -> label = label;
	a -> value = value;
	return a;
}

Command *addCommand(Command *cmd, Command *next){
	//printf("---Concateno il comando %s davanti a %s\n",  next -> label, cmd -> label);
	cmd -> nextCommand = next;
	return cmd;
}


Section *addCommands(Section *sec, Command *cmd){
	//printf("---Aggiungo la lista di comandi %s davanti a %s\n", cmd -> label, sec -> label);
	sec -> listCommand = cmd;
	return sec;
}

Section *addSection(Section *sec, Section *next){
	//printf("---Aggiungo la sezione %s davanti a %s\n", next -> label ,sec -> label );
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

bool localNameWarning(Command *list, char *key, int line, int column){
	if(list != NULL){
		if( strcmp(list -> label, key) == 0){
			fprintf(stderr, "WARNING (%i:%i): la variabile \"%s\" è stata definita due volte nello stesso blocco.\n", line, column, key);
			return 1;
		}else{
			if( list -> nextCommand != NULL ){
				return localNameWarning( list -> nextCommand, key, line , column);
			}else{
				return 0;
			}
		}
	}
	return 0;
}

bool sectionNameError(Section *list, char *key){
	if(list != NULL){
		if( strcmp(list -> label, key) == 0 ){
			char buf[100];
			sprintf(buf, "ERROR (%d:%d) : La sezione \"%s\" è stata gia' definita in Precedenza. Assegnamento illegale.\0", list -> nlines, list -> ncolumn, key);
			yyerror( buf );
			return 1;
		}else{
			if( list -> nextSection != NULL ){
				return sectionNameError( list -> nextSection, key );
			}else{
				return 0;
			}
		}
	}
	return 0;
}