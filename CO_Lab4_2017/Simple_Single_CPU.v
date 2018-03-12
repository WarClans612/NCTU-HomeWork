//Student ID: 0416106
//Name: Wilbert
module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire	[32-1:0]	pc_in, pc_out, instr, write_data, data1, data2, const_signex, const_zeroex,
			alu_data2, mux_data1, mux_data2, next_pc, jmp_addr, constant_addr_shift_o, branch_rslt,
			temp_next_addr, last_data_o, memory_data, selected_data_write, jmp_loc;
wire			regWrite, zero, overflow, PCSrc, jump, branch, mem_to_reg, mwrite, mread, 
				branch_to_PCSrc, temp_jump, RegFile_data, jump_jr_selector ;
wire	[5-1:0]		write_reg, shamt_v;
wire	[3-1:0]		alucontrol;
wire	[4-1:0]		alu_operation;
wire	[2-1:0]		last_mux, regDst, alusrc, branch_type;


//modules
Program_Counter PC(
        .clk_i(clk_i),      
	.rst_n(rst_n),     
	.pc_in_i(pc_in) ,   
	.pc_out_o(pc_out) 
	);
	
Adder pc_first_adder(
	.src1_i(pc_out),     
	.src2_i(32'd4),
	.sum_o(next_pc)    
	);
		
Jump_address jump_shift_preparation(
	.instruction(instr[25:0]),
	.pc(next_pc[31:28]),
	.out(jmp_addr)
	);

//Mux selector for jump or jr decision
assign jump_jr_selector = (instr[31:26] == 6'b000000 && instr[5:0] == 6'b001000) ? 1 : 0;

Mux2to1 #(.size(32)) jr_jump_selector(
	.data0_i(jmp_addr),
	.data1_i(data1),
	.select_i(jump_jr_selector),
	.data_o(jmp_loc)
	);
		
Shift_left_2 #(.size(32)) constant_addr_shift(
	.in(const_signex),
	.out(constant_addr_shift_o)
	);
		
Adder branch_addr(
	.src1_i(next_pc),
	.src2_i(constant_addr_shift_o),
	.sum_o(branch_rslt)
	);

Mux2to1 #(.size(32)) branch_decision(
	.data0_i(next_pc),
	.data1_i(branch_rslt),
	.select_i(PCSrc),
	.data_o(temp_next_addr)
	);
		
//Maintaining jump for jr function
assign jump = (temp_jump || (instr[31:26] == 6'b000000 && instr[5:0] == 6'b001000)) ? 1 : 0;

Mux2to1 #(.size(32)) jump_desicion(
	.data0_i(temp_next_addr),
	.data1_i(jmp_loc),
	.select_i(jump),
	.data_o(pc_in)
	);
		
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	.instr_o(instr)    
	);

Mux3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
		.data2_i(5'b11111),
        .select_i(regDst),
        .data_o(write_reg)
        );	
	
Mux2to1 #(.size(32)) RegFile_data_selector(
		.data0_i(write_data),
		.data1_i(next_pc),
		.select_i(RegFile_data),
		.data_o(selected_data_write)
		);
		
Reg_File RF(
        .clk_i(clk_i),      
	.rst_n(rst_n) ,     
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(write_reg) ,  
        .RDdata_i(selected_data_write)  , 
        .RegWrite_i(regWrite),
        .RSdata_o(data1) ,  
        .RTdata_o(data2)   
        );
	
Decoder Decoder(
        .instr_op_i(instr[31:26]),
	.jump_o(temp_jump),
	.ALUOp_o(alucontrol),
	.ALUSrc_o(alusrc),
	.branch_o(branch),
	.branch_type_o(branch_type),
	.memwrite_o (mwrite),
	.memread_o (mread),
	.mem_to_reg_o(mem_to_reg),
	.RegWrite_o(regWrite),  
	.RegDst_o(regDst),
	.RegFile_data_o(RegFile_data)
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
		
Mux3to1 #(.size(32)) ALU_src2Src(
        .data0_i(data2),
        .data1_i(const_signex),
		.data2_i(32'd0),
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
		
Mux4to1 #(.size(1)) branch_types(
	.data0_i(zero),
	.data1_i(~zero),
	.data2_i(~mux_data1[0]),
	.data3_i(mux_data1[0]),
	.select_i(branch_type),
	.data_o(branch_to_PCSrc)
	);
		
and (PCSrc, branch, branch_to_PCSrc);
	
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
        .data_o(last_data_o)
        );		

Data_Memory DM(
	.clk_i(clk_i),
	.addr_i(last_data_o),
	.data_i(data2),
	.MemRead_i(mread),
	.MemWrite_i(mwrite),
	.data_o(memory_data)
	);
		
Mux2to1 #(.size(32)) data_reading(
        .data0_i(last_data_o),
        .data1_i(memory_data),
        .select_i(mem_to_reg),
        .data_o(write_data)
        );	

endmodule



