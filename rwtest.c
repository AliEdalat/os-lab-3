#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "syscall.h"

int
main(int argc, char* argv[])
{
    int pid = 1;
    int j = 0;
    int i;
    int patterns [10] = {18};
    rwinit();
    for(i = 0; i< 10; i++)
	if(pid>0)
		pid=fork();
    if(pid<0)
	printf(1,"error\n");
    else if(pid == 0){
	printf(1,"child add to shared counter....\n");
	rwtest(patterns[j++]);
    } else {
	for(i = 0; i< 10; i++)
		wait();
	printf(1,"finished:D\n");
    }
    exit();
}
