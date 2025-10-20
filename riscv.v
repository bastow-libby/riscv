`timescale 1us/100ns
module riscv(clk, rst);
input clk, rst;
//input = next_pc, output = curr_pc

wire [31:0] curr_pc;
wire [31:0] next_pc;
wire [31:0] inst_encoding;
wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;
wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rd;
wire [31:0] imm;
wire writeback;
wire [3:0] alu_op;
wire [31:0] alu_out;
wire [31:0] alu_in;

genadder pcadder(.A(curr_pc), .B(32'h4), .S(next_pc), .Cin(1'b0), .Cout());
register32 pcmodule(.din(next_pc), .we(1'b1), .dout(curr_pc), .clk(clk), .rst(rst));
memory2c imem(.data_out(inst_encoding), .data_in(32'h0), .addr(curr_pc), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));
decode decoder(.inst_encoding(inst_encoding), .opcode(opcode), .funct3(funct3), .funct7(funct7), .rs1(rs1), .rs2(rs2), .rd(rd), .imm(imm), .writeback(writeback), .alu_op(alu_op));
alu_mux mux1(.r2(rs2), .imm(imm), .sel(opcode), .out(alu_in));
alu riscv_alu(.a(rs1), .b(alu_in), .func(alu_op), .out(alu_out));
  


endmodule
