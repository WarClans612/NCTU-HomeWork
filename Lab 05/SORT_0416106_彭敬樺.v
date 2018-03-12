module SORT(
  // Input signals
  clk,
  rst_n,
  in_valid1,
  in_valid2,
  in,
  mode,
  op,
  // Output signals
  out_valid,
  out
);
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION 
input [4:0] in;
input [1:0] op;
input       mode;
input       in_valid1;
input       in_valid2;
input       clk;
input       rst_n;

output reg [4:0] out;
output reg       out_valid;
//---------------------------------------------------------------------

//---------------------------------------------------------------------
// PARAMETER DECLARATION
parameter SIZE = 10;
parameter IDLE = 0;
parameter MODE = 1;
parameter INPUT = 2;
parameter OUTPUT = 3;
//---------------------------------------------------------------------

//---------------------------------------------------------------------
//   WIRE AND REG DECLARATION
integer i, j;
reg [4:0] ans;
reg [1:0] current_state, next_state;
reg [4:0] array [0:SIZE-1];
reg [4:0] out_count;             
reg [3:0] position;
reg       modes;   
//---------------------------------------------------------------------

//---------------------------------------------------------------------
//   Finite-State Machine

//Managing next_state
always@(*)
begin
	case(current_state)
		IDLE: next_state <= MODE;
		MODE: if(in_valid2) next_state <= INPUT;
			else next_state <= MODE;
		INPUT: if(in_valid1 && op == 2) next_state <= OUTPUT;
				else next_state <= INPUT;
		OUTPUT: if(out_count == 2*SIZE-1) next_state <= IDLE;
				else next_state <= OUTPUT;
		default: next_state <= IDLE;
	endcase
end

//Managing current_state
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) current_state <= IDLE;
	else current_state <= next_state;
end                      
//---------------------------------------------------------------------

//---------------------------------------------------------------------
//   Design Description

//Managing out_count
always@(posedge clk)
begin
	if(current_state == OUTPUT) out_count <= out_count + 1;
	else out_count <= 0;
end

//Managing modes
always@(posedge clk)
begin
	if(current_state == MODE && in_valid2) modes <= mode;
	else modes <= modes;
end

//Managing out_valid
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) out_valid <= 0;
	else if(out_count == 2*SIZE-1) out_valid <= 0;
	else if(out_count > SIZE-2) out_valid <= 1;
	else out_valid <= 0;
end

//Managing output
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) out <= 0;
	else if(current_state == IDLE) out <= 0;
	else if(out_count > SIZE-2) begin
		out <= array[out_count-SIZE+1];
	end
	else out <= out;
end

//Managing position
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) position <= 0;
	else if(current_state == IDLE) position <= 0;
	else if(in_valid1 && op) position <= position + 1;
	else if(in_valid1 && !op) position <= position - 1;
	else position <= position;
end

//Managing array
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) for(i = 0; i < SIZE; i = i + 1) array[i] <= 0;
	else if(current_state == IDLE) begin
		for(i = 0; i < SIZE; i = i + 1) array[i] <= 0;
	end
	else if(in_valid1 && current_state == INPUT) begin
		//Queue
		if(modes) begin
			case(op)
				//Push
				1: array[position] <= in;
				//Pop
				0: begin
					for(i = 0; i < SIZE-1; i = i + 1) array[i] <= array[i+1];
					array[SIZE-1] <= 0;
				end
				default: for(i = 0; i < SIZE; i = i + 1) array[i] <= array[i];
			endcase
		end
		//Stack
		else begin
			case(op)
				//Push
				1: array[position] <= in;
				//Pop
				0: array[position - 1] <= 0;
				default: for(i = 0; i < SIZE; i = i + 1) array[i] <= array[i];
			endcase
		end
	end
	else if(next_state == OUTPUT && out_count < SIZE)
		case(out_count%2)
		0:for(i = 0; i < SIZE-1; i = i + 2) begin
			if(array[i] < array[i+1]) begin
				array[i] <= array[i+1];
				array[i+1] <= array[i];
			end
		end
		1:for(i = 1; i < SIZE-1; i = i + 2) begin
			if(array[i] < array[i+1]) begin
				array[i] <= array[i+1];
				array[i+1] <= array[i];
			end
		end
		endcase
	else begin
		for(i = 0; i < SIZE; i = i + 1) array[i] <= array[i];
	end
end

//---------------------------------------------------------------------

endmodule
