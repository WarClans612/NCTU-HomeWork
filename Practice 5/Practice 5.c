#include<stdio.h>
int main()
{
	int num, n, check, store, i, b[11], ang[3];
	char ans;

do {
	system("cls");
	//Generating random numbers
	time_t now;
	time(&now);
	
	srand(time(NULL));
	i = 1;
	printf("Random array	:\n");
	while (i<=10) 
	{
		b[i] = (rand()%900) + 100;
		printf("%d ", b[i]);
		i++;
	}
	printf("\n");
	fflush(stdin);
	n=1;
	do {
	if(n==1) printf("To order increasingly (i) and decreasingly (d)	:");
	else if(n==2) printf("Please re-input your answer	:");
	scanf("%c", &ans);
	fflush(stdin);
	
	//increasing order
	if(ans == 'i')
	{
		n=9;
		check = 1;
		while(check > 0)
		{
			i=1;
			check=0;
			while(i<=n)
			{
				if(b[i] > b[i+1]) { store = b[i]; b[i] = b[i+1]; b[i+1] = store; check++;}
				i++;
			}
			n--;
		}

	}
	
	//decreasing order
	else if(ans == 'd')
	{
		n=9;
		check = 1;
		while(check > 0)
		{
			i=1;
			check=0;
			while(i<=n)
			{
				if(b[i] < b[i+1]) { store = b[i]; b[i] = b[i+1]; b[i+1] = store; check++;}
				i++;
			}
			n--;
		}
	}
	n=2;
	} while(ans != 'i' && ans != 'd'); // Repetition of wrong input
	
	i=1;
	printf("Sorted array	:\n");
	while(i<=10)
	{
		printf("%d ", b[i]);
		i++;
	}
	
	ang[0] = 0;
	while(ang[0] != 'r' && ang[0] != 'R' && ang[0] != 'Q' && ang[0] != 'q')
	{
		//while(ang[0] =='\n')
		//{
			printf("\nWhat number would you like to find	:");
			i=0;
			while(i<=2 && ang[i-1] != '\n')
			{
				ang[i] = 0;
				ang[i] = getchar();
				i++;
			}
			fflush(stdin);
		//}
		
		//Skipping useless
		if(ang[0] != 'r' && ang[0] != 'R' && ang[0] != 'Q' && ang[0] != 'q')
		{
			num = (ang[0]-48)*100 + (ang[1]-48)*10 + (ang[2]-48);
			
			//Checking validity
			i=1;
			check=0;
			while(i<=10)
			{
				if(b[i] == num) check++;
				i++;
			}
			if(check == 0 ) printf("%d in not found.", num);
			else
			{
				//for increasing query
				if(ans == 'i')
				{
					i=10;
					while(b[i] != num)
					{
						i = i/2;
						if(b[i] > num) {i = i-1;}
						else if(b[i] < num) {i = 3 * i ;}
					}
				}
				//for decreasing query
				else if(ans == 'd')
				{
					i=10;
					while(b[i] != num)
					{
						i = i/2;
						if(b[i] < num) {i = i-1;}
						else if(b[i] > num) {i = 3 * i ;}
					}
				}
				
				printf("The index of %d is %d", num, i-1);
			}
		}
	}
} while(ang[0] == 'r' || ang[0] == 'R');

	printf("\n Your program session has ended!!!!");
	return 0;
}
