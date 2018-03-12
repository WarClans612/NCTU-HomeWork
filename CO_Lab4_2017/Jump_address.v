//Student ID: 0416106
//Name: Wilbert
module Jump_address (instruction, pc, out);

//IO managing
input	[25:0]	instruction;
input	[3:0]	pc;
output	[31:0]	out;

//Internal Wire
wire	[27:0] shift_result;

assign shift_result = {2'b00, instruction} << 2;
assign out = {pc, shift_result};





endmodule
