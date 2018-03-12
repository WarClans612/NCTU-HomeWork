module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire	[32-1:0]	pc_in, pc_out, instr, write_data, data1, data2, const_signex, const_zeroex,
			alu_data2, mux_data1, mux_data2;
wire			regDst, regWrite, alusrc, zero, overflow;
wire	[5-1:0]		write_reg, shamt_v;
wire	[3-1:0]		alucontrol;
wire	[4-1:0]		alu_operation;
wire	[2-1:0]		last_mux;


//modules
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(pc_in) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(
        .src1_i(pc_out),     
	    .src2_i(32'd4),
	    .sum_o(pc_in)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(instr)    
	    );

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .select_i(regDst),
        .data_o(write_reg)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(write_reg) ,  
        .RDdata_i(write_data)  , 
        .RegWrite_i(regWrite),
        .RSdata_o(data1) ,  
        .RTdata_o(data2)   
        );
	
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
	    .RegWrite_o(regWrite), 
	    .ALUOp_o(alucontrol),   
	    .ALUSrc_o(alusrc),   
	    .RegDst_o(regDst)   
		);

ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(alucontrol),   
        .ALU_operation_o(alu_operation),
		.FURslt_o(last_mux)
        );
	
Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(const_signex)
        );

Zero_Filled ZF(
        .data_i(instr[15:0]),
        .data_o(const_zeroex)
        );
		
Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(data2),
        .data1_i(const_signex),
        .select_i(alusrc),
        .data_o(alu_data2)
        );	
		
ALU ALU(
		.aluSrc1(data1),
	    .aluSrc2(alu_data2),
	    .ALU_operation_i(alu_operation),
		.result(mux_data1),
		.zero(zero),
		.overflow(overflow)
	    );
	
Mux2to1 #(.size(5)) shamt_control(
        .data0_i(instr[10:6]),
        .data1_i(data1[4:0]),
        .select_i(instr[2]),
        .data_o(shamt_v)
        );	
	
Shifter shifter( 
		.result(mux_data2), 
		.leftRight(instr[1]),
		.shamt(shamt_v),
		.sftSrc(alu_data2) 
		);
		
Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(mux_data1),
        .data1_i(mux_data2),
		.data2_i(const_zeroex),
        .select_i(last_mux),
        .data_o(write_data)
        );			

endmodule



