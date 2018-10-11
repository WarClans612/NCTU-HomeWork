#include<stdio.h>
#include<stdlib.h>
#include<string.h>

//Structure for 2 point on line
typedef struct
{
	int corx[2], cory[2];
	enum {UP, DOWN, USELESS} direction;
} Line;
Line *line;

//Structure for rectangle and cooordinate of left down point of the rectangle
typedef struct
{
	int area;
	int corx, cory;
} Rect;
Rect *rect;

//Sorting comparison
typedef int (*compfn)(const void*, const void*);
int compare1(Line *elem1, Line *elem2)
{
   return elem1->corx[0] - elem2->corx[0];
}
int compare2(Rect *elem1, Rect *elem2)
{
   return elem1->cory - elem2->cory;
}

//Managing Line
void line_manage(int *i, int *j, int *k, int *max, Line *t_line, Rect *t_rect)
{
	int n, temp;
	//The line has the same y point
	if((t_line+*i)->cory[0] == (t_line+*j)->cory[0] && (t_line+*i)->cory[1] == (t_line+*j)->cory[1] && (t_line+*i)->direction != (t_line+*j)->direction) 
	{
		//Area
		(t_rect+*k)->area = ((t_line+*j)->corx[0] - (t_line+*i)->corx[0]) * ((t_line+*i)->cory[1] - (t_line+*i)->cory[0]);
		(t_rect+*k)->corx = (t_line+*i)->corx[0];
		(t_rect+*k)->cory = (t_line+*i)->cory[0];
		//Making array move forward because of missing line that has been used
		(t_line+*i)->corx[0] = 0;
		(t_line+*i)->corx[1] = 0;
		(t_line+*i)->cory[0] = 0;
		(t_line+*i)->cory[1] = 0;
		(t_line+*i)->direction = USELESS;
		(t_line+*j)->corx[0] = 0;
		(t_line+*j)->corx[1] = 0;
		(t_line+*j)->cory[0] = 0;
		(t_line+*j)->cory[1] = 0;
		(t_line+*j)->direction = USELESS;
		(*j) = (*i);
	}
	//Line after is inside
	else if((t_line+*i)->cory[0] < (t_line+*j)->cory[0] && (t_line+*i)->cory[1] > (t_line+*j)->cory[1] && (t_line+*i)->direction != (t_line+*j)->direction)
	{
		//Area
		(t_rect+*k)->area = ((t_line+*j)->corx[0] - (t_line+*i)->corx[0]) * ((t_line+*j)->cory[1] - (t_line+*j)->cory[0]);
		(t_rect+*k)->corx = (t_line+*i)->corx[0];
		(t_rect+*k)->cory = (t_line+*j)->cory[0];
		//Dividing line into 2 new line because it has meet
		(t_line+*j)->corx[0] = (t_line+*i)->corx[0];
		(t_line+*j)->corx[1] = (t_line+*i)->corx[1];
		temp = (t_line+*j)->cory[0];
		(t_line+*j)->cory[0] = (t_line+*j)->cory[1];
		(t_line+*j)->cory[1] = (t_line+*i)->cory[1];
		(t_line+*i)->cory[1] = temp;
		(t_line+*j)->direction = (t_line+*i)->direction;
		(*j) = (*i);
	}
	//Line before is inside
	else if((t_line+*j)->cory[0] < (t_line+*i)->cory[0] && (t_line+*j)->cory[1] > (t_line+*i)->cory[1] && (t_line+*i)->direction != (t_line+*j)->direction)
	{
		//Area
		(t_rect+*k)->area = ((t_line+*j)->corx[0] - (t_line+*i)->corx[0]) * ((t_line+*i)->cory[1] - (t_line+*i)->cory[0]);
		(t_rect+*k)->corx = (t_line+*i)->corx[0];
		(t_rect+*k)->cory = (t_line+*i)->cory[0];
		//Dividing line into 2 new line because it has meet
		(t_line+*i)->corx[0] = (t_line+*j)->corx[0];
		(t_line+*i)->corx[1] = (t_line+*j)->corx[1];
		temp = (t_line+*i)->cory[1];
		(t_line+*i)->cory[1] = (t_line+*i)->cory[0];
		(t_line+*i)->cory[0] = (t_line+*j)->cory[0];
		(t_line+*j)->cory[0] = temp;
		(t_line+*i)->direction = (t_line+*j)->direction;
		(*j) = (*i);
	}
	//Upper point of line has the same y-coordinate
	else if((t_line+*i)->cory[1] == (t_line+*j)->cory[1]  && (t_line+*i)->direction != (t_line+*j)->direction)
	{
		//If line after lower point is lower
		if((t_line+*j)->cory[0] < (t_line+*i)->cory[0])
		{
			//Area
			(t_rect+*k)->area = ((t_line+*j)->corx[0] - (t_line+*i)->corx[0]) * ((t_line+*i)->cory[1] - (t_line+*i)->cory[0]);
			(t_rect+*k)->corx = (t_line+*i)->corx[0];
			(t_rect+*k)->cory = (t_line+*i)->cory[0];
			(t_line+*j)->cory[1] = (t_line+*i)->cory[0];			
		}
		//If line after lower point is higher
		else
		{
			//Area
			(t_rect+*k)->area = ((t_line+*j)->corx[0] - (t_line+*i)->corx[0]) * ((t_line+*j)->cory[1] - (t_line+*j)->cory[0]);
			(t_rect+*k)->corx = (t_line+*i)->corx[0];
			(t_rect+*k)->cory = (t_line+*j)->cory[0];
			(t_line+*j)->corx[0] = (t_line+*i)->corx[0];
			(t_line+*j)->corx[1] = (t_line+*i)->corx[1];
			(t_line+*j)->cory[1] = (t_line+*j)->cory[0];
			(t_line+*j)->cory[0] = (t_line+*i)->cory[0];
			(t_line+*j)->direction = (t_line+*i)->direction;
		}
		//Making array move forward because of missing line that has been used
		(t_line+*i)->corx[0] = 0;
		(t_line+*i)->corx[1] = 0;
		(t_line+*i)->cory[0] = 0;
		(t_line+*i)->cory[1] = 0;
		(t_line+*i)->direction = USELESS;
		(*j)=(*i);
	}
	//Lower point of line has the same y-coordinate
	else if((t_line+*i)->cory[0] == (t_line+*j)->cory[0]  && (t_line+*i)->direction != (t_line+*j)->direction)
	{
		//If line after upper point is higher
		if((t_line+*j)->cory[1] > (t_line+*i)->cory[1])
		{
			//Area
			(t_rect+*k)->area = ((t_line+*j)->corx[0] - (t_line+*i)->corx[0]) * ((t_line+*i)->cory[1] - (t_line+*i)->cory[0]);
			(t_rect+*k)->corx = (t_line+*i)->corx[0];
			(t_rect+*k)->cory = (t_line+*i)->cory[0];
			(t_line+*j)->cory[0] = (t_line+*i)->cory[1];						
		}
		//If line after upper point is lower
		else
		{
			//Area
			(t_rect+*k)->area = ((t_line+*j)->corx[0] - (t_line+*i)->corx[0]) * ((t_line+*j)->cory[1] - (t_line+*j)->cory[0]);
			(t_rect+*k)->corx = (t_line+*i)->corx[0];
			(t_rect+*k)->cory = (t_line+*i)->cory[0];
			(t_line+*j)->corx[0] = (t_line+*i)->corx[0];
			(t_line+*j)->corx[1] = (t_line+*i)->corx[1];
			(t_line+*j)->cory[0] = (t_line+*j)->cory[1];
			(t_line+*j)->cory[1] = (t_line+*i)->cory[1];
			(t_line+*j)->direction = (t_line+*i)->direction;						
		}
		//Making array move forward because of missing line that has been used
		(t_line+*i)->corx[0] = 0;
		(t_line+*i)->corx[1] = 0;
		(t_line+*i)->cory[0] = 0;
		(t_line+*i)->cory[1] = 0;
		(t_line+*i)->direction = USELESS;
		(*j)=(*i);
	}
	//Line before is lower
	else if((t_line+*i)->cory[0] < (t_line+*j)->cory[0] && (t_line+*i)->cory[1] > (t_line+*j)->cory[0] && (t_line+*i)->direction != (t_line+*j)->direction) 
	{
		//Coordinate exchange
		temp = (t_line+*i)->cory[1];
		(t_line+*i)->cory[1] = (t_line+*j)->cory[0];
		(t_line+*j)->cory[0] = temp;
		//Area
		(t_rect+*k)->area = ((t_line+*j)->corx[0] - (t_line+*i)->corx[0]) * ((t_line+*j)->cory[0] - (t_line+*i)->cory[1]);
		(t_rect+*k)->corx = (t_line+*i)->corx[1];
		(t_rect+*k)->cory = (t_line+*i)->cory[1];
		(*j)=(*i);
	}
	//Line before is higher
	else if((t_line+*j)->cory[0] < (t_line+*i)->cory[0] && (t_line+*i)->cory[0] < (t_line+*j)->cory[1] && (t_line+*i)->direction != (t_line+*j)->direction)
	{
		//Coordinate exchange
		temp = (t_line+*i)->cory[0];
		(t_line+*i)->cory[0] = (t_line+*j)->cory[1];
		(t_line+*j)->cory[1] = temp;
		//Area
		(t_rect+*k)->area = ((t_line+*j)->corx[0] - (t_line+*i)->corx[0]) * ((t_line+*i)->cory[0] - (t_line+*j)->cory[1]);
		(t_rect+*k)->corx = (t_line+*i)->corx[0];
		(t_rect+*k)->cory = (t_line+*j)->cory[1];
		(*j)=(*i);
	}
	else //no connection between line
	{
		//Don't add k
		(*k)--;
	}
	(*k)++;
	return;
}

