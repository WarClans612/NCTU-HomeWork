aaaaaa;

fibonacci_recursive(n:integer):integer;
begin
	if n = 0 then
		return 0;
	end if
	if n = 1 then
		return 1;
	end if
	return fibonacci_recursive(n-1) + fibonacci_recursive(n-2);
end

begin
    print fibonacci_recursive(20);
end
end aaaaaa
