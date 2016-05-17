#include <stdio.h>

char buf[128];



void printError()
{
  printf("Program called error!");
  exit(-1);
}

int readInt()
{
  for(;;) {
    int v;
    fgets(buf,sizeof(buf),stdin);
    if(1 == sscanf(buf,"%d",&v))
      return v;
    else {
      if(strlen(buf) > 0 && buf[strlen(buf)-1] == '\n')
	buf[strlen(buf)-1] = 0;
      printf("\"%s\" is not an int, try again:",buf);
    }
  }
}

float readfloat(void)
{
  for(;;) {
    float v;
    fgets(buf,sizeof(buf),stdin);
    if(1 == sscanf(buf,"%lg",&v))
      return v;
    else {
      if(strlen(buf) > 0 && buf[strlen(buf)-1] == '\n')
	buf[strlen(buf)-1] = 0;
      printf("\"%s\" is not a float, try again:",buf);
    }
  }
}

void printInt(int v)
{
  printf("%d\n",v);
}

void printfloat(float v)
{
  printf("%f\n",v);
}

void printString(char* s)
{
  printf("%s\n",s);
}

int main () {
  printInt(7 * readInt ()) ;
  printfloat(3.14);
  printString("hello");
  }
