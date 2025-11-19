module forwarding_unit_alu(
    input [4:0] mem_rd,
    input mem_we,
    input [4:0] writeback_rd,
    input writeback_we,
    input [4:0] rs1,
    input [4:0] rs2,
    output reg [1:0] fua_cs_1,
    output reg [1:0] fua_cs_2
);

always @(*) begin

    fua_cs_1 = 2'b0;
    if (mem_we == 1'b1 && mem_rd != 5'b0 && mem_rd == rs1) begin
        fua_cs_1 = 2'b01;
    end
    else if (writeback_we == 1'b1 && writeback_rd != 5'b0 && writeback_rd == rs1) begin
        fua_cs_1 = 2'b10;
    end

    fua_cs_2 = 2'b0;
    if (mem_we == 1'b1 && mem_rd != 5'b0 && mem_rd == rs2) begin
        fua_cs_2 = 2'b01;
    end
    else if (writeback_we == 1'b1 && writeback_rd != 5'b0 && writeback_rd == rs2) begin
        fua_cs_2 = 2'b10;
    end

end

endmodule
