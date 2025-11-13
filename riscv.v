`timescale 1us/100ns
`include "define.vh"

//NOTE: Dan, there are two signals called o_alu_op (one from decode control mux and one from 
//decode-exexute register). We need to go back through those. I marked them with ?s to make 
//them searchable.

module riscv(
    input clk,
    input rst
);

//PC SIGNALS
wire [31:0] next_pc;
wire [31:0] curr_pc;
wire [31:0] target_address;

//FETCH SIGNALS
wire [31:0] instruction_encoding;

wire stall;
wire flush;

//DECODE SIGNALS
wire [7:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;
wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rd;
wire [31:0] imm;
wire [3:0] alu_op;
wire [7:0] control_unit_signal;
wire flush_cs;
wire [31:0] din;
wire [31:0] q0;
wire [31:0] q1;

wire [3:0] o_alu_op;
wire [7:0] o_control_unit_signal;

wire [1:0] fub_cs_1;
wire [1:0] fub_cs_2;

wire branch_comp;

//EXECUTE SIGNALS
wire [31:0] o_pc;
wire [4:0] o_rs1;
wire [4:0] o_rs2;
wire [31:0] o_rs1_data;
wire [31:0] o_rs2_data;
wire [31:0] o_imm;
wire [4:0] o_rd;

wire [31:0]result;

//PC CONTROL 
register32 pc(.din(next_pc), .write_enable(1b'1), .dout(curr_pc), .clk(clk), .rst(rst));
pc_unit pc_comp(.pc(curr_pc), .rs1(rs1), .imm(imm), .is_jalr(control_unit_signal[7]), .target_address(target_address));
pc_mux pc_muxx(.pc(curr_pc), .target_address(target_address), .branch_comp(branch_comp), .jump(control_unit_signal[?]), .next_pc(next_pc));

//FETCH
memory2c imem(.data_out(instruction_encoding), .data_in(32b'0), .addr(curr_pc), .enable(1b'1), .wr(1b'0), .createdump(1b'0), .clk(clk), .rst(rst));

//FETCH-DECODE REGISTER
fetch_decode_reg fd_reg(.inst_encoding(instruction_encoding), .pc(curr_pc), .o_inst_encoding(instruction_encoding), .o_pc(curr_pc), .stall(stall), .flush(flush), .clk(clk), .rst(rst));

//DECODE
decode decoder(.instruction_encoding(instruction_encoding), .opcode(opcode), .funct3(funct3), .funct7(funct7), .rs1(rs1), .rs2(rs2), .rd(rd), .imm(imm), .alu_op(alu_op), .control_unit_signal(control_unit_signal), .flush_cs(flush.cs));
register register_file(.a0(rs1), .a1(rs2), .wr(1b'1), .write_enable(control_unit_signal[0]), .din(din), .clk(clk), .rst(rst), .q0(q0), .q1(q1));
decode_control_mux decode_mux(.stall(stall), .flush(flush), .alu_op(alu_op), .control_unit_signal(control_unit_signal), .o_alu_op(?o_alu_op), .o_control_unit_signal(?o_control_unit_signal));
forwarding_unit_branch fub(.rs1(rs1), .rs2(rs2), .mem_rd(rd), .mem_stage_register_write_enable(?), .mem_stage_writeback, .fub_cs_1(fub_cs_1), .fub_cs_2(fub_cs_2));
branch_comp_unit bcu(is_branch(control_unit_signal), .fub_cs_1(fub_cs_1), .fub_cs_2(fub_cs_2), .funct3(funct3), .rs1(rs1), .rs2(rs2), .alu_out(?), .mem_out(?), .branch_comp(branch_comp));

//DECODE-EXECUTE REGISTER
//NOTE: I am not sure if the alu_op passed here should be the alu_op calculated by decode control mux, but that is what i put
//Same for control_unit_signal
decode_execute_reg(.clk(clk), .pc(curr_pc), .rs1(rs1), .rs2(rs2), .rs1_data(q0), .rs2_data(q1), .imm(imm), .rd(rd), .alu_op(?o_alu_op), .control_unit_signal(?o_control_unit_signal),.o_pc(o_pc), .o_rs1(o_rs1), .o_rs2(o_rs2), .o_rs1_data(o_rs1_data), .o_rs2_data(o_rs2_data), .o_imm(o_imm), .o_rd(o_rd), .o_alu_op(?), .o_control_unit_signal(?));
alu alu_module(.alu_rs1(alu_rs1), .rs2(.alu_rs2), .alu_op(?alu_op), .result(result));
//where is the alu mux?

//EXECUTE 


endmodule
