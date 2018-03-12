#include<stdio.h>
#include<sys/types.h>
#include<sys/wait.h>
#include<unistd.h>
#include<stdlib.h>

#define WRITE_END 1
#define READ_END 0
#define BUFFER_SIZE 10

void check(const pid_t pid)
{
	if(pid < 0)
	{
		perror("Fork failed");
		exit(-1);
	}
}

void child()
{
	printf("-----------------------------------------------------------------\n");
	printf("I'm the child %d.\n", getpid());
	printf("I can receive input! Please enter a number.\n\n");
}

int main( int argc, char *argv[])
{
	printf("Main process ID : %d\n", getpid());
	int sum = 0;

	int fd1[2], fd2[2], fd3[2];
	if( pipe(fd1) == -1 || pipe(fd2) == -1 || pipe(fd3) == -1 )
	{
		perror("Pipe Failed");
		exit(-1);
	}

	//First time fork
	pid_t pid = fork();
	check(pid);
	if(pid)
	{
		char status[BUFFER_SIZE];
		close( fd1[WRITE_END] );
		wait(0);
		read ( fd1[READ_END], status, BUFFER_SIZE );
		printf("The output number is %d\n", atoi(status));
		sum += atoi(status);
	}
	else
	{
		child();
		close( fd1[READ_END] );
		dup2( fd1[WRITE_END], STDOUT_FILENO );
		//close( fd1[WRITE_END] );
		execl("0416106_calculate.out", "./0416106_calculate.out", NULL);
	}

	//Second time fork
	pid = fork();
	check(pid);
	if(pid)
	{
		char status[BUFFER_SIZE];
		close( fd2[WRITE_END] );
		wait(0);
		read ( fd2[READ_END], status, BUFFER_SIZE );
		printf("The output number is %d\n", atoi(status));
		sum += atoi(status);
	}
	else
	{
		child();
		close( fd2[READ_END] );
		dup2( fd2[WRITE_END], STDOUT_FILENO );
		//close( fd2[WRITE_END] );
		execl("0416106_calculate.out", "./0416106_calculate.out", NULL);
	}

	//Third time fork
	pid = fork();
	check(pid);
	if(pid)
	{
		char status[BUFFER_SIZE];
		close( fd3[WRITE_END] );
		wait(0);
		read ( fd3[READ_END], status, BUFFER_SIZE );
		printf("The output number is %d\n", atoi(status));
		sum += atoi(status);
	}
	else
	{
		child();
		close( fd3[READ_END] );
		dup2( fd3[WRITE_END], STDOUT_FILENO );
		//close( fd3[WRITE_END] );
		execl("0416106_calculate.out", "./0416106_calculate.out", NULL);
	}

	printf("\n-----------------------------------------------------------------\n");
	printf("I'm the parent %d.\n", getpid());
	printf("Sum of the results from three child processes: %d\n", sum);
	printf("-----------------------------------------------------------------\n");

	return 0;
}
