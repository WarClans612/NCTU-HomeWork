function rtn = least_square_quadratic(x, y, x0)

X = [ones(size(x')) x' x'.^2];
B = (X'*X)\(X'*y');

syms x;
line = [1; x; x^2];
f = B'*line;

rtn = double(subs(f, x, x0));

%x = [0,1,2,3,4,5,6,7,8,9,10]
%y = [731,782,833,886,956,1049,1159,1267,1367,1436,1505]
%least_square_quadratic(x, y, -5)