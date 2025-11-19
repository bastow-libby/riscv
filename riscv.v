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
wire [31:0] o_pc;
wire [31:0] rs1_data;
wire [31:0] imm;
wire [7:0] control_unit_signal;
wire branch_comp;
//FETCH SIGNALS
wire [31:0] instruction_encoding;
// IF/ID Register
wire stall;
wire flush;
wire [31:0] o_inst_encoding;
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
wire [31:0] writeback_data;
wire mem_wb_reg_we;
wire [31:0] rs1_data;
wire [31:0] rs2_data;
wire [3:0] id_mux_alu_op;
wire [7:0] id_mux_control_unit_signal;
wire mem_stage_register_write_enable;
wire mem_stage_writeback;
wire [1:0] fub_cs_1;
wire [1:0] fub_cs_2;
wire [31:0] o_alu_output;
wire [31:0] o_mem_read_data;
wire [4:0] id_ex_o_rd;
wire [4:0] ex_mem_rd;
wire [7:0] id_ex_o_control_unit_signal;
wire [7:0] ex_mem_control_unit_signal;
wire [7:0] ex_o_control_unit_signal;
// ID/EX Register
wire [31:0] id_ex_o_pc;
wire [31:0] id_ex_o_rs1;
wire [31:0] id_ex_o_rs2;
wire [31:0] id_ex_o_rs1_data;
wire [31:0] id_ex_o_rs2_data;
wire [31:0] id_ex_o_imm;
wire [3:0] id_ex_o_alu_op;
// EXECUTE SIGNALS
wire [1:0] fua_cs_1;
wire [1:0] fua_cs_2;
wire [31:0] mem_write_data;
wire [31:0] alu_rs1_data;
wire [31:0] alu_rs2_data;
wire [3:0] id_ex_alu_op;
wire [31:0] alu_output;
wire [4:0] mem_wb_rd;
wire mem_wb_writeback
// EX/MEM Register
wire [31:0] ex_mem_mem_write_data;
wire ex_mem_mem_write;
// MEMORY SIGNALS
wire [31:0] dmem_out;
// MEM/WB Register
wire [31:0] mem_wb_alu_output

