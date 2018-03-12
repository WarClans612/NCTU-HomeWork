module MEM_WB_register(clk_i, rst_n, enable_i,
		write_reg_i, last_data_i, mem_to_reg_i, regWrite_i, memory_data_i,
		write_reg_o, last_data_o, mem_to_reg_o, regWrite_o, memory_data_o);

input		clk_i;
input		rst_n;

input				enable_i;
input	[5-1:0]		write_reg_i;
input	[32-1:0]	last_data_i, memory_data_i;
input				mem_to_reg_i, regWrite_i;

output reg	[5-1:0]		write_reg_o;
output reg	[32-1:0]	last_data_o, memory_data_o;
output reg				mem_to_reg_o, regWrite_o;


always@ (posedge clk_i or negedge rst_n) begin
	if(~rst_n | ~enable_i) begin
	write_reg_o			<= 0;
	last_data_o			<= 0;
	mem_to_reg_o		<= 0;
	regWrite_o			<= 0;
	memory_data_o		<= 0;
	end
	else begin
	write_reg_o			<= write_reg_i	;
	last_data_o			<= last_data_i	;
	mem_to_reg_o		<= mem_to_reg_i	;
	regWrite_o			<= regWrite_i	;
	memory_data_o		<= memory_data_i;
	end
end











endmodule
