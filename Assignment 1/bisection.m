function m = bisection( f, a, b )
%f represents function
%a and b represent boundaries

f = inline(f);
if f(a)*f(b) > 0
    disp('Wrong boundaries')
else
    tolerance = 1e-5;
    while abs( b - a ) > tolerance,
        m = (b+a)/2;
        if f(a)*f(m) < 0,
            b = m;
        else
            a = m;
        end;
    end;
end;
%fprintf('%f\n', bisection ('2*sin(x)-(exp(x)/4) -1', -7, -5))
%fprintf('%f\n', bisection ('2*sin(x)-(exp(x)/4) -1', -5, -3))