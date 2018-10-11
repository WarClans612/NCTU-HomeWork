#include<stdio.h>
int main()
{
	char Wish;
	A:
	printf("\nDo you wish to see the content? (Y/N)  :");
	scanf(" %c",&Wish);
	getchar();
	if(Wish=='y'||Wish=='Y') 
		printf("\nThe content you like to see will soon be displayed.");
	else if(Wish=='n'||Wish=='N') 
		printf("\nYou choose not to see the content.\nThanks for using our program!");
	else if((Wish>=97&&Wish<=122)||(Wish>=65&&Wish<=90))
		{printf("\nSorry, you input the wrong character.\nPlease input Y or N to continue.\n\n");goto A;}
	else {printf("\nSorry, you input number.\nPlease input Y or N to continue.\n\n");goto A;};
	
	return 0;
}
