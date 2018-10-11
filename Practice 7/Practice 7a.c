#include<stdio.h>

int sequence(int n)
{
	if(n==0) return 0;
	if(n==1 || n==2) return 1;
	return sequence(n-1)+sequence(n-2);
}

void fibonacci(int n)
{
	printf("%d", sequence(n));
}

int main()
{
	int n;
	while(1)
	{
		printf("Enter the number of n	:");
		scanf("%d", &n);
		printf("f(%d) = ", n);
		
		fibonacci(n);
		
		printf("\n\n");
	}
	return 0;
}
