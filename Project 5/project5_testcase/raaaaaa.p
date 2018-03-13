
|--------------------------------------------------------------------------
| Error found in Line #14: end fib
|
| Unmatched token: fib
|--------------------------------------------------------------------------
<id: aaaaa>
<Error> found in Line 1: program ID inconsistent with file name
<;>
1: aaaaa;
2: 
<id: fib>
<(>
<id: n>
<:>
<KWinteger>
<)>
<:>
<KWinteger>
<;>
3: fib (n:integer) :integer;
<KWbegin>
4: begin
<KWif>
<id: n>
<=>
<integer: 0>
<KWthen>
5: if n = 0 then
<KWreturn>
<integer: 0>
<;>
6: return 0;
<KWend>
<KWif>
7: end if
8: 
<KWif>
<id: n>
<=>
<integer: 1>
<KWthen>
9: if n = 1 then 
<KWreturn>
<integer: 1>
<;>
10: return 1;
<KWend>
<KWif>
11: end if
12: 
<KWreturn>
<id: fib>
<(>
<id: n>
<->
<integer: 1>
<)>
<Error> found in Line 13: function fib is not declared
<+>
<id: fib>
<(>
<id: n>
<->
<integer: 2>
<)>
<Error> found in Line 13: function fib is not declared
<;>
13: return fib(n-1) + fib(n-2);
<KWend>
==============================================================================================================
Name                             Kind       Level      Type             Attribute  
--------------------------------------------------------------------------------------------------------------
n                                parameter  1(local)   integer          
--------------------------------------------------------------------------------------------------------------
<id: fib>
