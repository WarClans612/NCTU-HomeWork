module IMPOR(
	output  reg [2:0] out,
	output  reg out_valid,
	output  reg ready,
	input  [2:0] in,
	input  [2:0] mode,
	input  in_valid,
	input  clk,
	input  rst_n
);

//-----------------------------------------
//Declaring reg and wire

parameter IDLE=0, INPUT=1, CALC=2, OUTPUT=3;
reg [3:0] count;
reg [1:0] current_state, next_state;
reg [2:0] in1, in2, in3, in4, in5, in6, in7, in8, in9;

//-----------------------------------------


//-----------------------------------------
//My code

//Changing current state every clock
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) current_state <= IDLE;
	else current_state <= next_state;
end

//Changing next state
always@(*)
begin
	case (current_state)
		IDLE: if(in_valid) next_state <= INPUT;
			else next_state <= IDLE;
		INPUT: if(!in_valid) next_state <= CALC;
			else next_state <= INPUT;
		CALC: if(mode==0) next_state <= OUTPUT;
			else next_state <= CALC;
		OUTPUT: if(count == 9) next_state <= IDLE;
			else next_state <= OUTPUT;
		default: next_state <= IDLE;
	endcase
end

//Managing input and calculation depends on mode and state
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) in1 <= 0;
	else if(next_state == INPUT && in_valid && count == 0) in1 <= in;
	else if(current_state == CALC) case(mode)
		1: in1 <= in3;
		2: in1 <= in7;
		3: in1 <= in3;
		4: in1 <= in7;
		5: case(in1)
			7: in1 <= in1;
			default: in1 <= in1 + 1;
			endcase
		default: in1 <= in1;
		endcase
	else in1 <= in1;
end
always@(posedge clk or negedge rst_n)
begin
        if(!rst_n) in2 <= 0;
        else if(current_state == INPUT && in_valid && count == 1) in2 <= in;
	else if(current_state == CALC) case(mode)
		2: in2 <= in8;
		3: in2 <= in6;
		4: in2 <= in4;
		6: case(in2)
			7: in2 <= in2;
			default: in2 <= in2 + 1;
			endcase
		default: in2 <= in2;
		endcase
        else in2 <= in2;
end
always@(posedge clk or negedge rst_n)
begin
        if(!rst_n) in3 <= 0;
        else if(current_state == INPUT && in_valid && count == 2) in3 <= in;
        else if(current_state == CALC) case(mode)
		1: in3 <= in1;
		2: in3 <= in9;
		3: in3 <= in9;
		4: in3 <= in1;
		7: case(in3)
			7: in3 <= in3;
			default: in3 <= in3 + 1;
			endcase
		default: in3 <= in3;
		endcase
	else in3 <= in3;
end
always@(posedge clk or negedge rst_n)
begin
        if(!rst_n) in4 <= 0;
        else if(current_state == INPUT && in_valid && count == 3) in4 <= in;
	else if(current_state == CALC) case(mode)
		1: in4 <= in6;
		3: in4 <= in2;
		4: in4 <= in8;
		5: case(in4)
			7: in4 <= in4;
			default: in4 <= in4 + 1;
			endcase
		default: in4 <= in4;
		endcase
        else in4 <= in4;
end
always@(posedge clk or negedge rst_n)
begin
        if(!rst_n) in5 <= 0;
        else if(current_state == INPUT && in_valid && count == 4) in5 <= in;
	else if(current_state == CALC) case(mode)
		6: case(in5)
			7: in5 <= in5;
			default: in5 <= in5 + 1;
			endcase
		default: in5 <= in5;
		endcase
        else in5 <= in5;
end
always@(posedge clk or negedge rst_n)
begin
        if(!rst_n) in6 <= 0;
        else if(current_state == INPUT && in_valid && count == 5) in6 <= in;
	else if(current_state == CALC) case(mode)
		1: in6 <= in4;
		3: in6 <= in8;
		4: in6 <= in2;
		7: case(in6)
			7: in6 <= in6;
			default: in6 <= in6 + 1;
			endcase
		default: in6 <= in6;
		endcase
        else in6 <= in6;
end
always@(posedge clk or negedge rst_n)
begin
        if(!rst_n) in7 <= 0;
        else if(current_state == INPUT && in_valid && count == 6) in7 <= in;
	else if(current_state == CALC) case(mode)
		1: in7 <= in9;
		2: in7 <= in1;
		3: in7 <= in1;
		4: in7 <= in9;
		5: case(in7)
			7: in7 <= in7;
			default: in7 <= in7 + 1;
			endcase
		default: in7 <= in7;
		endcase
        else in7 <= in7;
end
always@(posedge clk or negedge rst_n)
begin
        if(!rst_n) in8 <= 0;
        else if(current_state == INPUT && in_valid && count == 7) in8 <= in;
	else if(current_state == CALC) case(mode)
		2: in8 <= in2;
		3: in8 <= in4;
		4: in8 <= in6;
		6: case(in8)
			7: in8 <= in8;
			default: in8 <= in8 + 1;
			endcase
		default: in8 <= in8;
		endcase
        else in8 <= in8;
end
always@(posedge clk or negedge rst_n)
begin
        if(!rst_n) in9 <= 0;
        else if(current_state == INPUT && in_valid && count == 8) in9 <= in;
	else if(current_state == CALC) case(mode)
		1: in9 <= in7;
		2: in9 <= in3;
		3: in9 <= in7;
		4: in9 <= in3;
		7: case(in9)
			7: in9 <= in9;
			default: in9 <= in9 + 1;
			endcase
		default: in9 <= in9;
		endcase
        else in9 <= in9;
end

//Managing count
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) count <= 0;
	else if(next_state == INPUT && in_valid) count <= count + 1;
	else if(current_state == CALC) count <= 0;
	else if(current_state == OUTPUT) count <= count + 1;
	else count <= 0;
end

//Managing out valid
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) out_valid <= 0;
	else if(count >= 9) out_valid <= 0;
	else if(current_state == OUTPUT) out_valid <= 1;
	else out_valid <= out_valid;
end

//Managing output
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) out <= 0;
	else if(current_state == OUTPUT)
		case (count)
		0: out <= in1;
		1: out <= in2;
		2: out <= in3;
		3: out <= in4;
		4: out <= in5;
		5: out <= in6;
		6: out <= in7;
		7: out <= in8;
		8: out <= in9;
		default: out <= 0;
		endcase
	else out <= out;
end

//Managin ready
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) ready <= 0;
	else if(current_state == IDLE && next_state == IDLE) ready <= 1;
	else if(next_state == CALC) ready <= 1;
	else ready <= 0;
end

//-----------------------------------------

endmodule
