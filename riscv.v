`timescale 1us/100ns
module riscv(clk, rst);
input clk, rst;
//input = next_pc, output = curr_pc

wire [31:0] curr_pc;
wire [31:0] next_pc;
wire [31:0] pc_plus_4;
wire [31:0] pc_plus_imm;
wire [31:0] inst_encoding;
wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;
wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rd;
wire [31:0] imm;
wire writeback;
wire we;
wire [31:0] reg_data_1;
wire [31:0] reg_data_2;
wire [3:0] alu_op;
wire [31:0] alu_out;
wire [31:0] alu_in;
wire is_jump;
wire [31:0] writeback_data;

// PC logic: calculate PC+4 and PC+imm
genadder pcadder(.A(curr_pc), .B(32'h4), .S(pc_plus_4), .Cin(1'b0), .Cout());
genadder pc_imm_adder(.A(curr_pc), .B(imm), .S(pc_plus_imm), .Cin(1'b0), .Cout());

// PC mux: if JAL, next PC = PC + imm, else next PC = PC + 4
//Libby, change to include jalr (ra) also
//might need to make tripple mux
assign next_pc = is_jump ? pc_plus_imm : pc_plus_4;

register32 pcmodule(.din(next_pc), .we(1'b1), .dout(curr_pc), .clk(clk), .rst(rst));
memory2c imem(.data_out(inst_encoding), .data_in(32'h0), .addr(curr_pc), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));
decode decoder(.inst_encoding(inst_encoding), .opcode(opcode), .funct3(funct3), .funct7(funct7), .rs1(rs1), .rs2(rs2), .rd(rd), .imm(imm), .writeback(writeback), .we(we), .alu_op(alu_op), .is_jump(is_jump));

// Writeback data mux: if JAL, writeback PC+4, else writeback ALU output
assign writeback_data = is_jump ? pc_plus_4 : alu_out;


// read registers for R1 and r2
register registr(.a0(rs1), .a1(rs2), .wr(rd), .we(we), .din(writeback_data), .clk(clk), .rst(rst), .q0(reg_data_1), .q1(reg_data_2));
alu_mux mux1(.r2(reg_data_2), .imm(imm), .sel(opcode), .out(alu_in));
alu riscv_alu(.a(reg_data_1), .b(alu_in), .func(alu_op), .out(alu_out));
  


endmodule
