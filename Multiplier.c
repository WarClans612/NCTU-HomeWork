#include<stdio.h>
int main()
{
	int max, min, k, a, sum=0;
	
	while(1)
{
	system("cls");
	printf("Input minimal value	:");
	scanf("%d", &min);
	printf("Input maximum value	:");
	scanf("%d", &max);
	printf("Input multiplier	:");
	scanf("%d", &k);
	
	printf("Number	:");
	a=min+1;
	sum=0;
	while(a<max)
	{
		while(a%k != 0)
		{
			a++;
		}
		printf("%d", a);
		sum = sum + a;
		a = a + k;
		if(a < max) printf(", ");
	}
	printf("\nSum	= %d\n", sum);
	
	system("pause");
}

	return 0;
}
