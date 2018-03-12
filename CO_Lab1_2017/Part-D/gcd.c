#include <stdio.h>

int main()
{
    int i, j, n, m, result;
    printf("Enter first integers: ");
    scanf("%d", &m);
    printf("Enter second integers: ");
    scanf("%d", &n);
    result = gcd(m, n);
    printf("Greatest common divisor: %d", result);
    return 0;
}

int gcd(int m, int n) 
{
    if(n == 0)
        return m;
    else
    {
    	int r = m % n;
		return gcd(n, r); 
	}
}
