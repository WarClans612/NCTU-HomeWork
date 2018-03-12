module OT11_27(
    clk,
	rst_n,
	in,
	bomb,
	in_valid1,
	hit,
	in_valid2,
 
  out_valid,
  out

);

//Input and output declaration
input       clk;
input       rst_n;
input [7:0] in;
input [7:0] bomb;
input [5:0] hit;
input       in_valid1;
input       in_valid2;
output reg       out_valid;
output reg [6:0] out;

//Parameter declaration
parameter IDLE = 0, INPUT = 1, CALC = 2, OUTPUT = 3;

//Wire and reg declaration
integer i;
reg [6:0] destroyed;
reg [5:0] punch [0:9];
reg       brickmap[0:63];
reg       bombmap[0:63];
reg [3:0] in_count;
reg [3:0] calc_count;
reg [1:0] current_state, next_state;

//Finite state machine
//Managing next state
always@(*)
begin
    case(current_state)
        IDLE: next_state <= INPUT;
        INPUT: if(in_count == 7) next_state <= CALC;
                else next_state <= INPUT;
        CALC: if(calc_count == 9) next_state <= OUTPUT;
                else next_state <= CALC;
        OUTPUT: next_state <= IDLE;
        default: next_state <= IDLE;
    endcase
end

//Managing current state
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) current_state <= IDLE;
    else current_state <= next_state;
end

//Managing input counter
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) in_count <= 0;
    else if(current_state == IDLE) in_count <= 0;
    else if(in_valid2) in_count <= in_count + 1;
    else in_count <= 0;
end

//Managing calculation counter
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) calc_count <= 0;
    else if(current_state == IDLE) calc_count <= 0;
    else if(current_state == CALC) calc_count <= calc_count + 1;
    else calc_count <= calc_count;
end

//Managing output
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) out <= 0;
    else if(current_state == OUTPUT) out <= destroyed;
    else out <= 0;
end

//Managing out_valid
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n) out_valid <= 0;
    else if(current_state == OUTPUT) out_valid <= 1;
    else out_valid <= 0;
end

//Managing brickmap
always@(posedge clk)
begin
    if(current_state == IDLE) for(i = 0; i < 64; i = i + 1) brickmap[i] <= 0;
    else if(in_valid1) for(i = 0; i < 8; i = i + 1) brickmap[in_count*8 + i] <= in[i];
    else if(current_state == CALC) begin
        case(bombmap[punch[calc_count]])
        1: case(punch[calc_count])
        //Upper right
        0: begin
            brickmap[0] <= 0;
            brickmap[1] <= 0;
            brickmap[8] <= 0;
            brickmap[9] <= 0;
            end
        //Upper left
        7: begin
            brickmap[7] <= 0;
            brickmap[15] <= 0;
            brickmap[6] <= 0;
            brickmap[14] <= 0;
            end
        //Bottom right
        56: begin
            brickmap[56] <= 0;
            brickmap[49] <= 0;
            brickmap[48] <= 0;
            brickmap[57] <= 0;
            end
        //Bottom left
        63: begin
            brickmap[63] <= 0;
            brickmap[62] <= 0;
            brickmap[55] <= 0;
            brickmap[54] <= 0;
            end
        default: begin
                if(punch[calc_count] < 7) begin
                    brickmap[punch[calc_count]] <= 0;
                    brickmap[punch[calc_count]+1] <= 0;
                    brickmap[punch[calc_count]-1] <= 0;
                    brickmap[punch[calc_count]+8] <= 0;
                    brickmap[punch[calc_count]+7] <= 0;
                    brickmap[punch[calc_count]+9] <= 0;
                end
                else if(punch[calc_count] < 63 && punch[calc_count] > 56) begin
                    brickmap[punch[calc_count]] <= 0;
                    brickmap[punch[calc_count]+1] <= 0;
                    brickmap[punch[calc_count]-1] <= 0;
                    brickmap[punch[calc_count]-8] <= 0;
                    brickmap[punch[calc_count]-7] <= 0;
                    brickmap[punch[calc_count]-9] <= 0;
                end
                else if(punch[calc_count] % 8 == 7) begin
                    brickmap[punch[calc_count]] <= 0;
                    brickmap[punch[calc_count]-1] <= 0;
                    brickmap[punch[calc_count]+8] <= 0;
                    brickmap[punch[calc_count]+7] <= 0;
                    brickmap[punch[calc_count]-8] <= 0;
                    brickmap[punch[calc_count]-9] <= 0;
                end
                else if(punch[calc_count] % 8 == 0) begin
                    brickmap[punch[calc_count]] <= 0;
                    brickmap[punch[calc_count]-8] <= 0;
                    brickmap[punch[calc_count]-7] <= 0;
                    brickmap[punch[calc_count]+1] <= 0;
                    brickmap[punch[calc_count]+8] <= 0;
                    brickmap[punch[calc_count]+9] <= 0;
                end
                else begin
                    brickmap[punch[calc_count]] <= 0;
                    brickmap[punch[calc_count]-1] <= 0;
                    brickmap[punch[calc_count]+1] <= 0;
                    brickmap[punch[calc_count]-7] <= 0;
                    brickmap[punch[calc_count]-8] <= 0;
                    brickmap[punch[calc_count]-9] <= 0;
                    brickmap[punch[calc_count]+8] <= 0;
                    brickmap[punch[calc_count]+7] <= 0;
                    brickmap[punch[calc_count]+9] <= 0;
                end
                end
        endcase
        default: brickmap[punch[calc_count]] <= 0;
        endcase
    end
    else for(i = 0; i < 64; i = i + 1) brickmap[i] <= brickmap[i];
