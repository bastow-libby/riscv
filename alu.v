`timescale 1us/100ns
//Attempt at ALU using case statements
module alu(
input [31:0] a,b,   // change to rs1 rs2?                 
input [3:0] func,// ALU Selection
input [31:0] imm, // Immediate value
output [31:0] out);


reg [31:0] result;
assign out = result;

//I'm sort of worried abt the cases not being complete...
//adder 
wire [31:0] add_result;
wire cout;
adder32 alu_adder(.A(a), .B(b), .Cin(1'b0), .S(add_result), .Cout(cout));

// TODO: Need to grab correct input for rs1, rs2, rd, etc + Output to correct locations.
// pls test bench this libby - dan
always @(*) begin
	case(func)
		// R-Type Instructions - 10 Instructions - 0000 -> 1010
		4'b0000: begin // ADD
			result = add_result;
			end
		
        	4'b0001: begin // SUB
           		result = a - b;
			end

		4'b0010: begin // AND
			result = a & b;
			end

		4'b0011: begin // OR
			result = a | b;
			end

		4'b0100: begin // XOR
			result = a ^ b;
			end

		// I-Type Instructions - a lot idk
		// ToDo: Actually grab the immediate correctly
		4'b1011: begin // ADDI
			result = a - imm;
			end

		default: begin
			
			result = 32'h00000000;
		end
	endcase
end



endmodule
