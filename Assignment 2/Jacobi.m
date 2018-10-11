function x = Jacobi(A, b, x)
%calculate jacobi iteration
%b is column vector
%x is initial vector

format long;
sz = size(A);
n = sz(1);
D = eye(n);
for i = 1:n
    D(i, i) = A(i, i);
end

L = zeros(n);
for i = 1:n
    for j = 1:i
        if (i > j)
            L(i, j) = A(i, j);
        end
    end
end

U = A - D - L;
Dinv = D^-1;
Dinvb = D^-1*b;
LUSum = L + U;

q = 0;
tol = 0.0000001;

while(q == 0)
    y = -Dinv * LUSum * x + Dinvb;
    if(norm(y-x) > tol)
        x = y;
    else
        q = 1;
    end
end

%Jacobi([2, -1.99; -1.99, 2], [0; 0], [1; 1])
%Jacobi([2, -1.99; -1.99, 2], [0; 0], [1; -1])
%Jacobi([2, -1.99; -1.99, 2], [0; 0], [-1; 1])
%Jacobi([2, -1.99; -1.99, 2], [0; 0], [2; 5])