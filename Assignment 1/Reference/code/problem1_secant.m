y = inline('sin(x)-x.^3+1','x')
x0 = 1;
x1 = 1.5;
x2 = 0;
while y(x2) > 0.00001,
   x2 = x1 - y(x1)*(x0-x1)/(y(x0)-y(x1))
   if y(x0)*y(x2) < 0,
       x1 = x2;
   else
       x0 = x2;
   end
end

sprintf('%0.7g',x2)

