#include<stdio.h>
#include<sys/types.h>
#include<sys/wait.h>
#include<unistd.h>
#include<stdlib.h>

void check(const pid_t pid)
{
	if(pid < 0)
	{
		perror("Fork failed");
		exit(-1);
	}
}

void parent(int *level, const pid_t pid )
{
	printf("fork %d. I'm the parent %d, my child is %d\n", *level, getpid(), pid);
	wait(0);
}

void child(int *level)
{
	printf("fork %d. I'm the child %d, my parent is %d\n", *level, getpid(), getppid());
}


void forking(int *level, const pid_t pid)
{
	check(pid);
	if(pid) parent(level, pid);
	else child(level);
}

int main( int argc, char *argv[])
{
	printf("Main process ID : %d\n", getpid());
	int level = 1;

	//First time fork
	pid_t pid = fork();
	forking(&level, pid);
	++level;

	//Second time fork
	pid = fork();
	forking(&level, pid);
	++level;

	//Third time fork
	pid = fork();
	forking(&level, pid);
	++level;

	
	return 0;
}
