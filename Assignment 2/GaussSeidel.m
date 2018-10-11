function x = GaussSeidel(A, b, x)
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
LDSuminv = (L + D)^-1;
LDSuminvb = (L + D)^-1*b;
LDSum = L + D;

q = 0;
tol = 0.0000001;

while(q == 0)
    y = -LDSuminv * U * x + LDSuminvb;
    if(norm(y-x) > tol)
        x = y;
    else
        q = 1;
    end
end

%GaussSeidel([2, -1.99; -1.99, 2], [0; 0], [1; 1])
%GaussSeidel([2, -1.99; -1.99, 2], [0; 0], [1; -1])
%GaussSeidel([2, -1.99; -1.99, 2], [0; 0], [-1; 1])
%GaussSeidel([2, -1.99; -1.99, 2], [0; 0], [2; 5])