end

//Managing bombmap
always@(posedge clk)
begin
    if(current_state == IDLE) for(i = 0; i < 64; i = i + 1) bombmap[i] <= 0;
    else if(in_valid1) for(i = 0; i < 8; i = i + 1) bombmap[in_count*8 + i] <= bomb[i];
    else if(current_state == CALC) begin
        case(bombmap[punch[calc_count]])
        1: case(punch[calc_count])
        //Upper right
        0: begin
            bombmap[0] <= 0;
            bombmap[1] <= 0;
            bombmap[8] <= 0;
            bombmap[9] <= 0;
            end
        //Upper left
        7: begin
            bombmap[7] <= 0;
            bombmap[15] <= 0;
            bombmap[6] <= 0;
            bombmap[14] <= 0;
            end
        //Bottom right
        56: begin
            bombmap[56] <= 0;
            bombmap[49] <= 0;
            bombmap[48] <= 0;
            bombmap[57] <= 0;
            end
        //Bottom left
        63: begin
            bombmap[63] <= 0;
            bombmap[62] <= 0;
            bombmap[55] <= 0;
            bombmap[54] <= 0;
            end
        default: begin
                if(punch[calc_count] < 7) begin
                    bombmap[punch[calc_count]] <= 0;
                    bombmap[punch[calc_count]+1] <= 0;
                    bombmap[punch[calc_count]-1] <= 0;
                    bombmap[punch[calc_count]+8] <= 0;
                    bombmap[punch[calc_count]+7] <= 0;
                    bombmap[punch[calc_count]+9] <= 0;
                end
                else if(punch[calc_count] < 63 && punch[calc_count] > 56) begin
                    bombmap[punch[calc_count]] <= 0;
                    bombmap[punch[calc_count]+1] <= 0;
                    bombmap[punch[calc_count]-1] <= 0;
                    bombmap[punch[calc_count]-8] <= 0;
                    bombmap[punch[calc_count]-7] <= 0;
                    bombmap[punch[calc_count]-9] <= 0;
                end
                else if(punch[calc_count] % 8 == 7) begin
                    bombmap[punch[calc_count]] <= 0;
                    bombmap[punch[calc_count]-1] <= 0;
                    bombmap[punch[calc_count]+8] <= 0;
                    bombmap[punch[calc_count]+7] <= 0;
                    bombmap[punch[calc_count]-8] <= 0;
                    bombmap[punch[calc_count]-9] <= 0;
                end
                else if(punch[calc_count] % 8 == 0) begin
                    bombmap[punch[calc_count]] <= 0;
                    bombmap[punch[calc_count]-8] <= 0;
                    bombmap[punch[calc_count]-7] <= 0;
                    bombmap[punch[calc_count]+1] <= 0;
                    bombmap[punch[calc_count]+8] <= 0;
                    bombmap[punch[calc_count]+9] <= 0;
                end
                else begin
                    bombmap[punch[calc_count]] <= 0;
                    bombmap[punch[calc_count]-1] <= 0;
                    bombmap[punch[calc_count]+1] <= 0;
                    bombmap[punch[calc_count]-7] <= 0;
                    bombmap[punch[calc_count]-8] <= 0;
                    bombmap[punch[calc_count]-9] <= 0;
                    bombmap[punch[calc_count]+8] <= 0;
                    bombmap[punch[calc_count]+7] <= 0;
                    bombmap[punch[calc_count]+9] <= 0;
                end
                end
        endcase
        default: for(i = 0; i < 64; i = i + 1) bombmap[i] <= bombmap[i];
        endcase
    end
    else for(i = 0; i < 64; i = i + 1) bombmap[i] <= bombmap[i];
