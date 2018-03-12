module ALU( OUT, A, B, MODE);
	output wire [7:0] OUT;
	input [3:0] A, B;
	input [1:0] MODE;

assign OUT = (MODE == 2'b00)? (A+B) : (MODE == 2'b01)? (A&B) : (MODE == 2'b10)? (A>B)? 1:0 : A>>B;


endmodule
