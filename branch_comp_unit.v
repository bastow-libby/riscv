// Located in decode stage, computes branch comparison control signal
// branch_comp == 1 represents a valid branch comparison, 0 otherwise
`include "define.vh"

module branch_comp_unit(
    input [7:0] is_branch,
    input [1:0] fub_cs_1,
    input [1:0] fub_cs_2,
    input [2:0] funct3,
    input signed [31:0] rs1,
    input signed [31:0] rs2,
    input [31:0] alu_out,
    input [31:0] mem_out,
    output reg branch_comp
);

    // BLT and BGE use signed comparison
    reg signed [31:0] rs1_val;
    reg signed [31:0] rs2_val;

always @(*) begin
    if (is_branch[5] == 1'b1) begin

        rs1_val = rs1;
        rs2_val = rs2;

        // Forwarding Logic
        case (fub_cs_1)
            2'b10: rs1_val = alu_out;
            2'b01: rs1_val = mem_out;
        endcase
        case (fub_cs_2)
            2'b10: rs2_val = alu_out;
            2'b01: rs2_val = mem_out;
        endcase

        // Comparison
        case (funct3)
            `FUNCT3_BEQ: begin
                branch_comp = (rs1_val == rs2_val);
            end
            `FUNCT3_BNE: begin
                branch_comp = (rs1_val != rs2_val);
            end
            `FUNCT3_BLT: begin
                branch_comp = (rs1_val < rs2_val);
            end
            `FUNCT3_BGE: begin
                branch_comp = (rs1_val >= rs2_val);
            end
            default: begin
                branch_comp = 1'b0;
            end
        endcase
    end
    else
        branch_comp = 1'b0;
end

endmodule
