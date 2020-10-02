/*suidtest*/
#include <stdio.h>
#include <unistd.h>
int main(){
/*secure SUID programs MUST 
 *not trust any user input or environment variable!! */ 

char *env[]={"PATH=/bin:/usr/bin",NULL};
char prog[]="/home/guido/article/idinfo";

if (access(prog,X_OK)){
	fprintf(stderr,"ERROR: %s not executable\n",prog);
	exit(1);
}
printf("running now %s ...\n",prog);
setreuid(geteuid(),geteuid()); 
execle(prog,(const char*)NULL,env);
perror("suidtest");

return(1);
}
