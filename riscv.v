`timescale 1us/100ns
`include "define.vh"

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
wire mem_stage_register_write_enable;
wire mem_stage_writeback;
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
// ALU Mux
wire [31:0] mem_data;
wire [31:0] writeback_data;
wire [1:0] fua_cs_1;
wire [1:0] fua_cs_2;

wire [31:0] alu_output;

//PC CONTROL 
register32 pc(.din(next_pc), .write_enable(1b'1), .dout(curr_pc), .clk(clk), .rst(rst));
pc_unit pc_comp(.pc(curr_pc), .rs1(rs1), .imm(imm), .is_jalr(control_unit_signal[7]), .target_address(target_address));
pc_mux pc_muxx(.pc(curr_pc), .target_address(target_address), .branch_comp(branch_comp), .jump(control_unit_signal[6]), .next_pc(next_pc));

//FETCH
memory2c imem(.data_out(instruction_encoding), .data_in(32b'0), .addr(curr_pc), .enable(1b'1), .wr(1b'0), .createdump(1b'0), .clk(clk), .rst(rst));

//FETCH-DECODE REGISTER
fetch_decode_reg fd_reg(.inst_encoding(instruction_encoding), .pc(curr_pc), .o_inst_encoding(instruction_encoding), .o_pc(curr_pc), .stall(stall), .flush(flush), .clk(clk), .rst(rst));

// Decode stage modules
decode decoder(.instruction_encoding(instruction_encoding), .opcode(opcode), .funct3(funct3), .funct7(funct7), .rs1(rs1), .rs2(rs2), .rd(rd), .imm(imm), .alu_op(alu_op), .control_unit_signal(control_unit_signal), .flush_cs(flush_cs));
register register_file(.a0(rs1), .a1(rs2), .wr(1b'1), .write_enable(control_unit_signal[0]), .din(din), .clk(clk), .rst(rst), .q0(q0), .q1(q1));
decode_control_mux decode_mux(.stall(stall), .flush(flush_cs), .alu_op(alu_op), .control_unit_signal(control_unit_signal), .o_alu_op(o_alu_op), .o_control_unit_signal(o_control_unit_signal));
forwarding_unit_branch fub(.rs1(rs1), .rs2(rs2), .mem_rd(rd), .mem_stage_register_write_enable(mem_stage_register_write_enable), .mem_stage_writeback(mem_stage_writeback), .fub_cs_1(fub_cs_1), .fub_cs_2(fub_cs_2));
branch_comp_unit bcu(is_branch(control_unit_signal), .fub_cs_1(fub_cs_1), .fub_cs_2(fub_cs_2), .funct3(funct3), .rs1(rs1), .rs2(rs2), .alu_out(alu_output), .mem_out(?), .branch_comp(branch_comp));

hazard_unit hazard_detection_unit(
    .rs1(), // Input - from 
    .rs2(), // Input - from 
    .execute_rd(), // Input - from 
    .mem_rd(), // Input - from 
    .execute_mem_read(), // Input - from 
    .mem_mem_read(), // Input - from 
    .stall() // Output
);

// ID/EX Register
decode_execute_reg(.clk(clk), .pc(curr_pc), .rs1(rs1), .rs2(rs2), .rs1_data(q0), .rs2_data(q1), .imm(imm), .rd(rd), .alu_op(o_alu_op), .control_unit_signal(o_control_unit_signal),.o_pc(o_pc), .o_rs1(o_rs1), .o_rs2(o_rs2), .o_rs1_data(o_rs1_data), .o_rs2_data(o_rs2_data), .o_imm(o_imm), .o_rd(o_rd), .o_alu_op(?), .o_control_unit_signal(?));

decode_execute_reg id_ex_reg(
    .clk(),

);

// Execute stage modules
alu_super_mux alu_mux(
    .rs1_data(o_rs1_data), // Input - from id/ex register
    .rs2_data(o_rs2_data), // Input - from id/ex register
    .mem_data(o_mem_read_data), // Input - from mem/wb register
    .writeback_data(writeback_data), // Input - from writeback_mux
    .fua_cs_1(fua_cs_1), // Input - from fua
    .fua_cs_2(fua_cs_2), // Input - from fua
    .imm(?), // Input - from id/ex register
    .control_unit_signal(?), // Input - from id/ex register
    .mem_write_data(), // Outputs
    .alu_rs1_data(alu_rs1_data),
    .alu_rs2_data(alu_rs2_data)
);

alu alu_module(
    .rs1(alu_rs1_data), // Input - from alu_super_mux
    .rs2(alu_rs2_data), // Input - from alu_super_mux
    .alu_op(id_ex_alu_op), // Input - from id/ex register
    .alu_output(alu_output) // Output
);

execute_control_mux ex_control_mux(
    .flush(?), // Input - from hazard detection unit
    .control_unit_signal(?), // Input - from id/ex register
    .o_control_unit_signal(ex_o_control_unit_signal) // Output
);

forwarding_unit_alu fua(
    .mem_rd(ex_mem_rd), // Input - from ex/mem register
    .mem_we(ex_mem_control_unit_signal), // Input - from ex/mem register
    .writeback_rd(mem_wb_rd), // Input - from mem/wb register
    .writeback(mem_wb_writeback), // Input - from mem/wb register
    .rs1(?), // Input - from id/ex register
    .rs2(?), // Input - from id/ex register
    .fua_cs_1(fua_cs_1), // Outputs cs
    .fua_cs_2(fua_cs_2) // cs
);

// EX/MEM Register
execute_memory_reg ex_mem_reg(
    .clk(clk), // Input
    .rst(rst), // Input
    .rd(o_rd), // Input - From ID/EX Register
    .mem_write_data(mem_write_data), // Input - From alu_super_mux
    .control_unit_signal(ex_o_control_unit_signal), // Input - From execute_control_mux
    .alu_out(alu_output), // Input - From alu
    .o_rd(ex_mem_rd), // Output
    .o_mem_write_data(ex_mem_mem_write_data),
    .o_control_unit_signal(ex_mem_control_unit_signal),
    .o_alu_out(o_alu_output),
    .mem_write(ex_mem_mem_write)
);

// Memory stage modules
memory2c dmem(
    .data_out(dmem_out), // Output
    .data_in(ex_mem_rd), // Input - from ex/mem reg
    .addr(ex_mem_rd), // Input - from ex/mem reg
    .enable(1'b1),
    .wr(ex_mem_mem_write), // Input - from ex/mem reg
    .createdump(1'b0),
    .clk(clk), 
    .rst(rst)
);

// MEM/WB Register
memory_writeback_reg mem_wb_reg(
    .clk(clk), // Input
    .rst(rst), // Input
    .mem_read_data(dmem_out), // Input - from dmem
    .alu_out(o_alu_output), // Input - from ex/mem reg
    .rd(ex_mem_rd), // Input - from ex/mem reg
    .control_unit_signal(ex_mem_control_unit_signal), // Input - from ex/mem reg
    .o_mem_read_data(o_mem_read_data), // Outputs
    .o_alu_out(mem_wb_alu_output),
    .o_rd(mem_wb_rd),
    .writeback(mem_wb_writeback), // cs
    .register_write_enable(mem_wb_reg_we) // cs
);

// Writeback Stage Modules
writeback_mux wb_mux(
    .mem_data(o_mem_read_data), // Input - from mem/wb reg
    .execute_data(mem_wb_alu_output), // Input - from mem/wb reg
    .writeback_control(mem_wb_writeback), // Input - from mem/wb reg
    .writeback_data(writeback_data) // Output
);

endmodule
