#include<stdio.h>
int main()
{
	int a=0,b=0,n,i=0;
	char str[50];
	
	while(1)
	{
	a=0;
	i = 0;
	while (i<=51) {str[i] = ' ' , i++;}
	str[-1] = 50;
	
	i=0;
	printf("\nPlease input 2 numbers (divided by space)	:");
	while (str[i-1] != '\n')
		{
		scanf("%c", &str[i]);
		i++;
		}
		
	i = 0;
	do 
		{
		if ((str[i-1] >= 48 && str[i-1] <= 57) && (str[i] == ' ' || str[i] == '\n' || (str[i] < 48 || str[i] > 57))) {a = a+1; i++;}
		else {a = a; i++;};
		} while ((str[i-1] >= 48 && str[i-1] <= 57) || (str[i-1] ==' ' || str[i-1] =='\n'));
	
		
	printf("\nThe legal number that you input is ");
	printf("%d", a); n = i;
	
	i = 1;
	while (((str[i-1] >= 48 && str[i-1] <= 57) || str[i-1] == ' ' || str[i-1] == '\n') && i <=50)
		{
			if ((str[i] >= 48 && str[i] <= 57) || str[i] == ' ' || str[i] == '\n') b=2;
			else b=0;
			i++;
		}
	
	if( a == 2 && b == 2) printf("\nYour input is completely correct!\n");
	else if (b == 0)
	{
	str[-1] = ' ';
	printf ("\nThe garbage in the keyboard buffer is ");
	while (n<=51 && str[n-1] >=32 && str[n-1] <=126) {printf("%c", str[n-1]); n++;};
	printf ("\nWe have just remove them from the buffer!\n");
	}
	else (printf("\n"));
	
	system("pause");
	system("cls");
	
	}
	
		
	
	return 0;
}
