function b = fixed_point( f, a )
%f represents function
%a represents initial point

f = inline(f);
i = 1;
tolerance = 1e-5;
b = a + tolerance * 2;
while abs( b - a ) > tolerance,
    b = a;
    a = f(a);
end;
%fprintf('%f\n', fixed_point('sqrt(exp(x)/2)', 1.5))
%fprintf('%f\n', fixed_point('-1*sqrt(exp(x)/2)', -0.5))
%fprintf('%f\n', fixed_point('sqrt(exp(x)/2)', 2.5))
%fprintf('%f\n', fixed_point('sqrt(exp(x)/2)', 2.7))
%fprintf('%f\n', fixed_point('log(2*x^2)', 2.6))