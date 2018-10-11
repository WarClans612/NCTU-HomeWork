#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define size 100000
typedef struct
{
	int left, right;
} Line;
Line line[size]={0};

typedef int (*compfn)(const void*, const void*);

int compare(Line *elem1, Line *elem2)
{
   if ( elem1->left < elem2->left)
      return -1;

   else if (elem1->left > elem2->left)
      return 1;

   else
      return 0;
}

int main()
{	
	int i, j, n;
	double sum;
	//Reading info from file
	i=0;
	FILE *pFile;
	pFile = fopen("line_set1.txt", "r");
	if(pFile == NULL) printf("Error opening file\n");
	while(i<size)
	{
		fscanf(pFile, "%d", &line[i].left);
		fscanf(pFile, "%d", &line[i].right);
		i++;
	}
	fclose(pFile);
	
	qsort((void *) &line, size, sizeof(Line), (compfn)compare);
	
	
		
	i=0;
	sum = 0;
	while(i<size)
	{
		j=i+1;
		while(j<size)
		{
			if(line[j].left > line[i].right) break;
			if(line[i].left <= line[j].left && line[i].right >= line[j].right) n = line[j].right - line[j].left;
			else if(line[j].left <= line[i].left && line[j].right >= line[i].right) n = line[i].right - line[i].left;
			else if(line[i].left < line[j].right && line[j].left < line[i].left) n = line[j].right - line[i].left;
			else if(line[j].left < line[i].right && line[i].left < line[j].left) n = line[i].right - line[j].left;
			else n = 0;
			sum = sum+(double)n;
			n=0;
			j++;
		}
		i++;
	}
	printf("%f", sum);
	return 0;
}
