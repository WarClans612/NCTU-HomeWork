#include<stdio.h>
#include<stdlib.h>
#include<time.h>
int main()
{
	char ans;
	do	{
		system("cls");
	int x[4]= {0,0,0,0}, i=0, b[4] = {0,0,0,0}, a[10] = {0,0,0,0,0,0,0,0,0,0}, A, B, check, success = 0;
	char str[10];
	
	//Generating random numbers
	time_t now;
	time(&now);
	printf("Now time is %s",asctime(localtime(&now)));
	
	srand(time(NULL));
	while (i<=3) 
	{
		b[i] = (rand()%9) + 1;
		if (x[b[i]] == 0) {x[b[i]] = 1; i++;}
		else i=i;
	}
	//printf("%d\n", b[0]*1000 + b[1]*100 + b[2]*10 + b[3]);

	printf("\n\nPlease input a 4-digit integer. Four digits must be four different numbers.\n");
	do {
	success++;
	check=100;
	
	while (check==100)
	{
	i = 0;check = 0;
	printf("Your 4-digit number :");
	
	//Checking Mistake in input
	i=0;
	while (str[i-1] != '\n' && i<=10)
		{
		scanf("%c", &str[i]);
		if(str[0] < 48 || str[0] > 57) {printf("Your input does not begin with a numerical character.\n"); fflush(stdin); i=100; check=100;}
		else if((str[i] < 48 || str[i] > 57) && i!=4) {printf("You have to input a 4-digit number.\n"); i= 100;check =100;}
		i++;
		}
		
	
	//Checking same number
	i=0;
	while(i<=9)
	{
		a[i]= 0; i++;
	}
	i=0;
	while (i<=3 && check != 100)
	{
		a[(str[i]-48)] = a[(str[i]-48)] + 1;
		i++;  
	}
	i=0;
	while(i<=9 && check !=100) 
	{
	if(a[i] > 1) {printf("Two digits of the input are the same. Retry again!!\n"); i=100;check=100;}
	else i++;
	}

	
	}
	
	
	printf("Your input number is %d%d%d%d", str[0]-48, str[1]-48, str[2]-48, str[3]-48);
	//Checking A and B
	i = 0; A=0;
	while (i<=3)
	{
		if(b[i] == str[i] - 48) {A++; i++;}
		else i++;
	}
	printf("\t\t\t%dA", A);
	
	B = 0;
	if(b[0] == str[1] - 48) B++;
	if(b[0] == str[2] - 48) B++;
	if(b[0] == str[3] - 48) B++;
	if(b[1] == str[0] - 48) B++;
 	if(b[1] == str[2] - 48) B++;
 	if(b[1] == str[3] - 48) B++;
	if(b[2] == str[0] - 48) B++;
	if(b[2] == str[1] - 48) B++;
	if(b[2] == str[3] - 48) B++;
	if(b[3] == str[0] - 48) B++;
	if(b[3] == str[1] - 48) B++;
	if(b[3] == str[2] - 48) B++;
	printf("%dB\n", B);
	
	} while(b[0] != str[0]-48 || b[1] != str[1]-48 || b[2] != str[2]-48 || b[3] != str[3]-48);
	
	printf("\n\nCongratulations, after %d trials, you got the right number!", success);
	printf("\n\nDo you still want to play? (Y/N) 	:");
	
	ans = 'a'; i=0;
	while (ans != 'y' && ans != 'Y' && ans != 'n' && ans != 'N')	{
	if(i>0) printf("\nPlease re-input your answer :	");
	i++;
	scanf("%c", &ans); fflush(stdin);
	}
	
	} while (ans == 'y' || ans == 'Y');
	
	return 0;
}
