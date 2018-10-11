#include<stdio.h>
#include<time.h>
const int size=60;
int  R, F, S, ptort, phare, goalt, goalh, times, lazy, stops, divider, many;
char tort[100], hare[100], terrain[100];

void initialize(int n)
{
	do	{
		R = 0;
		F = 0;
		S = 0;
		int i=1, m;
		while(i<=n)
		{
			tort[i] = ' ';
			hare[i] = ' ';
			m = rand() % 10;
			if(R<=(int)(size/5) && m>=1 && m<=2) {R++; terrain[i] = 'R';}
			else if(F<=(int)(size/5) && m>=5 && m<=6) {F++; terrain[i] = 'F';}
			else {S++; terrain[i] = 'S';}
			i++;
		}
	} while(R != (int)(size/5) || F != (int)(size/5));
	
	tort[1] = 'T';
	hare[1] = 'H';
	ptort = 1;
	phare = 1;
	goalt = 0;
	goalh = 0;
	times =-1;
	lazy = 0;
	divider = 1;
	many = 0;
	stops = 0;
	return;
}

void print_map(int x, int y)
{
	int i, j, dif;
	dif = x-y;
	
	if(dif<=0 && y>25) {i=x;}
	else if(dif>=0 && x>25) {i=y;}
	else {i=1;}
	j=i+24;
	while(i<=j && i<=size)
	{
		printf("%3d", i);
		i++;
	}
	printf("\n");
	
	if(dif<=0 && y>25) i=x;
	else if(dif>=0 && x>25) {i=y;}
	else i=1;
	j=i+24;
	while(i<=j && i<=size)
	{
		printf("%3c", terrain[i]);
		i++;
	}
	printf("\n");
	
	if(dif<=0 && y>25) i=x;
	else if(dif>=0 && x>25) {i=y;}
	else i=1;
	j=i+24;
	while(i<=j && i<=size)
	{
		printf("%3c", tort[i]);
		i++;
	}
	printf("\n");

	if(dif<=0 && y>25) i=x;
	else if(dif>=0 && x>25) {i=y;}	
	else i=1;
	j=i+24;
	while(i<=j && i<=size)
	{
		printf("%3c", hare[i]);
		i++;
	}
	printf("\n");
	
	if(dif<=-25) print_map(j+1,y);
	else if(dif>=25) print_map(j+1,x);
	return;
}

void tf_plod(int n)
{
	tort[n] = ' ';
	if(n+3>=size) {tort[ptort=size] = 'T'; goalt=1;}
	else tort[ptort=n+3] = 'T';
	printf("Tortoise Fast Plod\n");
	return;
}

void t_slip(int n)
{
	tort[n] = ' ';
	if(n-6<1) tort[ptort=1] = 'T';
	else tort[ptort=n-6] = 'T';
	printf("Tortoise Slip\n");
	return;
}

void ts_plod(int n)
{
	tort[n] = ' ';
	if(n+1>=size) {tort[ptort=size] = 'T'; goalt=1;}
	else tort[ptort=n+1] = 'T';
	printf("Tortoise Slow Plod\n");
	return;
}

void h_sleep(int n) {printf("Hare Sleep\n"); return;}

void stopped(int n) {printf("Hare stopped because it's hurt !!!\n"); stops=0; return;} 

void hb_hop(int n)
{
	hare[n] = ' ';
	if((n+(9/divider))>=size) {hare[phare=size] = 'H'; goalh=1;}
	else hare[phare=(n+(9/divider))] = 'H';
	printf("Hare Big Hop\n");
	return;
}

void hb_slip(int n)
{
	hare[n] = ' ';
	if((n-(12/divider))<1) hare[phare=1] = 'H';
	else hare[phare=(n-(12/divider))] = 'H';
	printf("Hare Big Slip\n");
	return;
}

void hs_hop(int n)
{
	hare[n] = ' ';
	if((n+(1/divider))>=size) {hare[phare=size] = 'H'; goalh=1;}
	else hare[phare=(n+(1/divider))] = 'H';
	printf("Hare Small Hop\n");
	return;
}

void hs_slip(int n)
{
	hare[n] = ' ';
	if((n-(2/divider))<1) hare[phare=1] = 'H';
	else hare[phare=(n-(2/divider))] = 'H';
	printf("Hare Small Slip\n");
	return;
}

void choice(int chance, int m)
{
	if((chance>=0 && chance <=4 ) || terrain[ptort] == 'R') tf_plod(ptort);
	else if(chance>=5 && chance <=6) t_slip(ptort);
	else if(chance >=7 && chance <=9) ts_plod(ptort);
	
	if(terrain[phare] == 'R') {divider=2; many=2;}
	if(stops==2) {stopped(phare);}
	else if((terrain[phare] == 'F' && times ==-1) || lazy>=2) {times = 2; lazy=0; h_sleep(phare);}
	else if(chance>=0 && chance<=1) {h_sleep(phare); lazy=0;}
	else if(chance>=2 && chance<=3) {hb_hop(phare); lazy++;}	
	else if(chance == 4) {hb_slip(phare); lazy=0;}
	else if(chance>=5 && chance<=7) {hs_hop(phare); lazy=0;}
	else if(chance>=8 && chance<=9) {hs_slip(phare); lazy=0;}
	
	many--;
	if(many==0) divider=1;
	if(terrain[phare] != 'F') times=-1;
}

int main()
{
	int chance, i, a=0;
	time_t now;
	time(&now);
	srand(time(NULL));
	initialize(size);
while(1)
{
	system("cls");
	//printf("%d %d %d\n", S, R, F);
	if(a>0)
	{
		chance = rand()%10;
		choice(chance,a);
	}
	if(a==0) printf("Bang !!! And They're off !!!\n\n");
	if(goalt && goalh) {printf("\nIt's a tie.\n"); print_map(ptort, phare); break;}
	if(goalt) {printf("\nTortoise win !!! Yay !!!\n"); print_map(ptort, phare); break;}
	if(goalh) {printf("\nHare wins. Yuch.\n"); print_map(ptort, phare); break;}
	if(a>1 && ptort==phare) {printf("\nHurt !!!!!\n"); stops=2;}
	else printf("\n\n");
	print_map(ptort, phare);
	printf("\n\n");
	//Sleep(378);
	system("pause");
	a++;
}
	system("pause");
	return 0;
}
