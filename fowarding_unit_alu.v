module forwarding_unit_alu(
    input [4:0] mem_rd,
    input mem_register_write_enable,
    input [4:0] writeback_rd,
    input writeback_register_write_enable,
    input [4:0] rs1,
    input [4:0] rs2,
    output reg [1:0] fua_cs_1,
    output reg [1:0] fua_cs_2
);

always @(*) begin

    fua_cs_1 = 2'b0;
    fua_cs_2 = 2'b0;

    if (mem_register_write_enable == 1'b1) begin

        if (mem_rd == rs1)
            fua_cs_1 = 2'b01;
        if (mem_rd == rs2)
            fua_cs_2 = 2'b01;

    end

    if (writeback_register_write_enable == 1'b1) begin

        if (writeback_rd == rs1)
            fua_cs_1 = 2'b10;
        if (writeback_rd == rs2)
            fua_cs_2 = 2'b10;

    end

end

endmodule
