module decode_execute_reg(
    input clk,
    input rst,
    input [31:0] pc,
    input [4:0] rs1,
    input [4:0] rs2,
    input [31:0] rs1_data,
    input [31:0] rs2_data,
    input [31:0] imm,
    input [4:0] rd,
    input [3:0] alu_op,
    input [7:0] control_unit_signal,
    output reg [31:0] o_pc,
    output reg [4:0] o_rs1,
    output reg [4:0] o_rs2,
    output reg [31:0] o_rs1_data,
    output reg [31:0] o_rs2_data,
    output reg [31:0] o_imm,
    output reg [4:0] o_rd,
    output reg [3:0] o_alu_op,
    output reg [7:0] o_control_unit_signal
);

always @ (posedge clk) begin

    o_pc = pc;
    o_rs1 = rs1;
    o_rs2 = rs2;
    o_rs1_data = rs1_data;
    o_rs2_data = rs2_data;
    o_imm = imm;
    o_rd = rd;
    o_alu_op = alu_op;
    o_control_unit_signal = control_unit_signal;

    if (rst == 1'b1) begin
        o_pc = 0;
        o_rs1 = 0;
        o_rs2 = 0;
        o_rs1_data = 0;
        o_rs2_data = 0;
        o_imm = 0;
        o_rd = 0;
        o_alu_op = 0;
        o_control_unit_signal = 0;
    end


end

endmodule
