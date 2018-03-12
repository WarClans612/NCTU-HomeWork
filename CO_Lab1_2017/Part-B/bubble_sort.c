#include <stdio.h>
#include <stdlib.h>

void bubblesort(int *data, int n);
void swap(int v[],int k);
int main(void)
{
    int i, n = 10;
    int data[10]= {5,3,6,7,31,23,43,12,45,1};
    printf("The array before sort : ");
    for (i = 0; i < n; i++)
    {
       printf("%d ",data[i]); 
    }
    
    bubblesort(data, n);

    printf("\nThe array after  sort : ");
    for (i = 0; i < n; i++)
    {
        printf("%d ", data[i]);
    }

    printf("\n");
 
}

void bubblesort(int v[], int n)          
{
    int i, j;
    for (i = 0 ;i < n ; i++ )
    {
        for (j = i-1 ; j >= 0 && v[j] > v[j+1] ; j--)
        {
            
               swap(v,j) ;
            
        }
    }
}
void swap (int v[] ,int k )            
{
  int temp;
  temp = v[k] ;
  v[k] = v[k+1]    ;
  v[k+1] = temp ;
}