int main(int argc, char **argv)
{
	//Opening File
	FILE *pFile;
	pFile = fopen(*(argv+1), "r");
	if(pFile == NULL)
	{
		printf("Error opening file");
		return 0;
	}
	
	int i, j, k, n, max, temp, ave, sum;
	
	//Reading info from file
	fscanf(pFile, "%d", &max);
	//Opening dynamic array depend on the amount of line
	line = (Line *) malloc(50*(max+1) * sizeof(Line));
	rect = (Rect *) malloc(50*(max+1) * sizeof(Rect));
	fscanf(pFile, "%d", &line[0].corx[0]);
	fscanf(pFile, "%d", &line[0].cory[0]);
	i = 1;
	j = 1;
	k = 0;
	while(i<max)
	{
		fscanf(pFile, "%d", &line[j].corx[0]);
		fscanf(pFile, "%d", &line[j].cory[0]);
		if(line[j-1].corx[0] == line[j].corx[0]) 
		{
			line[j-1].corx[1] = line[j].corx[0];
			line[j-1].cory[1] = line[j].cory[0];
			j--;
		}
		else if(i == 1 && line[j-1].corx[0] != line[j].corx[0])
		{
			temp = line[0].corx[0];
			sum = line[0].cory[0];
			k++;
		}
		if(line[j].cory[0] <= line[j].cory[1]) line[j].direction = UP;
		else line[j].direction = DOWN;
		i++;
		j++;
	}
	if(k>0)
	{
		line[0].corx[1] = line[j-1].corx[0];
		line[0].cory[1] = line[j-1].cory[0];
		if(line[0].cory[0] > line[0].cory[1]) line[0].direction = UP;
		else line[0].direction = DOWN;
		max = j-1;
	}
	else max = j;
	//printf("%d", max);
	
/*	//Printing all line happened	
	n=0;
	while(n<max)
	{
		printf("%d ", line[n].corx[0]);
		printf("%d ------ ", line[n].cory[0]);
		printf("%d ", line[n].corx[1]);
		printf("%d -- ", line[n].cory[1]);
		printf("%d\n", line[n].direction);
		n++;
	}
*/
		
	//Sorting line base on increasing x and y coordinate
	qsort((void *) line, max, sizeof(Line), (compfn)compare1);			
	n = 0;
	while(n < max)
	{
		if(line[n].cory[0] > line[n].cory[1])
		{
			temp = line[n].cory[0];
			line[n].cory[0] = line[n].cory[1];
			line[n].cory[1] = temp;
		}
		n++;
	}

	//Determining the area of each rectangle	
	i = 0;
	k = 0;
	while (i<max)
	{
		j = i + 1;
		while(j<max || j==2)
		{
			//Sort
			qsort((void *) line, max, sizeof(Line), (compfn)compare1);
			sum  = 1;
			while(sum != 0)
			{
				sum = 0;
				n = 0;
				while (n < max-1)
				{
					if(line[n].corx[0] == line[n+1].corx[0] && line[n].cory[0] > line[n+1].cory[0])
					{
						temp = line[n].cory[0];
						line[n].cory[0] = line[n+1].cory[0];
						line[n+1].cory[0] = temp;
						temp = line[n].cory[1];
						line[n].cory[1] = line[n+1].cory[1];
						line[n+1].cory[1] = temp;
						temp = line[n].direction;
						line[n].direction = line[n+1].direction;
						line[n+1].direction = temp;
						sum++;
					}
					n++;
				}
			}
			//Managing line through function
			line_manage(&i, &j, &k, &max, &line[0], &rect[0]);
		 	j++;
			//system("pause");
		} 
		i++;
 	} 
	
	//Sorting area
	qsort((void *) rect, k, sizeof(Rect), (compfn)compare2);
	n = 0;
	while(n<k-1)
	{
		if(rect[n].cory == rect[n+1].cory && rect[n].corx > rect[n+1].corx)
		{
			temp = rect[n].corx;
			rect[n].corx = rect[n+1].corx;
			rect[n+1].corx = temp;
			temp = rect[n].area;
			rect[n].area = rect[n+1].area;
			rect[n+1].area = temp;
		}
		n++;
	}
	
	//Answer for question
	printf("\n%d\n", k);
	temp = 0;
	n = 0;
	while(n<k)
	{
		temp += rect[n].area;
		n += 2;
	}
	printf("%d\n", temp);
	n = 0;
	while(n<k)
	{
		ave += rect[n].area;
		n++;
	}
	ave = ave / k;
	n = 0;
	temp = 0;
	while(n<=k)
	{
		if(rect[n].area > ave)
		{
			temp += rect[n].area;
		}
		n++;
	}
	printf("%d\n", temp);
	
	sum=-1;
	while(n != -1)
	{
		i = 1;
		if (sum != -1)printf("%d\n", sum);
		sum = 0;
		fscanf(pFile, "%d", &n);
		while( i <= n)
		{
			fscanf(pFile, "%d", &temp);
			sum += rect[temp-1].area;
			i++;
		}
	}
	fclose(pFile);
	return 0;
}
