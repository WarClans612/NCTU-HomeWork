function rtn = bspline_plot(points)

for i = 1 : length(points)-3
    G = [points(:,i) points(:,i+1) points(:,i+2) points(:,i+3)];
    M = [1 -3 3 -1;4 0 -6 3;1 3 3 -3;0 0 0 1]/6;

    % Create the parameter t and the vector u that contains the powers of t.
    t = linspace(0,1);	
    u = [t.^0; t; t.^2; t.^3];
    x = G*M*u;				% The B-spline curve
    hold on            
    plot(G(1,:),G(2,:),'-ob','MarkerFaceColor','b','MarkerSize',2)

    % Plot the B-spline curve in red. 
    plot(x(1,:),x(2,:),'r')
end
% points = [[0;0] [0;0] [1;0.3] [2;1.7] [3;1.5] [3;1.5]]
% bspline_plot(points)