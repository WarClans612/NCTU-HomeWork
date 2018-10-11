#include<stdio.h>
int main()
{
	int m, n, x, dif[8], num[8] = {480, 583, 679, 767, 840, 945, 1140, 1305}, a, b, time;
	char str[16][11] = {"8:00 a.m.\0", "9:43 a.m.\0", "11.19 a.m.\0", "12.47 p.m.\0", "2.00 p.m.\0", "3.45 p.m.\0", "7.00 p.m.\0", 
		"9.45 p.m.\0", "10.16 a.m.\0", "11.52 a.m.\0", "1.31 p.m.\0", "3.00 p.m.\0", "4.08 p.m.\0", "5.55 p.m.\0", "9.20 p.m.\0", "11.58 p.m.\0"};

	while(1)
	{
	printf("Enter a 24 hour time (e.g. 12 58)	:");
	scanf("%d %d",&a, &b);
	
	time = (a*60) + b;
	
	x = 0;
	while ( x <= 7)
	{
			dif[x] = time - num[x];
			if(dif[x] < 0) dif[x] = -1 * dif[x];
			x++;
	}
	
	x=0; n=10000;
	while ( x <= 7 )
	{
		if (dif[x] < n) {n = dif[x]; m=x;}
		x++;
	}
	
	printf("\nClosest departure time is %s, arriving %s.\n", str[m], str[m+8]);
	
	fflush(stdin);
	
	system("pause");
	system("cls");
	
	}
	return 0;

}
