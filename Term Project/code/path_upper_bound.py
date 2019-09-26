import math

def nCr(n,r):
    f = math.factorial
    return f(n) / f(r) / f(n-r)


def path_upper_bound(n):
    ans = 0
    for i in range(n-1):
        ans += nCr(n-2, i) * math.factorial(i)
    return ans

print(path_upper_bound(13))