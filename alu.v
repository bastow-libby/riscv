`timescale 1us/100ns
`include "define.vh"

module alu(
    input [31:0] rs1, rs2,  
    input [3:0] alu_op,
    output reg [31:0] result
);

always @(*) begin
    case(alu_op)
        // R-Type Instructions
        `ALU_ADD: begin
            result = rs1 + rs2;
            end
        
        `ALU_SUB: begin
            result = rs1 - rs2;
            end

        `ALU_AND: begin
            result = rs1 & rs2;
            end

        `ALU_OR: begin
            result = rs1 | rs2;
            end

        `ALU_XOR: begin
            result = rs1 ^ rs2;
            end

        // I-Type Instructions
        `ALU_ADDI: begin
            result = rs1 + rs2;
            end
        `ALU_SLLI: begin
            result = rs1 << rs2;
            end
        `ALU_SRLI: begin
            result = rs1 >> rs2;
            end
        `ALU_SRAI: begin
            result = rs1 >>> rs2;
            end

        // Default Case
        default: begin
            result = 32'h00000000;
        end
    endcase
end

endmodule
