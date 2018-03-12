#include<stdio.h>
#include<stdlib.h>

int main(int argc, char *argv[])
{
	int input, answer = 1;
	scanf("%d", &input);

	if(input) for(int i = 1; i < input+1; ++i) answer *= i;

	printf("%d", answer);

	return 0;
}
