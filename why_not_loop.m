clear;
N = 1e5;
a = 1:1:N;
t1=tic;
a*a'
t2=tic;
disp(sprintf('elapsed time = %d', t2-t1));
t3=tic;
for i=1:N,
    b(i)=a(i)*a(i);
end;
t4=tic;
disp(sprintf('elapsed time = %d', t4-t3));
