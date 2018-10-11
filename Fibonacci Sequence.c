#include<stdio.h>

int main()
{
	static int fib[1000]={0}, in, i, max;
	fib[0] = 1;
	fib[1] = 2;
	
	//Creating array
	i = 2;
	while(fib[i-1] <= 100000000)
	{
		fib[i] = fib[i-1] + fib[i-2];
		i++;
	}
	
	scanf("%d", &max);
	i = 0;
	while(i<max)
	{
		int  seq[1000]={0}, n, type;
		scanf("%d", &in);
		printf("%d = ", in);
		while(in != 0)
		{
			n = 0;
			while(fib[n] <= in)
			{
				n++;
			}
			n--;
			seq[n] = 1;
			in -= fib[n];
		}
		n = 999;
		type = 0;
		while(n>=0)
		{
			if(type == 0 && seq[n] != 0)
			{
				type = 1;
				printf("%d", seq[n]);
			}
			else if(type==1) printf("%d", seq[n]);
			n--;
		}
		printf(" (fib)\n");
		i++;
	}
	return 0;
}
