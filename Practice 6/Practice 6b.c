#include<stdio.h>
int main()
{
	const int size=8;
	int b, c, type=0, move=0, i, n, restric=0, path[100] = {0}, a[20][20] = {};
	time_t now;
	time(&now);
	srand(time(NULL));
	b=0;
	
	//First coordinate
	i=rand()%size+1;
	n=rand()%size+1;
	printf("Because the first coordinate is set to be random, then sometime the program will need very very long time to run.\n");
	printf("Therefore I suggest you to re-open the program or change the value of the first coordinate when you don't feel like waiting. Thanks !\n");
	
while(move<size*size)
{	
	//Movement
	restric=0;
	while (move<(size*size)) 
	{
		if(move>0 && restric<8)
		{
		type=restric;
		path[move] = type;
			if(type==0) {n=n+2; i=i-1;}
			else if(type==1) {n=n+1; i=i-2;}
			else if(type==2) {n=n-1; i=i-2;}
			else if(type==3) {n=n-2; i=i-1;}
			else if(type==4) {n=n-2; i=i+1;}
			else if(type==5) {n=n-1; i=i+2;}
			else if(type==6) {n=n+1; i=i+2;}
			else if(type==7) {n=n+2; i=i+1;}		
		}
	
		if((n>size || i>size || n<1 || i<1 || a[i][n] != 0) && restric <=8)
		{
				if(type<4) {type = type+4;}
				else if (type<=7) {type=type-4;}
					if(type==0) {n=n+2; i=i-1;}
					else if(type==1) {n=n+1; i=i-2;}
					else if(type==2) {n=n-1; i=i-2;}
					else if(type==3) {n=n-2; i=i-1;}
					else if(type==4) {n=n-2; i=i+1;}
					else if(type==5) {n=n-1; i=i+2;}
					else if(type==6) {n=n+1; i=i+2;}
					else if(type==7) {n=n+2; i=i+1;}
				restric++;
		}
		else break;
		
		while(restric>=8)
		{
			path[move]=0;
			a[i][n]=0;
			move = move-1;
			type = path[move];
				if(type < 4) {type = type + 4;}
				else {type = type - 4;}
					if(type==0) {n=n+2; i=i-1;}
					else if(type==1) {n=n+1; i=i-2;}
					else if(type==2) {n=n-1; i=i-2;}
					else if(type==3) {n=n-2; i=i-1;}
					else if(type==4) {n=n-2; i=i+1;}
					else if(type==5) {n=n-1; i=i+2;}
					else if(type==6) {n=n+1; i=i+2;}
					else if(type==7) {n=n+2; i=i+1;}
			restric = path[move] +1;
		}
	}
	
		move++;
		a[i][n] = move;
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

	printf("\nYou finished in %d trial.", move-1);
	printf("\n");
	system("pause");
	return 0;
}
