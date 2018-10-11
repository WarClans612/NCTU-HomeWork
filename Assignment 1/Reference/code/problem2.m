P = inline('(x-2).^3.*(x-4).^2','x')
x = sym('x');
dP = inline(diff((x-2).^3.*(x-4).^2, x),'x')
%ddP = inline(diff(diff((x-2).^3.*(x-4).^2, x)),'x')

x0 = 3;
x1 = 0;
while dP(x0) > 0.00001,
    x1 = x0 - P(x0)/dP(x0);
    x0 = x1;
end

x0