// Program counter
register32 pc(
    .din(next_pc),
    .write_enable(1'b1),
    .dout(curr_pc),
    .clk(clk),
    .rst(rst)
);

// Program counter control
pc_unit pc_comp(
    .pc(o_pc), // Input - from if/id register
    .rs1(rs1_data), // Input - from register file
    .imm(imm), // Input - from decode
    .is_jalr(control_unit_signal[7]), // Input - from decode
    .target_address(target_address) // Output 
);
pc_mux pc_muxx(
    .pc(curr_pc), // Input - from pc module
    .target_address(target_address), // Input - from pc_unit
    .branch_comp(branch_comp), // Input - from branch comp
    .jump(control_unit_signal[6]), // Input - from decode
    .next_pc(next_pc) // Output
);

// Fetch stage modules
memory2c imem(
    .clk(clk), // Input
    .rst(rst), // Input
    .data_out(instruction_encoding), // Output
    .data_in(32'b0),
    .addr(curr_pc), // Input - from pc module
    .enable(1'b1), 
    .wr(1'b0), 
    .createdump(1'b0)
);

// IF/ID REGISTER
fetch_decode_reg if_id_reg(
    .clk(clk),
    .rst(rst),
    .inst_encoding(instruction_encoding), // Input - from instruction memory
    .pc(curr_pc), // Input - from pc module
    .stall(stall), // Input - from hazard detection unit
    .flush(flush), // Input - from decode
    .o_inst_encoding(o_inst_encoding), // Outputs
    .o_pc(o_pc)
);

// Decode stage modules
decode decoder(
    .instruction_encoding(o_inst_encoding), // Input - from if/id reg
    .opcode(opcode), // Outputs
    .funct3(funct3),
    .funct7(funct7),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .imm(imm),
    .alu_op(alu_op),
    .control_unit_signal(control_unit_signal),
    .flush_cs(flush)
);

register register_file(
    .clk(clk),
    .rst(rst),
    .din(writeback_data), // Input - from writeback_mux
    .a0(rs1), // Input - from decode
    .a1(rs2), // Input - from decode
    .wr(1'b1),
    .write_enable(mem_wb_reg_we), // Input - from mem/wb reg
    .q0(rs1_data), // Outputs
    .q1(rs2_data),

);

decode_control_mux decode_control_muxxer(
    .stall(stall), // Inputs - from hazard unit
    .flush(flush), // Inputs - from decode
    .alu_op(alu_op), // Inputs - from decode
    .control_unit_signal(control_unit_signal), // Inputs - from decode
    .o_alu_op(id_mux_alu_op), // Outputs
    .o_control_unit_signal(id_mux_control_unit_signal)
);

forwarding_unit_branch fub(
    .rs1(rs1), // Input - from decode
    .rs2(rs2), // Input - from decode
    .mem_rd(ex_mem_rd), // Input - from ex/mem register
    .mem_stage_register_write_enable(ex_mem_control_unit_signal[0]), // Input - from ex/mem register
    .mem_stage_writeback(ex_mem_control_unit_signal[2]), // Input - from ex/mem register
    .fub_cs_1(fub_cs_1), // Outputs
    .fub_cs_2(fub_cs_2)
);

branch_comp_unit bcu(
    .is_branch(control_unit_signal[5]), // Input - from decode
    .fub_cs_1(fub_cs_1), // Input - from fowarding unit branch
    .fub_cs_2(fub_cs_2), // Input - from fowarding unit branch
    .funct3(funct3), // Input - from decode
    .rs1(rs1_data), // Input - from register file
    .rs2(rs2_data), // Input - from register file
    .alu_out(o_alu_output), // Input - from ex/mem reg
    .mem_out(o_mem_read_data), // Input - from mem/wb reg
    .branch_comp(branch_comp) // Output
);

hazard_unit hazard_detection_unit(
    .rs1(rs1), // Input - from decode
    .rs2(rs2), // Input - from decode
    .execute_rd(id_ex_o_rd), // Input - from id/ex reg
    .mem_rd(ex_mem_rd), // Input - from ex/mem reg
    .execute_mem_read(id_ex_o_control_unit_signal[3]), // Input - from id/ex reg
    .mem_mem_read(ex_mem_control_unit_signal[3]), // Input - from ex/mem reg
    .stall(stall) // Output
);

// ID/EX Register
decode_execute_reg id_ex_reg(
    .clk(clk), // Input
    .rst(rst), // Input
    .pc(o_pc), // Input - from if/id register
    .rs1(rs1), // Input - from decode
    .rs2(rs2), // Input - from decode
    .rs1_data(rs1_data), // Input - from register file
    .rs2_data(rs2_data), // Input - from register file
    .imm(imm), // Input - from decode
    .rd(rd), // Input - from decode
    .alu_op(id_mux_alu_op), // Input - from decode control mux
    .control_unit_signal(id_mux_control_unit_signal), // Input - from decode control mux
    .o_pc(id_ex_o_pc), // Outputs
    .o_rs1(id_ex_o_rs1),
    .o_rs2(id_ex_o_rs2),          
    .o_rs1_data(id_ex_o_rs1_data),  
    .o_rs2_data(id_ex_o_rs2_data),   
    .o_imm(id_ex_o_imm), 
    .o_rd(id_ex_o_rd), 
    .o_alu_op(id_ex_o_alu_op), 
    .o_control_unit_signal(id_ex_o_control_unit_signal) 
);

// Execute stage modules
alu_super_mux alu_mux(
    .rs1_data(id_ex_o_rs1_data), // Input - from id/ex register
    .rs2_data(id_ex_o_rs2_data), // Input - from id/ex register
    .mem_data(o_mem_read_data), // Input - from mem/wb register
    .writeback_data(writeback_data), // Input - from writeback_mux
    .fua_cs_1(fua_cs_1), // Input - from fua
    .fua_cs_2(fua_cs_2), // Input - from fua
    .imm(id_ex_o_imm), // Input - from id/ex register
    .control_unit_signal(id_ex_o_control_unit_signal), // Input - from id/ex register
    .mem_write_data(mem_write_data), // Outputs
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
    .flush(flush), // Input - from hazard detection unit
    .control_unit_signal(id_ex_o_control_unit_signal), // Input - from id/ex register
    .o_control_unit_signal(ex_o_control_unit_signal) // Output
);

forwarding_unit_alu fua(
    .mem_rd(ex_mem_rd), // Input - from ex/mem register
    .mem_we(ex_mem_control_unit_signal), // Input - from ex/mem register
    .writeback_rd(mem_wb_rd), // Input - from mem/wb register
    .writeback(mem_wb_writeback), // Input - from mem/wb register
    .rs1(id_ex_o_rs1), // Input - from id/ex register
    .rs2(id_ex_o_rs2), // Input - from id/ex register
    .fua_cs_1(fua_cs_1), // Outputs cs
    .fua_cs_2(fua_cs_2) // cs
);

// EX/MEM Register
execute_memory_reg ex_mem_reg(
    .clk(clk), // Input
    .rst(rst), // Input
    .rd(id_ex_o_rd), // Input - From ID/EX Register
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
    .data_in(ex_mem_mem_write_data), // Input - from ex/mem reg
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
