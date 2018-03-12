module ALU( OUT, A, B, MODE); 
	output reg [7:0] OUT;
	input [3:0] A, B;
	input [1:0] MODE;

always@ (*)
	begin
	 if( MODE == 2'b00 ) OUT = A + B;
	 else if ( MODE == 2'b01 ) OUT = A & B;
	 else if ( MODE == 2'b10 )
		if( A > B ) OUT = 1;
		else OUT = 0;
	 else OUT = A >> B;

	end

endmodule
