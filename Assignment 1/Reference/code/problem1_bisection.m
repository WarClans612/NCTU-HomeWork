y = inline('sin(x)-x.^3+1','x')
a = -2;
b = 2;
m = 0;
while abs(b-a) > 0.00001,
   if y(a) == 0,
       break;
   end
   m = (a+b)/2;
   if y(a)*y(m) < 0,
       b = m;
   else 
       a = m;
   end
end

sprintf('%0.7g',m)