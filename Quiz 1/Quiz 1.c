#include<stdio.h>

int main()
{
	int country, check=0, i, m, n, time, jam=0, jam1=0, dif[10], menit=0, get[9] = {350, 480, 550, 690, 800, 900, 1155, 1290, 1400};
	char ans, zone, we, str[36][12] = {"05:50 a.m.", "08:00 a.m.", "09:10 a.m.", "11:30 a.m.", "01:20 p.m.", "03:00 p.m.", "07.15 p.m.", "09:30 p.m.", "11:20 p.m.", 
		"11:10 a.m.", "12:00 p.m.", "00:00 a.m.", "02:20 p.m.", "04:50 p.m.", "07:15 p.m.", "11:50 p.m.", "02:30 p.m.", "11:40 a.m.", 
		"Taipei", "Taipei", "Taipei", "Taipei", "Seoul", "Beijing", "Bangkok", "Taipei", "Taipei", 
		"Tokyo", "Kyoto", "Sydney", "Shanghai", "Taipei", "Taipei", "Taipei", "Bombay", "San Jose"}; 
	
	//Use the program again
	do {

	//Choosing query	
	printf("1. Query the closest flight to your input time.\n");
	printf("2. Query the flights that depart from your specified city and after your specified time.\n");
	printf("Input 1 or 2 to select the service you want ( 1 or 2 )	:");
	
	//Repetition if input is wrong
	i =1;
	do {
	if(check != 1 && check != 2 && i > 1) printf("Please re-input your answer with 1 or 2	:");
	scanf("%d", &check);
	fflush(stdin);
	i++;
	} while(check !=1 && check != 2);
	
	if( check == 1)
	{
		//Repetition if input is wrong
		printf("\nPlease input a time to find the closest flight (from 00:00 to 23:59)	:");
		do
		{
			if ( time < 0 || time > 1439) printf("\nPlease re-input time between 00:00 to 23:59	:");
			scanf("%d%c%d", &jam, &we, &menit);	
			fflush(stdin);
			
			time = (jam*60) + menit;
		} while ( time < 0 || time > 1439);
	
		//Counting the difference between time
		i = 0;
		while (i <= 8) 
			{
				dif[i] = time - get[i];
				if(dif[i] < 0) dif[i] = -1 * dif[i];
				i++;
			}
		
		//Searching the smallest difference
		i=0;
		n =100000000;
		while(i <= 8)
			{
				if(dif[i] < n) 
					{
						n = dif[i];
						m = i;
					}	
				i++;	
			}
		
		//Converting to 12 hour clock	
		if(jam > 12) jam1 = jam-12;
		else jam1 = jam;
			
		printf("\nThe closest flight to your input time ( %.2d%c%.2d", jam1, we, menit);
		if(jam >= 12) printf(" p.m. )");
		else printf(" a.m. )");
		printf(" is from %s departing at %s and reaches %s at %s", str[m+18], str[m], str[m+27], str[m+9]);
	}// End of Query 1
	
	
	else if( check == 2)
	{
		printf("\nFor this query, you have to select a time and a city to filter the flights.\n");
		printf("Input a time to find the flights whose departure time is equal to or after the  time (from 00:00 to 23:59)	:");
		
		//Repetition if input is wrong
		do
		{	
			if ( time < 0 || time > 1439) printf("\nPlease re-input time between 00:00 to 23:59	:");
			scanf("%d%c%d", &jam, &we, &menit);	
			fflush(stdin);
			
			time = (jam*60) + menit;
		} while ( time < 0 || time > 1439);
		
		//Converting to 12 hour clock	
		if(jam > 12) jam1 = jam-12;
		else jam1 = jam;
		
		i=0;
		while(i<=8)
			{
				if(time <= get[i]) {m=i; break;}
				i++;
			}
		
		printf("0: Taipei. 1:Seoul. 2:Beijing. 3:Shanghai. 4:Tokyo. 5:Kyoto. 6:Bombay. 7:Sydney. 8:Bangkok. 9:SanJose.\n");
		printf("\nInput anumber from 0 to 9 to select a city from which the flights depart : ");
		country = 0;
		
		//Repetition if input is wrong
		do
		{
			if(country!=0&&country!=1&&country!=2&&country!=3&&country!=4&&country!=5&&country!=6&&country!=7&&country!=8&&country!=9) 
						printf("\nPlease re-input with number from 0 to 9	:");
			scanf("%d", &country);
			fflush(stdin);
		} while (country!=0&&country!=1&&country!=2&&country!=3&&country!=4&&country!=5&&country!=6&&country!=7&&country!=8&&country!=9) ;
		
		if(country == 1 && time <= 800) 
			{
				printf("\nThe closest flight to your input time ( %.2d%c%.2d", jam1, we, menit);
				if(jam >= 12) printf(" p.m. )");
				else printf(" a.m. )");
				printf(" is from %s departing at %s and reaches %s at %s", str[22], str[4], str[31], str[13]);
			}
		if(country == 2 && time <= 900)
			{
				printf("\nThe closest flight to your input time ( %.2d%c%.2d", jam1, we, menit);
				if(jam >= 12) printf(" p.m. )");
				else printf(" a.m. )");
				printf(" is from %s departing at %s and reaches %s at %s", str[23], str[5], str[32], str[14]);	
			} 
		if(country == 8 && time <= 1155)
			{
				printf("\nThe closest flight to your input time ( %.2d%c%.2d", jam1, we, menit);
				if(jam >= 12) printf(" p.m. )");
				else printf(" a.m. )");
				printf(" is from %s departing at %s and reaches %s at %s", str[24], str[6], str[33], str[15]);	
			} 
		if(country == 0 && time <= 350)
			{
				printf("\nThe closest flight to your input time ( %.2d%c%.2d", jam1, we, menit);
				if(jam >= 12) printf(" p.m. )");
				else printf(" a.m. )");
				printf(" is from %s departing at %s and reaches %s at %s", str[18], str[0], str[27], str[9]);	
			} 
		if(country == 0 && time <= 480)
			{
				printf("\nThe closest flight to your input time ( %.2d%c%.2d", jam1, we, menit);
				if(jam >= 12) printf(" p.m. )");
				else printf(" a.m. )");
				printf(" is from %s departing at %s and reaches %s at %s", str[19], str[1], str[28], str[10]);	
			} 
		if(country == 0 && time <= 550)
			{
				printf("\nThe closest flight to your input time ( %.2d%c%.2d", jam1, we, menit);
				if(jam >= 12) printf(" p.m. )");
				else printf(" a.m. )");
				printf(" is from %s departing at %s and reaches %s at %s", str[20], str[2], str[29], str[11]);	
			} 
		if(country == 0 && time <= 690)
			{
				printf("\nThe closest flight to your input time ( %.2d%c%.2d", jam1, we, menit);
				if(jam >= 12) printf(" p.m. )");
				else printf(" a.m. )");
				printf(" is from %s departing at %s and reaches %s at %s", str[21], str[3], str[30], str[12]);	
			} 
		if(country == 0 && time <= 1290)
			{
				printf("\nThe closest flight to your input time ( %.2d%c%.2d", jam1, we, menit);
				if(jam >= 12) printf(" p.m. )");
				else printf(" a.m. )");
				printf(" is from %s departing at %s and reaches %s at %s", str[25], str[7], str[34], str[16]);	
			}
		if(country == 0 && time <= 1400)
			{
				printf("\nThe closest flight to your input time ( %.2d%c%.2d", jam1, we, menit);
				if(jam >= 12) printf(" p.m. )");
				else printf(" a.m. )");
				printf(" is from %s departing at %s and reaches %s at %s", str[26], str[8], str[35], str[17]);	
			}
		else 
			{
				printf("\nThere is no flight matching your query demands");
			} 
	}//End of Query 2
	
	
	
	printf("\n\nDo you want to use the program again (Y/N)	:");
	ans = 'y';
	do 
	{
		if(ans!='y'&&ans!='Y'&&ans!='n'&&ans!='N') printf("\nPlease re-input using (Y/N)	:");
		scanf("%c", &ans);
		fflush(stdin);
		if (ans == 'y' || ans == 'Y') system("cls");
	} while (ans!='y'&&ans!='Y'&&ans!='n'&&ans!='N');
	
	
	
	
	
	
	
	} while (ans == 'y' || ans == 'Y');
	return 0;
}
