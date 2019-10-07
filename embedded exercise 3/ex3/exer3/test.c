#include <stdio.h>

extern int strcmp(char * a, char * b);
extern int strlen(char * a);
extern char* strcpy(char * a,char* b);
extern int strcat(char * a,char* b);
int main()
{
	char * a = "GGGg";
	char * b = "bbb";

	char copied[10];
	printf("Comparing %s and %s results in %d\n",a,b,strcmp(a,b));	
	printf("Length of  %s is  %d\n",a,strlen(a));
	strcpy(copied,a);
	printf("copied this %s to this %s\n",a,copied);
	printf("added this %s to this %s and became this %s\n",a,copied,strcat(copied,a));
	return (0);
}
