#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//Tipo bool, per comodita'
typedef int bool;
enum{false, true};

//Lista di comandi
typedef struct Command {
	char *label;
	char *value;
	struct Command *nextCommand;
}Command;

//Lista di sezioni
typedef struct Section {
	char *label;
	int nlines;
	int ncolumn;
	struct Command *listCommand;
	struct Section *nextSection;
}Section;

//Crea un elemento vuoto della lista delle sezioni
Section *newSection(char *label, int line, int col){
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

//Crea un elemento vuoto della lista dei comandi
Command *newCommand(char *label, char *value){
	Command *a = malloc( sizeof( Command ) );
	if(!a){
		yyerror("Out of Memory error while allocating: Command struct");
	}
	a -> label = label;
	a -> value = value;
	a -> nextCommand = NULL;
	return a;
}

//Fa' puntare cmd a next e restituisce cmd
Command *addCommand(Command *cmd, Command *next){
	cmd -> nextCommand = next;
	return cmd;
}

//Fornisce a sec la lista di comandi cmd e restituisce sec
Section *addCommands(Section *sec, Command *cmd){
	sec -> listCommand = cmd;
	return sec;
}

//Fa' puntare sec a next e restituisce sec
Section *addSection(Section *sec, Section *next){
	sec -> nextSection = next;
	return sec;
}

//Cerca fra le sezioni create con il label key e restituisce la sua lista di comandi
//usata nel risolvere gli r-value di tipo REFERENCE
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

//Cerca in una lista di comandi il valore della variabile che corrisponde a quella key
//usata nel risolvere gli r-value di tipo REFERENCE
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

//Pretty printing di una lista di sezioni
void printSections(Section *sec){
	if(sec != NULL){
		printf("[%s]\n", sec -> label);
		printCommands( sec -> listCommand );
		printSections( sec -> nextSection );
	}
}

//Pretty printing di una lista di comandi
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

//Funzione di ricerca di un comando di label == key, per stampare uno warning per la definizione multipla
//line e column servono per il messaggio di errore e rappresentano la posizione dell'elemento da verificare
bool localNameWarning(Command *list, char *key, int line, int column){
	if(list != NULL){
		if( strcmp(list -> label, key) == 0){
			fprintf(stderr, "WARNING - Var:\"%s\" has another definition at (%i,%i).\n", key, line, column);
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

//Funzione di ricerca per una sezione di label == key, per l'errore di ridefinizione di una sezione
//line e column servono per il messaggio di errore e rappresentano la posizione dell'elemento da verificare
bool sectionNameError(Section *list, char *key, int line, int column){
	if(list != NULL){
		if( strcmp(list -> label, key) == 0 ){
			char buf[100];
			sprintf(buf, "ERROR - at (%i:%i): section \"%s\" was already defined at (%i:%i). Illegal assignment.\0", line, column, key, list -> nlines, list -> ncolumn);
			yyerror( buf );
			return 1;
		}else{
			if( list -> nextSection != NULL ){
				return sectionNameError( list -> nextSection, key, line, column);
			}else{
				return 0;
			}
		}
	}
	return 0;
}
