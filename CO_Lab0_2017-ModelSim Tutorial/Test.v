`timescale 1ns / 1ps

module Test();
	reg CLK;
	reg [3:0] Counter;
	
	always #5 CLK = ~CLK;
	
	initial begin
		CLK = 0;
		Counter = 0;
	end
	
	always@(posedge CLK) begin
		if(Counter == 0)
			Counter <= Counter + 1;
		else if(Counter > 0 && Counter <= 5) begin
			$write("Cycle %d finished.\n", Counter);
			Counter <= Counter + 1;
		end
		else
			$stop;
	end
		

endmodule
