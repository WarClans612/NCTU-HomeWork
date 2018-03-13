guess;
var g: 107;
begin
var i: integer;
i:= 0;
while i <> g do
  print "please guess the number: ";
  read i;
  if i > g then
    print i;
    print " is greater than the magic number\n";
  else
    print i;
    print " is smaller than the magic number\n";
  end if
end do
print "bingo!! the magic number is ";
print g;
end
end guess
