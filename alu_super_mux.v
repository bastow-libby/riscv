module alu_super_mux(
    input [31:0] rs1_data,
    input [31:0] rs2_data,
    input [31:0] mem_data,
    input [31:0] writeback_data,
    input [1:0] fua_cs_1,
    input [1:0] fua_cs_2,
    input [31:0] imm,
    input [7:0] control_unit_signal,
    output reg [31:0] mem_write_data,
    output reg [31:0] alu_rs1_data,
    output reg [31:0] alu_rs2_data
);

always @(*) begin

    alu_rs1_data = rs1_data;
    alu_rs2_data = rs2_data;

    // Fowarding Logic
    if (fua_cs_1 == 2'b01) // mem stage
        alu_rs1_data = mem_data;
    else if (fua_cs_1 == 2'b10) // writeback stage
        alu_rs1_data = writeback_data;

    if (fua_cs_2 == 2'b01) // mem stage
        alu_rs2_data = mem_data;
    else if (fua_cs_2 == 2'b10) // writeback stage
        alu_rs2_data = writeback_data;

    mem_write_data = alu_rs2_data;

    // Determine RS2_data
    if (control_unit_signal[1] == 1'b1)
        alu_rs2_data = imm;

end

endmodule
