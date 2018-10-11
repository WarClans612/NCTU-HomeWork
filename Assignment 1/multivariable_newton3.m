function v0 = multivariable_newton3( f, v0 )
%f represents function
%v0 represents initial vector

x = sym('x');
y = sym('y');
z = sym('z');
f = inline(f, 'p');
F = f([x, y, z]);
J = jacobian(F);
invJ = inv(J);

tolerance = 1e-5;
dsnorm = inf;
while dsnorm > tolerance,
    ds = -1 * subs(invJ, [x y z], v0) * f(v0);
    v1 = v0 + ds';
    dsnorm = norm(v1-v0, 2);
    v0 = v1;
end;
%double(multivariable_newton3('[p(:,1)-3*p(:,2)-p(:,3).^2+3; 2*p(:,1).^3+p(:,2)-5*p(:,3).^2+2; 4*p(:,1).^2+p(:,2)+p(:,3)-7]', [1 1 1]))
%double(multivariable_newton3('[p(:,1)-3*p(:,2)-p(:,3).^2+3; 2*p(:,1).^3+p(:,2)-5*p(:,3).^2+2; 4*p(:,1).^2+p(:,2)+p(:,3)-7]', [1.3 0.9 -1.2]))