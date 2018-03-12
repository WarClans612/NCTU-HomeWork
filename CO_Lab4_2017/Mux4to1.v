//Student ID: 0416106
//Name: Wilbert
module Mux4to1( data0_i, data1_i, data2_i, data3_i, select_i, data_o );

parameter size = 0;			   
			
//I/O ports               
input wire	[size-1:0] data0_i;          
input wire	[size-1:0] data1_i;
input wire	[size-1:0] data2_i;
input wire	[size-1:0] data3_i;
input wire	[2-1:0] select_i;
output wire	[size-1:0] data_o; 

//Main function
/*your code here*/
  assign data_o = (select_i == 2'b00) ? data0_i : (select_i == 2'b01) ? data1_i : (select_i == 2'b10) ? data2_i : (select_i == 2'b11) ? data3_i : 0;

endmodule  
