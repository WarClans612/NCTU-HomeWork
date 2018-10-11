#include<stdio.h>
int main()
{
	int i, inp=0, b=1, a;

	printf("\nEnter a number	:");
	scanf("%d", &inp);
	fflush(stdin);
	printf("The prime Factorization	:");
	
	i=2;
	while(inp>=i)
	{
		if(inp%i == 0) {a = 1; printf("%d", i); inp = inp/i; b=1; 
			while(inp%i == 0) {b++; inp=inp/i;}
			if(b>1) printf(" ^ %d", b);
			}			
		else { i++;} 
		if( a == 1 && inp != 1) printf(" * ");
		a=0;
	}
	printf("\n");
	system("pause");
	
	return 0;
}
