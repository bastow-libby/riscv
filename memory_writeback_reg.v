module memory_writeback_reg(
    input clk,
    input [31:0] mem_read_data,
    input [31:0] alu_out,
    input [4:0] rd,
    input [7:0] control_unit_signal,
    output reg [31:0] o_mem_read_data,
    output reg [31:0] o_alu_out,
    output reg [4:0] o_rd,
    output reg [7:0] o_control_unit_signal
);

always @(posedge clk) begin

    o_mem_read_data = mem_read_data;
    o_alu_out = alu_out;
    o_rd = rd;
    o_control_unit_signal = control_unit_signal;

end

endmodule
