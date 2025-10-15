`timescale 1us/100ns
module riscv(clk, rst);
input clk, rst;
//input = next_pc, output = curr_pc

wire [31:0] curr_pc;
wire [31:0] next_pc;
wire [31:0] inst_encoding;

genadder pcadder(.A(curr_pc), .B(32'h4), .S(next_pc), .Cin(1'b0), .Cout());
register32 pcmodule(.din(next_pc), .we(1'b1), .dout(curr_pc), .clk(clk), .rst(rst));
memory2c imem(.data_out(inst_encoding), .data_in(32'h0), .addr(curr_pc), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));
register regfile(do1, do2, A2, we, din);

endmodule
