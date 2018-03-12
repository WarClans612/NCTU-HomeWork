module IF_ID_register(clk_i, rst_n, flush_i, update_i, enable_o, next_pc_i, instruction_i, next_pc_o, instruction_o);

input		clk_i;
input		rst_n;
input		flush_i;
input		update_i;
input		[32-1:0]	next_pc_i, instruction_i;
output reg				enable_o;
output reg	[32-1:0]	next_pc_o, instruction_o;

always@ (posedge clk_i or negedge rst_n) begin
	if(~rst_n | ~flush_i) begin
	next_pc_o <= 0;
	instruction_o <= 0;
	enable_o <= 0;
	end
	else if(update_i) begin
	next_pc_o <= next_pc_i;
	instruction_o <= instruction_i;
	enable_o <= 1;
	end
end

endmodule

