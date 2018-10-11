function rtn=trapezoidal_rule()
    f=@(x)x^-2;
    a=0.2; b=1;

    tolerance = 0.02;
    before = 0;
    after = before+tolerance+1;
    N = 2;
    iteration = 0;

    while (abs(after-before) > tolerance)
        h = (b-a)/N;
        It=0;
        for k=1:(N-1)
            x=a+h*k;
            It=It+feval(f,x);
        end
        It=h*(f(a)+f(b))/2+h*It;
        before = after;
        after = It;
        N = N * 2;
        iteration = iteration + 1;
    end
iteration
h

%trapezoidal_rule()
end