#include<stdio.h>
int main()
{
	int store, check, n, i, b[100]={0};
	
	printf("Please input sequence of number	:");
	
	i=1;
	while(i<=99)
	{
		scanf("%d", &b[i]);
		if(getchar() == '\n' ) { n = i; break;}
		i++;
	}
	
	i = 1;
	check = 1;
	
	while(check > 0)
	{
		i=1;
		check = 0;
		while(i <= n-1)
		{
			if(b[i] > b[i+1]) {store = b[i]; b[i] = b[i+1]; b[i+1] = store; check++;}
			i++; 
		}
	}
	
	i=1;
	while(i<=n)
	{
		printf("%d ", b[i]);
		i++;
	}
	
	system("pause");
	return 0;
}
