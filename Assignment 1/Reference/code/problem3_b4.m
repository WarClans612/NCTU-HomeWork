g4 = inline('(x.^2+2)/(2*x-1)','x');

x0 = 3;
x1 = 2;
R = 2;
e = x0-R;
pe = e;
while(abs(x0-R) > 0.00001),
   x1 = g4(x0);
   x0 = x1;
   e = x0 - R;
   if(e == inf),
       sprintf('diverge!!')
       break;
   end
   e/(pe^2) %I've already tried r=1, and it seems not to be the linear convegence by result observation
   pe = e;
end