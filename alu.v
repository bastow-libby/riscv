`timescale 1us/100ns
`include "define.vh"

module alu(
    input [31:0] rs1, rs2,  
    input [3:0] alu_op,
    output reg [31:0] alu_output
);

always @(*) begin
    case(alu_op)
        // R-Type Instructions
        `ALU_ADD: begin
            alu_output = rs1 + rs2;
            end
        
        `ALU_SUB: begin
            alu_output = rs1 - rs2;
            end

        `ALU_AND: begin
            alu_output = rs1 & rs2;
            end

        `ALU_OR: begin
            alu_output = rs1 | rs2;
            end

        `ALU_XOR: begin
            alu_output = rs1 ^ rs2;
            end

        // I-Type Instructions
        `ALU_ADDI: begin
            alu_output = rs1 + rs2;
            end
        `ALU_SLLI: begin
            alu_output = rs1 << rs2;
            end
        `ALU_SRLI: begin
            alu_output = rs1 >> rs2;
            end
        `ALU_SRAI: begin
            alu_output = rs1 >>> rs2;
            end

        // Default Case
        default: begin
            alu_output = 32'h00000000;
        end
    endcase
end

endmodule
