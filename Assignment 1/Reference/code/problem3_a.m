g1 = inline('x.^2-2','x');
x = sym('x');
dg1 = inline(diff(x^2-2,x),'x');
dg1(2)

g2 = inline('(x+2)^(1/2)','x');
dg2 = inline(diff((x+2)^(1/2),x),'x');
dg2(2)

g3 = inline('2/x.+1','x');
dg3 = inline(diff(2/x+1,x),'x');
dg3(2)

g4 = inline('(x.^2+2)/(2*x.-1)','x');
dg4 = inline(diff((x^2+2)/(2*x-1),x),'x');
dg4(2)