function rtn = divided_difference(x, f)
%input x is a vector with data
%input f is a vector with data
%divided difference table is d

n = length(x);
for k = 1: n-1
    d(k,1) = (f(k+1) - f(k))/(x(k+1) - x(k));
end
for j = 2: n-1
    for k = 1: n-j
        d(k, j) = (d(k+1, j-1) - d(k, j-1))/(x(k+j) - x(k));
    end
end
d(n,:) = 0;
d = [x' f' d];
d
end
%divided_difference([-0.2, 0.3, 0.7, -0.3, 0.1], [1.23, 2.34, -1.05, 6.51, -0.06])