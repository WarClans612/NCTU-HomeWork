function m = newton( f, a )
%f represents function
%a represents point

x = sym('x');
g = inline(diff(f, x));
f = inline(f);

tolerance = 1e-5;
while abs( f(a) ) > tolerance,
    b = a - f(a) / g(a);
    a = b;
end;
m = a;
%fprintf('%f\n', newton ('2*sin(x)-(exp(x)/4) -1', -7))
%fprintf('%f\n', newton ('2*sin(x)-(exp(x)/4) -1', -3))