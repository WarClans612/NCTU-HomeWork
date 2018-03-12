module Online_test1(
  // Input signals
  clk,
  rst_n,
  in_valid,
  in,
  mode,
  // Output signals
  out_valid,
  out
);
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION
input       clk;
input       rst_n;
input       in_valid;
input [3:0] in;
input [1:0] mode;
output reg        out_valid;
output reg [10:0] out;                         
//---------------------------------------------------------------------

//---------------------------------------------------------------------
// PARAMETER DECLARATION
parameter IDLE = 0, INPUT = 1, MODE = 2, OUTPUT = 3;
//---------------------------------------------------------------------

//---------------------------------------------------------------------
//   WIRE AND REG DECLARATION
reg [10:0] ans1, ans2, ans3;
reg [1:0] modes;
reg [4:0] count1, count2, count3, count4, count5, count6, count7, count8, count9;
reg [1:0] current_state, next_state;                     
//---------------------------------------------------------------------

//---------------------------------------------------------------------
//   Finite-State Mechine
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) current_state <= IDLE;
	else current_state <= next_state;
end

always@(*)
begin
	case(current_state)
	IDLE: next_state <= INPUT;
	INPUT: if(in_valid && in == 0) next_state <= MODE;
		else next_state <= INPUT;
	MODE: next_state <= OUTPUT;
	OUTPUT: next_state <= IDLE;
	default: next_state <= IDLE;
	endcase
end

//---------------------------------------------------------------------
         
//---------------------------------------------------------------------
//   Design Description                                          
//---------------------------------------------------------------------
//Increasing count
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) count1 <= 0;
	else if(current_state == IDLE) count1 <= 0;
	else if(in_valid) begin
		case(in)
		1: count1 <= count1 + 1;
		default: count1 <= count1;
		endcase
		end
	else count1 <= count1;
end
always@(posedge clk or negedge rst_n)
begin
        if(!rst_n) count2 <= 0;
	else if(current_state == IDLE) count2 <= 0;
        else if(in_valid) begin
                case(in)
                2: count2 <= count2 + 1;
                default: count2 <= count2;
                endcase
		end
        else count2 <= count2;
end
always@(posedge clk or negedge rst_n)
begin
        if(!rst_n) count3 <= 0;
	else if(current_state == IDLE) count3 <= 0;
        else if(in_valid) begin
                case(in)
                3: count3 <= count3 + 1;
                default: count3 <= count3;
                endcase
		end
        else count3 <= count3;
end
always@(posedge clk or negedge rst_n)
begin
        if(!rst_n) count4 <= 0;
	else if(current_state == IDLE) count4 <= 0;
        else if(in_valid) begin
                case(in)
                4: count4 <= count4 + 1;
                default: count4 <= count4;
                endcase
		end
        else count4 <= count4;
end
always@(posedge clk or negedge rst_n)
begin
        if(!rst_n) count5 <= 0;
	else if(current_state == IDLE) count5 <= 0;
        else if(in_valid) begin
                case(in)
                5: count5 <= count5 + 1;
                default: count5 <= count5;
                endcase
		end
        else count5 <= count5;
end
always@(posedge clk or negedge rst_n)
begin
        if(!rst_n) count6 <= 0;
	else if(current_state == IDLE) count6 <= 0;
        else if(in_valid) begin
                case(in)
                6: count6 <= count6 + 1;
                default: count6 <= count6;
                endcase
		end
        else count6 <= count6;
end
always@(posedge clk or negedge rst_n)
begin
        if(!rst_n) count7 <= 0;
	else if(current_state == IDLE) count7 <= 0;
        else if(in_valid) begin
                case(in)
                7: count7 <= count7 + 1;
                default: count7 <= count7;
                endcase
		end
        else count7 <= count7;
end
always@(posedge clk or negedge rst_n)
begin
        if(!rst_n) count8 <= 0;
	else if(current_state == IDLE) count8 <= 0;
        else if(in_valid) begin
                case(in)
                8: count8 <= count8 + 1;
                default: count8 <= count8;
                endcase
		end
        else count8 <= count8;
end
always@(posedge clk or negedge rst_n)
begin
        if(!rst_n) count9 <= 0;
	else if(current_state == IDLE) count9 <= 0;
        else if(in_valid) begin
                case(in)
                9: count9 <= count9 + 1;
                default: count9 <= count9;
                endcase
		end
        else count9 <= count9;
end

//Saving mode into variable "modes"
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) modes <= 0;
	else if(current_state == MODE) modes <= mode;
	else modes <= modes;
end

//Managing out_valid
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) out_valid <= 0;
	else if(current_state == IDLE) out_valid <= 0;
	else if(current_state == OUTPUT) out_valid <= 1;
	else out_valid <= out_valid;
end

//Calculating ans1
always@(*)
begin
	if(count1 > count2 && count1 > count3 && count1 > count4 && count1 > count5 && count1 > count6 && count1 > count7 && count1 > count8 && count1 > count9) ans1 <= count1;
	else if(count2 > count3 && count2 > count4 && count2 > count5 && count2 > count6 && count2 > count7 && count2 > count8 && count2 > count9) ans1 <= count2;
	else if(count3 > count4 && count3 > count5 && count3 > count6 && count3 > count7 && count3 > count8 && count3 > count9) ans1 <= count3;
	else if(count4 > count5 && count4 > count6 && count4 > count7 && count4 > count8 && count4 > count9) ans1 <= count4;
	else if(count5 > count6 && count5 > count7 && count5 > count8 && count5 > count9) ans1 <= count5;
	else if(count6 > count7 && count6 > count8 && count6 > count9) ans1 <= count6;
	else if(count7 > count8 && count7 > count9) ans1 <= count7;
	else if(count8 > count9) ans1 <= count8;
	else ans1 <= count9;
end
//Calculating ans2
always@(*)
begin
        if(count1 < count2 && count1 < count3 && count1 < count4 && count1 < count5 && count1 < count6 && count1 < count7 && count1 < count8 && count1 < count9) ans2 <= count1;
        else if(count2 < count3 && count2 < count4 && count2 < count5 && count2 < count6 && count2 < count7 && count2 < count8 && count2 < count9) ans2 <= count2;
        else if(count3 < count4 && count3 < count5 && count3 < count6 && count3 < count7 && count3 < count8 && count3 < count9) ans2 <= count3;
        else if(count4 < count5 && count4 < count6 && count4 < count7 && count4 < count8 && count4 < count9) ans2 <= count4;
        else if(count5 < count6 && count5 < count7 && count5 < count8 && count5 < count9) ans2 <= count5;
        else if(count6 < count7 && count6 < count8 && count6 < count9) ans2 <= count6;
        else if(count7 < count8 && count7 < count9) ans2 <= count7;
        else if(count8 < count9) ans2 <= count8;
        else ans2 <= count9;
end
//Calculating ans3
always@(*)
begin
	ans3 <= count1 + 2*count2 + 3*count3 + 4*count4 + 5*count5 + 6*count6 + 7*count7 + 8*count8 + 9*count9;
end

//Managing output
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n) out <= 0;
	else if(current_state == IDLE) out <= 0;
	else if(current_state == OUTPUT)
		case(modes)
		0: out <= ans1;
		1: out <= ans2;
		2: out <= ans3;
		default: out <= 0;
		endcase
	else out <= out;
end

endmodule
