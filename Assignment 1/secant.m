function m = secant( f, a, b )
%f represents function
%a and b represent boundaries

f = inline(f);
tolerance = 1e-5;
while abs( b - a ) > tolerance,
    m = b - f(b) * (a - b) / (f(a) - f(b));
    a = b;
    b = m;
end;
%fprintf('%f\n', secant ('2*sin(x)-(exp(x)/4) -1', -7, -5))
%fprintf('%f\n', secant ('2*sin(x)-(exp(x)/4) -1', -5, -3))