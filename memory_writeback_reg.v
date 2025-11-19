module memory_writeback_reg(
    input clk,
    input rst,
    input [31:0] mem_read_data,
    input [31:0] alu_out,
    input [4:0] rd,
    input [7:0] control_unit_signal,
    output reg [31:0] o_mem_read_data,
    output reg [31:0] o_alu_out,
    output reg [4:0] o_rd,
    output reg writeback,
    output reg register_write_enable
);

always @(posedge clk) begin

    o_mem_read_data = mem_read_data;
    o_alu_out = alu_out;
    o_rd = rd;
    writeback = control_unit_signal[2];
    register_write_enable = control_unit_signal[0];

    if (rst == 1'b1) begin
        o_mem_read_data = 0;
        o_alu_out = 0;
        o_rd = 0;
        writeback = 0;
        register_write_enable = 0;
    end

end

endmodule
