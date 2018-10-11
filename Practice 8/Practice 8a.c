#include<stdio.h>
#include<time.h>
const int size=25;
int  ptort=1, phare=1, goalt=0, goalh=0;
char tort[27], hare[27];

void initialize(int n)
{
	int i=0, m;
	while(i<=n)
	{
		tort[i] = ' ';
		hare[i] = ' ';
		i++;
	}
	tort[1] = 'T';
	hare[1] = 'H';
	ptort = 1;
	phare = 1;
	goalt = 0;
	goalh = 0;
}

void print_map()
{
	int i;
	i=1;
	while(i<=size)
	{
		printf("%3d", i);
		i++;
	}
	printf("\n");
	
	i=1;
	while(i<=size)
	{
		printf("%3c", tort[i]);
		i++;
	}
	printf("\n");

	i=1;
	while(i<=size)
	{
		printf("%3c", hare[i]);
		i++;
	}
	printf("\n");
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

void hb_hop(int n)
{
	hare[n] = ' ';
	if(n+9>=size) {hare[phare=size] = 'H'; goalh=1;}
	else hare[phare=n+9] = 'H';
	printf("Hare Big Hop\n");
	return;
}

void hb_slip(int n)
{
	hare[n] = ' ';
	if(n-12<1) hare[phare=1] = 'H';
	else hare[phare=n-12] = 'H';
	printf("Hare Big Slip\n");
	return;
}

void hs_hop(int n)
{
	hare[n] = ' ';
	if(n+1>=size) {hare[phare=size] = 'H'; goalh=1;}
	else hare[phare=n+1] = 'H';
	printf("Hare Small Hop\n");
	return;
}

void hs_slip(int n)
{
	hare[n] = ' ';
	if(n-2<1) hare[phare=1] = 'H';
	else hare[phare=n-2] = 'H';
	printf("Hare Small Slip\n");
	return;
}

void choice(int chance)
{
	if(chance>=0 && chance <=4 ) tf_plod(ptort);
	else if(chance>=5 && chance <=6) t_slip(ptort);
	else if(chance >=7 && chance <=9) ts_plod(ptort);
	
	if(chance>=0 && chance<=1) h_sleep(phare);
	else if(chance>=2 && chance<=3) hb_hop(phare);	
	else if(chance == 4) hb_slip(phare);
	else if(chance>=5 && chance<=7) hs_hop(phare);
	else if(chance>=8 && chance<=9) hs_slip(phare);

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
	if(a>0)
	{
		chance = rand()%10;
		choice(chance);
	}
	if(a==0) printf("Bang !!! And They're off !!!\n\n");
	if(goalt && goalh) {printf("\nIt's a tie.\n"); print_map(); break;}
	if(goalt) {printf("\nTortoise win !!! Yay !!!\n"); print_map(); break;}
	if(goalh) {printf("\nHare wins. Yuch.\n"); print_map(); break;}
	if(a>1 && ptort==phare) printf("\nOuch !!!\n");
	else printf("\n\n");
	print_map();
	printf("\n\n");
	system("pause");
	a++;
}
	system("pause");
	return 0;
}
