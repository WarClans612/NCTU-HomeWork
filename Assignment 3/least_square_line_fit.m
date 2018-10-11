function rtn = least_square_line_fit()

a = 1;
b = 1;
c = 1;
px = 2+5*rand(1, 6)';
py = a*px.^2+b*px +c;
pz = py + rand/5;

A = [px px./px];
p = A\pz;
x = linspace(2, 7);
z = polyval(p, x);
hold on;
plot(px, pz, 'o');
plot(x, z);
p
end