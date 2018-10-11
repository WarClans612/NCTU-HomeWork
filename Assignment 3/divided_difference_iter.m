function rtn = divided_difference_iter(x, y, p)
%input x is a vector with data
%input f is a vector with data
%divided difference table is d
%interpolation with x = p

n = length(x);
a(1) = y(1);
for k = 1: n-1
    d(k, 1) = (y(k+1) - y(k))/(x(k+1) - x(k));
end

for j = 2: n-1
    for k = 1 : n-j
        d(k, j) = (d(k+1, j-1) - d(k, j-1))/(x(k+j) - x(k));
    end
end

for j = 2 : n
    a(j) = d(1, j-1);
end
df(1) = 1;
c(1) = a(1);
for j = 2 : n
    df(j) = (p-x(j-1)).*df(j-1);
    c(j) = a(j).*df(j);
end

d(n,:) = 0;
d = [x' y' d];
d
rtn = sum(c);

%Ordered from a to f
%divided_difference_iter([-0.2, 0.3, 0.7], [1.23, 2.34, -1.05], 0.4)
%divided_difference_iter([0.7, -0.3, 0.1], [-1.05, 6.51, -0.06], 0.4)
%divided_difference_iter([0.3, 0.7, 0.1], [2.34, -1.05, -0.06], 0.4)
%divided_difference_iter([-0.2, 0.3, 0.7, 0.1], [1.23, 2.34, -1.05, -0.06], 0.4)
%divided_difference_iter([-0.2, 0.3, 0.7, -0.3, 0.1], [1.23, 2.34, -1.05, 6.51, -0.06], 0.4)
