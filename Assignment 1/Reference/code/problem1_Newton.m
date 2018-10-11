y = inline('sin(x)-x.^3+1','x')
x = sym('x')
dy = inline(diff(sin(x)-x.^3+1,x),'x')
x0 = 2;
x1;
while abs(y(x0)) > 0.00001,
    x1 = x0 - y(x0)/dy(x0);
    x0 = x1;
end
sprintf('%0.7g',x0)