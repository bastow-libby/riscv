`timescale 1us/100ns
`include "define.vh"

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
        // R-Type Instructions
        `ALU_ADD: begin // ADD
            result = add_result;
            end
        
        `ALU_SUB: begin // SUB
            result = a - b;
            end

        `ALU_AND: begin // AND
            result = a & b;
            end

        `ALU_OR: begin // OR
            result = a | b;
            end

        `ALU_XOR: begin // XOR
            result = a ^ b;
            end

        // I-Type Instructions
        // ToDo: Actually grab the immediate correctly
        `ALU_ADDI: begin // ADDI
            result = a + imm;
            end

        default: begin
            result = 32'h00000000;
        end
    endcase
end

endmodule
