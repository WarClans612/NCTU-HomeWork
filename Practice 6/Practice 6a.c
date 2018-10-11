#include<stdio.h>
int main()
{
	const int size=8;
	int b, c, type=0, move=0, i, n, restrict, a[20][20] = {};
	time_t now;
	time(&now);
	srand(time(NULL));
	fflush(stdin);
	
while(restrict < 8)
{
	restrict=0;
	system("cls");
		
	//Movement
	if(move == 0)
	{
		i=rand()%size+1;
		n=rand()%size+1;
	}
	
	restrict = 0;
	while (restrict<8) 
	{
		if(move>0)
		{
		type=restrict;
			if(type==0) {n=n+2; i=i-1;}
			else if(type==1) {n=n+1; i=i-2;}
			else if(type==2) {n=n-1; i=i-2;}
			else if(type==3) {n=n-2; i=i-1;}
			else if(type==4) {n=n-2; i=i+1;}
			else if(type==5) {n=n-1; i=i+2;}
			else if(type==6) {n=n+1; i=i+2;}
			else if(type==7) {n=n+2; i=i+1;}		
		}
	
		if(n>size || i>size || n<1 || i<1 || a[i][n] != 0) 
		{
			if(type<4) {type = type+4;}
			else {type=type-4;}
				if(type==0) {n=n+2; i=i-1;}
				else if(type==1) {n=n+1; i=i-2;}
				else if(type==2) {n=n-1; i=i-2;}
				else if(type==3) {n=n-2; i=i-1;}
				else if(type==4) {n=n-2; i=i+1;}
				else if(type==5) {n=n-1; i=i+2;}
				else if(type==6) {n=n+1; i=i+2;}
				else if(type==7) {n=n+2; i=i+1;}
			restrict++;
		}
		else break;
	}
	
	if(restrict < 8)
	{	
		move++;
		a[i][n] = move;
	}
}
	
	printf("     "); b=1;
	while(b<=size) {printf("%5d",b); b++;}
	printf("\n    1");
	b=1;c=1;
	while(b!=size || c!=size)
	{
		printf("%5d",a[b][c]);
		if(c%size==0) 
		{
			b++;
			c=0;
			printf("\n");
			printf("%5d",b);
		}
		c++;
	}
	printf("%5d",a[size][size]);

	printf("\nYou finished in %d trial.", move);
	printf("\n");
	system("pause");
	return 0;
}
