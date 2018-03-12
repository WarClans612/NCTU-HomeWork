
#include <stdio.h>
int main() 
{
int i,j,n,temp;
       
printf("Pascal Triangle \nPlease enter the number of levels(1~30): ");
scanf("%d", &n);
	
for (i = 0; i < n; i++) {
      for (j = 0; j <= i; j++) {
           if ( j==0 || j == i){
               temp = 1;
	}
	else{
	    temp = temp*(i-j+1)/j;	
	}	
	printf(" %d",temp );
       }
      printf("\n");
}
   
return 0;	    
}

