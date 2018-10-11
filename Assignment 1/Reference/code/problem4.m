x1 = 0;
x2 = 1;
counter = 0;
X_cur = [x1 x2]';
X_pre = [100 100]';
f = [x1^2-x2^2;2*x1*x2-1];
J = [2*x1 -2*x2;2*x2 2*x1];

while abs(X_cur(1,1)-X_pre(1,1)) > 0.00001,
    X_pre = X_cur;
    x1 = X_cur(1,1);
    x2 = X_cur(2,1);
    f = [x1^2-x2^2;2*x1*x2-1];
    J = [2*x1 -2*x2;2*x2 2*x1];
    s = J\(-f);
    X_cur = X_pre + s;
    counter=counter+1;
    sprintf('%0.6g ',X_cur)
end
counter
