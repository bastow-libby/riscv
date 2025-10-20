`timescale 1us/100ns
module barrel_shifter(
    input [31:0] in, 
    input shift_amt,
    input [1:0] shift_code, 
    output [31:0] out
);
// TODO: Is this thing functional...
// If i want to incorporate more types of shifts, structure like alu

assign out = in >> shift_amt;

reg [31:0] result;
assign out = result;

//I'm sort of worried abt the cases not being complete...
//adder 

endmodule