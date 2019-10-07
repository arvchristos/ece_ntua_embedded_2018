#include <stdio.h> 
#include<stdlib.h> 
#include<fcntl.h> 

#include<unistd.h> 
int main() 
{ 
    
        // used to clear the buffer 
        // and accept the next string 
	int fd = open("./output.txt", O_CREAT | O_WRONLY | O_APPEND);
//	int hell = O_CREAT | O_WRONLY | O_APPEND;
//	printf("%b\n",hell);
//write(0,"abcd",sizeof("abcd"));
//        fflush(stdin); 

int p = 10/5 ;   
    return 0; 
}
