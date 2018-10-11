#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#define max_len 500

typedef struct
{
	enum { OPERATOR, OPERAND } tag;
	int token;
} Cake;
Cake cake[max_len];

typedef struct
{
	int length, width;
} Rect;
Rect ** stack;
Rect *recdata, *rectlist, * rectheap;

int main()
{
	FILE *pFile;
	pFile = fopen("size3.txt", "r");
	if(pFile == NULL) 
	{
		printf("Error opening file.\n");
		return 0;
	}
	
	//Reading data from file
	int i, j, min_len=99999, min_wid=99999, normal, num, max=0, idx=0, quit=0;
	int *chance;
	chance = malloc((max+2)*sizeof(int));
	while(1)
	{
		while(fscanf(pFile, "%d", &num) == 1)
		{
			//printf("num = %d\n", num);
			if(num == 1 && quit == 0) quit = 1;
			else if(num == 1 && quit == 1) 
			{
				quit = 2;
				break;	
			}
			cake[idx].tag = OPERAND;
			cake[idx++].token = num;
			if(max < num) max=num;
		}
		if (quit == 2) break;
		fscanf(pFile, "%c", &cake[idx].token);
		//printf("ch = %c\n", cake[idx].token);
		cake[idx++].tag = OPERATOR;
	}
	stack = (Rect **) malloc(max*sizeof(Rect*));
	rectlist = (Rect *) malloc((max+1)*sizeof(Rect));
	rectheap = (Rect *) malloc((max+1)*sizeof(Rect));
	recdata = (Rect *) malloc((max+1)*sizeof(Rect));
	fscanf(pFile, "%d", &rectlist[num].length);
	recdata[num].length = rectlist[num].length;
	fscanf(pFile, "%d", &rectlist[num].width);
	recdata[num].width = rectlist[num].width;
	for(i = 2; i<=max; i++)
	{
		fscanf(pFile, "%d", &num);
		fscanf(pFile, "%d", &rectlist[num].length);
		recdata[num].length = rectlist[num].length;
		fscanf(pFile, "%d", &rectlist[num].width);
		recdata[num].width = rectlist[num].width;
	}
	//printf("%d ", rectlist[3].length);
	//printf("%d\n", rectlist[3].width);
	//printf("ch = %d\n", cake[2].token);
	
	//Emptying chance array
	i=0;
	while(i<=max+1)
	{
		chance[i] = 0;
		i++;
	}
	
	//Finding the minimum area needed
	while(1)
	{		
		//Counting area for the cake
		j=0;i=0;normal=0;
		while(i<idx)
		{
			int len[2]={0}, wid[2]={0};
			if(cake[i].tag != OPERAND)
			{
				wid[0] = rectheap[j-2].width;
				wid[1] = rectheap[j-1].width;
				len[0] = rectheap[j-2].length;
				len[1] = rectheap[j-1].length;
				j=j-2;
				normal=0;
			}
			else if(cake[i].tag != OPERATOR)
			{
				int a=0;
				while(cake[i].tag != OPERATOR)
				{
					len[a%2] = rectlist[cake[i].token].length;
					wid[a%2] = rectlist[cake[i].token].width;
					i++;
					a++;
					normal++;
					if(a%2==1 && cake[i].tag == OPERATOR)
					{
						len[a%2] = rectheap[j-1].length;
						wid[a%2] = rectheap[j-1].width;
						j--;
						normal=0;
						break;
					}
				}
			}
			if(cake[i].token == 'H') 
			{
				rectheap[j].width = wid[0] + wid[1]; 
				if(len[0] >= len[1]) rectheap[j].length = len[0];
				else rectheap[j].length = len[1];
				j++;			
			}
			else if(cake[i].token == 'V') 
			{
				rectheap[j].length = len[0] + len[1]; 
				if(wid[0] >= wid[1]) rectheap[j].width = wid[0];
				else rectheap[j].width = wid[1];
				j++;
			}
			i++;
		}
		if(min_len*min_wid > rectheap[j-1].length*rectheap[j-1].width)
		{
			min_len = rectheap[j-1].length;
			min_wid = rectheap[j-1].width;
			/*if(min_len*min_wid == 455)
			{
				i=1;
				while(i<=max)
				{
					printf("%d*%d ", rectlist[i].length, rectlist[i].width);
					i++;
				}
			}*/
		}  
		/*printf("Length = %d\n", rectheap[j-1].length);
		printf("Width = %d\n", rectheap[j-1].width);
		printf("Area = %d\n", rectheap[j-1].length * rectheap[j-1].width);
		printf("------------------------------------------------------\n");*/
		
		//Determining other possibility
		chance[1]++;
		i=0;
		while(i<=max)
		{
			if(chance[i] > 1) 
			{
				chance[i+1]++;
				chance[i]=0;
			}
			i++;
		}
		i=1;
		while(i<=max)
		{
			if(chance[i]==1)
			{
				rectlist[i].length = recdata[i].width;
				rectlist[i].width = recdata[i].length;
			}
			else if(chance[i]==0)
			{
				rectlist[i].length = recdata[i].length;
				rectlist[i].width = recdata[i].width;
				
			}
			i++;
		}
		if(chance[max+1]>0) break;
		/*i=0;
		while(i<=max)
		{
			printf("%d", chance[i]);
			i++; 
		}
		
		system("pause");*/
	}
	//printf("%d\n", idx);
	printf("Length = %d\n", min_len);
	printf("Width = %d\n", min_wid);
	printf("Minimum Area = %d\n", min_len * min_wid);

	
	fclose(pFile);
	return 0;
}
