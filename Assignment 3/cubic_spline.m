function rtn = cubic_spline(x, f)
%S_0=S_n=0. Output is coefficient matrix of cubic polynomials
%where the first row represents the cubic spline
%a_1(x-x_1)^3 + b_1(x-x_1)^2 + c_1(x-x_1) + d_1 on [x_1, x_2]
%and the ith rows similarly represents the ith cubic spline
%on [x_i, x_(i+1)
%generate h-vector, differences of x's

h = zeros(1, length(x)-1);
for i = 1: length(h)
    h(i) = x(i+1) - x(i);
end

%generate coefficient matrix
A = sparse(length(h)-1, length(h)-1);
for i = 1 : length(h)-1
    A(i, i) = 2*(h(i)+h(i+1));
end

for i = 1 : length(h)-2
    A(i, i+1) = h(i+1);
end

for i = 1 : length(h)-2
    A(i+1, i) = h(i+1);
end

y = zeros(length(h)-1, 1);
for i = 1: length(h)-1
    y(i) = 6*((f(i+2)-f(i+1))/h(i+1)-(f(i+1)-f(i))/h(i));
end

S = A\y;
S = [0; S; 0];
a = zeros(length(h), 1);
b = zeros(length(h), 1);
c = zeros(length(h), 1);
d = zeros(length(h), 1);

for i = 1 : length(h)
    a(i) = (S(i+1)-S(i))/(6*h(i));
    b(i) = S(i)/2;
    c(i) = (f(i+1)-f(i))/h(i)-(2*h(i)*S(i)+h(i)*S(i+1))/6;
    d(i) = f(i);
end

coef = [a b c d]
end
%cubic_spline([-1, 1, 2, 4], [2, 0, 2, 3]);