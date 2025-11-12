module execute_memory_reg(
    input clk,
    input [4:0] rd,
    input [31:0] mem_write_data,
    input [7:0] control_unit_signal,
    input [31:0] alu_out,
    output reg [4:0] o_rd,
    output reg [31:0] o_mem_write_data,
    output reg [7:0] o_control_unit_signal,
    output reg [31:0] o_alu_out
);

always @(posedge clk) begin

    o_rd = rd;
    o_mem_write_data = mem_write_data;
    o_control_unit_signal = control_unit_signal;
    o_alu_out = alu_out;

end

endmodule
