function rtn = lagrange(X, F, x0)
%given a vector list of x-values and a vector
%list of y-values, the lagrangian interpolation of
%x0 is calculated

n = length(X);
coeffmatrix = zeros(1, n);
f = 0;

for i = 1 : n
    P = 1; coeff = 1;
    for j = 1 : n
        if (j~=i)
            P = P*(x0-X(j))/(X(i)-X(j));
            coeff = coeff/(X(i)-X(j));
        end
    end
    f = f + P * F(i);
    coeffmatrix(i) = coeff*F(i);
end

%output
f

%x = [0,1,2,3,4,5,6,7,8,9,10]
%y = [731,782,833,886,956,1049,1159,1267,1367,1436,1505]
%lagrange(x, y, -5)