end

//Managing hit
always@(posedge clk)
begin
    if(current_state == IDLE) for(i = 0; i < 10; i = i + 1) punch[i] <= 0;
    else if(in_valid2) punch[in_count] <= hit;
    else for(i = 0; i < 10; i = i + 1) punch[i] <= punch[i];
end

//Managing destroyed
always@(posedge clk)
begin
    if(current_state == IDLE) destroyed <= 0;
    else if(current_state == CALC) begin
        case(bombmap[punch[calc_count]])
        1: case(punch[calc_count])
            //Upper right
            0: destroyed <= destroyed + brickmap[0] + brickmap[1] + brickmap[8] + brickmap[9];
            //Upper left
            7: destroyed <= destroyed + brickmap[6] + brickmap[7] + brickmap[14] + brickmap[15];
            //Bottom right
            56: destroyed <= destroyed + brickmap[48] + brickmap[49] + brickmap[56] + brickmap[57];
            //Bottom left
            63: destroyed <= destroyed + brickmap[54] + brickmap[55] + brickmap[62] + brickmap[63];
            default: begin
                    if(punch[calc_count] < 7) 
                        destroyed <= destroyed + brickmap[punch[calc_count]] + brickmap[punch[calc_count]+1] + brickmap[punch[calc_count]-1] + brickmap[punch[calc_count]+8] + brickmap[punch[calc_count]+7] + brickmap[punch[calc_count]+9];
                    else if(punch[calc_count] < 63 && punch[calc_count] > 56) 
                        destroyed <= destroyed + brickmap[punch[calc_count]] + brickmap[punch[calc_count]+1] + brickmap[punch[calc_count]-1] + brickmap[punch[calc_count]-8] + brickmap[punch[calc_count]-7] + brickmap[punch[calc_count]-9];
                    else if(punch[calc_count] % 8 == 7)
                        destroyed <= destroyed + brickmap[punch[calc_count]] + brickmap[punch[calc_count]-1] + brickmap[punch[calc_count]+8] + brickmap[punch[calc_count]+7] + brickmap[punch[calc_count]-8] + brickmap[punch[calc_count]-9];
                    else if(punch[calc_count] % 8 == 0)
                        destroyed <= destroyed + brickmap[punch[calc_count]] + brickmap[punch[calc_count]-8] + brickmap[punch[calc_count]-7] + brickmap[punch[calc_count]+1] + brickmap[punch[calc_count]+8] + brickmap[punch[calc_count]+9];
                    else destroyed <= destroyed + brickmap[punch[calc_count]] + brickmap[punch[calc_count]-1] + brickmap[punch[calc_count]+1] + brickmap[punch[calc_count]-7] + brickmap[punch[calc_count]-8] + brickmap[punch[calc_count]-9] + brickmap[punch[calc_count]+8] + brickmap[punch[calc_count]+7] + brickmap[punch[calc_count]+9];
            end endcase
        default: destroyed <= destroyed + brickmap[punch[calc_count]];
        endcase
        end
    else begin
        destroyed <= destroyed;
    end
end


endmodule