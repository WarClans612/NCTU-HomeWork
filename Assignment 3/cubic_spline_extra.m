function rtn = cubic_spline_extra(X, F, x0)
%S_0=S_n=0. Output is coefficient matrix of cubic polynomials
%where the first row represents the cubic spline
%a_1(x-x_1)^3 + b_1(x-x_1)^2 + c_1(x-x_1) + d_1 on [x_1, x_2]
%and the ith rows similarly represents the ith cubic spline
%on [x_i, x_(i+1)
%generate h-vector, differences of x's
x = X';
f = F';

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

coef = [a b c d];
syms u;
line = [1; u; u^2; u^3];
fc = coef*line;

if (x0 < x(1))
    rtn = double(subs(fc(1), u, x0));
elseif (x0 >= x(length(x)))
    rtn = double(subs(fc(length(x)), u, x0));
else
    for i = 1 : length(x)-1
        if (x0 >= x(i) & x0 < x(i+1))
        rtn = double(subs(fc(i), u, x0));
        end
    end
end
end
%x = [0,1,2,3,4,5,6,7,8,9,10]
%y = [731,782,833,886,956,1049,1159,1267,1367,1436,1505]
%cubic_spline_extra(x, y, -5)