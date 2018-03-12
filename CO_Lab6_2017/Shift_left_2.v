//Student ID: 0416106
//Name: Wilbert
module Shift_left_2(in, out );
    
parameter size = 0;
 
//I/O ports
input	[size-1:0]	in;
output	[size-1:0]	out;

assign out = in << 2;

 
endmodule
