function r = my_bisection(f, a, b, tol)
X = a:0.01:b;
Y = f(X);
plot(X, Y);
hold on;
grid;
if(f(a)*f(b)>0), 
    error('root is not bracketed in the initial interval');
end;
ha=text(a,0,'a');
hb=text(b,0,'b');
while(abs(a-b)>tol & f(a)*f(b) ~= 0),
    m=(a+b)/2;
    hm=text(m,0,'m');
    [a, m, b]
    pause;
    if(f(a)*f(m) < 0),
        b = m;
        delete(hb);
        delete(hm);
        hb=text(b,0,'b');
    elseif(f(b)*f(m) < 0),
        a = m;
        delete(ha);
        delete(hm);
        ha=text(a,0,'a');        
    else
        break;
    end;
end;
r = m;
delete(hm);
text(r,0,'x');
disp(sprintf('root = %f', r));
hold off;