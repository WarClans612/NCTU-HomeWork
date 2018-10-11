#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#define MAX_LEN 200
#define MAX_ROW 200

int main(int argc, char **argv)
{
	int  spam=2, email=4, tm=1, tn=1, m=1, n=1, num, no,limit, i, k, multiply[MAX_ROW] = {0}, weight[10][MAX_ROW] = {0};
	char para[100][100]={0}, *token, s[]= {'/', '.', '!', '@', '$', '%', '&', '*', '(', ')', '[', ']', '{', '}', ';', ':', '"', '<', '>', '-'}, 
			keyword[MAX_ROW][MAX_LEN]={0}, trash[100][100]={0};

	if(!strcmp(*(argv+spam), "-k")) m=1;
		else if(!strcmp(*(argv+spam), "-k2")) m=2;
		else if(!strcmp(*(argv+spam), "-k3")) m=3;
		else if(!strcmp(*(argv+spam), "-k4")) m=4;
		else if(!strcmp(*(argv+spam), "-k5")) m=5;
		else if(!strcmp(*(argv+spam), "-k6")) m=6;
		else if(!strcmp(*(argv+spam), "-k7")) m=7;
		else if(!strcmp(*(argv+spam), "-k8")) m=8;
		else if(!strcmp(*(argv+spam), "-k9")) m=9;
	email=spam+m+1;
	if(!strcmp(*(argv+email), "-e")) n=1;
		else if(!strcmp(*(argv+email), "-e2")) n=2;
		else if(!strcmp(*(argv+email), "-e3")) n=3;
		else if(!strcmp(*(argv+email), "-e4")) n=4;
		else if(!strcmp(*(argv+email), "-e5")) n=5;
		else if(!strcmp(*(argv+email), "-e6")) n=6;
		else if(!strcmp(*(argv+email), "-e7")) n=7;
		else if(!strcmp(*(argv+email), "-e8")) n=8;
		else if(!strcmp(*(argv+email), "-e9")) n=9;
	//printf("%d %d %d %d", m , n, spam, email);
	
	if(strcmp(*(argv+1), "chkspam") || (strcmp(*(argv+(email+n+1)), "-spam") && strcmp(*(argv+(email+n+1)), "-oc"))) printf("\nYou input the wrong format.\n");
	else
	{	
		//Determining error opening file
		i=1;
		while(i<=m)
		{
			if (fopen(*(argv+(spam+i)), "r") == NULL)
			{
				printf("\nError opening file %s.\n", *(argv+(spam+i)));
				return 0;
			}
			i++;
		}
		i=1;
		while(i<=n)
		{
			if (fopen(*(argv+(email+i)), "r") == NULL)
			{
				printf("\nError opening file %s.\n", *(argv+(email+i)));
				return 0;
			}
			i++;
		}
		//Saving keyword from files
		i=0;
		while(tm <= m)
		{
			FILE *pFile;
			pFile = fopen(*(argv+(spam+tm)), "r");
			while(i < MAX_ROW*2)
			{
				if(i != 0 && i%2 == 1) fscanf(pFile, "%s", keyword[(int)(i/2)]);
				else 
				{
					fscanf(pFile, "%s", trash[(int)(i/2)]);
					multiply[(int)(i/2)] = atoi(trash[(int)(i/2)]);
				}
				//printf("%s", keyword[(int)(i/2)]);
				if(multiply[(int)(i/2)] != -999) i++;
				else break;
			}
			fclose(pFile);
			tm++;
		}
		
		while(tn<=n)
		{
			char word[10000][MAX_LEN]={};
			i=0;k=0;
			//Reading words from file
			FILE *dFile;
			dFile = fopen(*(argv+(email+tn)), "r");
			while(i<MAX_ROW)
			{
				fscanf(dFile, "%s", word[i]);
				if(word[i][0] == 0) break;
				//Change the string into small letters
				k=0;
				while(k<MAX_LEN)
				{
					if(word[i][k] >='A' && word[i][k] <='Z') word[i][k] +=32;
					k++;
				}
				//Separating word from others
				token = strtok(word[i], s);
				while( token != NULL ) 
	   			{
	   				strcpy(word[i], token);
					token = strtok(NULL, s);
					if(token != NULL) i++;
	   			}
				i++;
			}
			fclose(dFile);
			num=i+1;
			printf("\n");
			if(!strcmp(*(argv+(email+n+1)), "-oc"))printf("** The statistics of the occurrence of each keyword in file %s **\n", *(argv+email+tn));
			tn++;
			//Determining occurence times
			i=0;
			while(1)
			{
				int j=0;
				while(j < 10000)
				{
					if(!(strcmp(word[j], keyword[i]))) weight[tn][i]++;
					j++;
				}
				if(multiply[i]==-999) { i--; no=i; break; }
				if(weight[tn][i] != 0 && !strcmp(*(argv+(email+n+1)), "-oc"))printf("\t %s  = %d\n", keyword[i], weight[tn][i]);
				i++;
			}
			i=0;k=0;
			while(i<=no)
			{
				k = k + (weight[tn][i] * multiply[i]);
				i++;
			}
			if(!strcmp(*(argv+(email+n+1)), "-spam")) 
			{
				printf("\n** The file %s is ", *(argv+email+tn-1));
				if(((float)k/(float)(num*5))*100 > 20) printf(" spam email **\n");
				else printf(" not spam email **\n");
				//printf("%d ", k);
				//printf("%f%%\n", ((float)k/(float)(num*5))*100);
				//printf("%d\n", num);
			}
			printf("*******************************************************************************\n");
		}
	}
	return 0;
}
