function A=Cholesky(A)
% Cholesky Factorization for symmetric positive definite matrix
% Factorize A such that A = L*L',
% Answer of L is returned in A

[n nn]=size(A);
for k=1:n
    A(k,k)=sqrt(A(k,k));
    A(k+1:n,k)=A(k+1:n,k)/A(k,k);
    A(1:k-1, k) = 0;
    for j=k+1:n
        A(j:n,j)=A(j:n,j)-A(j,k)*A(j:n,k);
    end
end
%Cholesky([4, 12, -16; 12, 37, -43; -16, -43, 98])