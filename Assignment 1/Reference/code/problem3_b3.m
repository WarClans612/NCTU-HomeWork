g3 = inline('2/x+1','x');

x0 = 3;
x1 = 2;
R = 2;
e = x0-R;
pe = e;
while(abs(x0-R) > 0.00001),
   x1 = g3(x0);
   x0 = x1;
   e = x0 - R;
   if(e == inf),
       sprintf('diverge!!')
       break;
   end
   e/pe
   pe = e;
end