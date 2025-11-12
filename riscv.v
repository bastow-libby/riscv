`timescale 1us/100ns
`include "define.vh"

module riscv(
    input clk,
    input rst
);

    // ===========================
    // FETCH STAGE SIGNALS
    // ===========================
    wire [31:0] pc;
    wire [31:0] next_pc;
    wire [31:0] instruction;
    wire [31:0] fetch_decode_pc;
    wire [31:0] fetch_decode_instruction;
    
    // ===========================
    // DECODE STAGE SIGNALS
    // ===========================
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [4:0] rs1_addr;
    wire [4:0] rs2_addr;
    wire [4:0] rd_addr;
    wire [31:0] imm;
    wire [3:0] alu_op;
    wire [7:0] control_unit_signal;
    wire flush_cs;
    
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    
    wire [3:0] decode_alu_op;
    wire [7:0] decode_control_signal;
    
    // Hazard signals
    wire stall;
    wire branch_comp;
    wire [1:0] fub_cs_1;
    wire [1:0] fub_cs_2;
    
    // Target address calculation
    wire [31:0] target_address;
    wire [31:0] forwarded_rs1_branch;
    
    // Decode-Execute Register outputs
    wire [31:0] de_pc;
    wire [4:0] de_rs1;
    wire [4:0] de_rs2;
    wire [31:0] de_rs1_data;
    wire [31:0] de_rs2_data;
    wire [31:0] de_imm;
    wire [4:0] de_rd;
    wire [3:0] de_alu_op;
    wire [7:0] de_control_signal;
    
    // ===========================
    // EXECUTE STAGE SIGNALS
    // ===========================
    wire [31:0] alu_rs1_data;
    wire [31:0] alu_rs2_data;
    wire [31:0] alu_result;
    wire [31:0] mem_write_data;
    wire [1:0] fua_cs_1;
    wire [1:0] fua_cs_2;
    
    wire [7:0] execute_control_signal;
    
    // Execute-Memory Register outputs
    wire [4:0] em_rd;
    wire [31:0] em_mem_write_data;
    wire [7:0] em_control_signal;
    wire [31:0] em_alu_out;
    
    // ===========================
    // MEMORY STAGE SIGNALS
    // ===========================
    wire [31:0] mem_read_data;
    
    // Memory-Writeback Register outputs
    wire [31:0] mw_mem_read_data;
    wire [31:0] mw_alu_out;
    wire [4:0] mw_rd;
    wire [7:0] mw_control_signal;
    
    // ===========================
    // WRITEBACK STAGE SIGNALS
    // ===========================
    wire [31:0] writeback_data;
    
    // ===========================
    // CONTROL SIGNALS
    // ===========================
    wire is_branch = de_control_signal[2];
    wire is_jump = de_control_signal[1];
    wire is_jalr = de_control_signal[0];
    wire flush = branch_comp | is_jump;
    
    // ===========================
    // FETCH STAGE
    // ===========================
    
    // Program Counter
    register32 pc_reg(
        .din(next_pc),
        .write_enable(~stall),
        .dout(pc),
        .clk(clk),
        .rst(rst)
    );
    
    // Instruction Memory
    memory2c instruction_memory(
        .data_out(instruction),
        .data_in(32'b0),
        .addr(pc),
        .enable(1'b1),
        .wr(1'b0),
        .createdump(1'b0),
        .clk(clk),
        .rst(rst)
    );
    
    // PC Calculation
    pc_unit pc_calc(
        .pc(fetch_decode_pc),
        .rs1(forwarded_rs1_branch),
        .imm(imm),
        .is_jalr(is_jalr),
        .target_address(target_address)
    );
    
    pc_mux pc_selector(
        .pc(pc),
        .target_address(target_address),
        .branch_comp(branch_comp),
        .jump(is_jump),
        .next_pc(next_pc)
    );
    
    // Fetch-Decode Pipeline Register
    fetch_decode_reg fd_reg(
        .inst_encoding(instruction),
        .pc(pc),
        .o_inst_encoding(fetch_decode_instruction),
        .o_pc(fetch_decode_pc),
        .stall(stall),
        .flush(flush | flush_cs),
        .clk(clk)
    );
    
    // ===========================
    // DECODE STAGE
    // ===========================
    
    // Instruction Decoder
    decode instruction_decoder(
        .instruction_encoding(fetch_decode_instruction),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .rs1(rs1_addr),
        .rs2(rs2_addr),
        .rd(rd_addr),
        .imm(imm),
        .alu_op(alu_op),
        .control_unit_signal(control_unit_signal),
        .flush_cs(flush_cs)
    );
    
    // Register File
    register register_file(
        .a0(rs1_addr),
        .a1(rs2_addr),
        .wr(mw_rd),
        .write_enable(mw_control_signal[7]),
        .din(writeback_data),
        .clk(clk),
        .rst(rst),
        .q0(rs1_data),
        .q1(rs2_data)
    );
    
    // Hazard Detection
    hazard_unit hazard_detector(
        .rs1(rs1_addr),
        .rs2(rs2_addr),
        .execute_rd(de_rd),
        .mem_rd(em_rd),
        .execute_mem_read(de_control_signal[4]),
        .mem_mem_read(em_control_signal[4]),
        .stall(stall)
    );
    
    // Branch Forwarding Unit
    forwarding_unit_branch branch_forward(
        .rs1(rs1_addr),
        .rs2(rs2_addr),
        .mem_rd(em_rd),
        .mem_stage_register_write_enable(em_control_signal[7]),
        .mem_stage_writeback(em_control_signal[5]),
        .fub_cs_1(fub_cs_1),
        .fub_cs_2(fub_cs_2)
    );
    
    // Branch Comparison Unit
    branch_comp_unit branch_comparator(
        .is_branch(control_unit_signal[2]),
        .fub_cs_1(fub_cs_1),
        .fub_cs_2(fub_cs_2),
        .funct3(funct3),
        .rs1(rs1_data),
        .rs2(rs2_data),
        .alu_out(em_alu_out),
        .mem_out(mem_read_data),
        .branch_comp(branch_comp)
    );
    
    // Forward rs1 for target address calculation
    assign forwarded_rs1_branch = (fub_cs_1 == 2'b10) ? em_alu_out :
                                   (fub_cs_1 == 2'b01) ? mem_read_data :
                                   rs1_data;
    
    // Decode Control Mux (handles stalls)
    decode_control_mux decode_ctrl_mux(
        .stall(stall),
        .flush(flush),
        .alu_op(alu_op),
        .control_unit_signal(control_unit_signal),
        .o_alu_op(decode_alu_op),
        .o_control_unit_signal(decode_control_signal)
    );
    
    // Decode-Execute Pipeline Register
    decode_execute_reg de_reg(
        .clk(clk),
        .pc(fetch_decode_pc),
        .rs1(rs1_addr),
        .rs2(rs2_addr),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .imm(imm),
        .rd(rd_addr),
        .alu_op(decode_alu_op),
        .control_unit_signal(decode_control_signal),
        .o_pc(de_pc),
        .o_rs1(de_rs1),
        .o_rs2(de_rs2),
        .o_rs1_data(de_rs1_data),
        .o_rs2_data(de_rs2_data),
        .o_imm(de_imm),
        .o_rd(de_rd),
        .o_alu_op(de_alu_op),
        .o_control_unit_signal(de_control_signal)
    );
    
    // ===========================
    // EXECUTE STAGE
    // ===========================
    
    // ALU Forwarding Unit
    forwarding_unit_alu alu_forward(
        .mem_rd(em_rd),
        .mem_register_write_enable(em_control_signal[7]),
        .writeback_rd(mw_rd),
        .writeback_register_write_enable(mw_control_signal[7]),
        .rs1(de_rs1),
        .rs2(de_rs2),
        .fua_cs_1(fua_cs_1),
        .fua_cs_2(fua_cs_2)
    );
    
    // ALU Input Mux (handles forwarding and immediate selection)
    alu_super_mux alu_input_mux(
        .rs1_data(de_rs1_data),
        .rs2_data(de_rs2_data),
        .mem_data(em_alu_out),
        .writeback_data(writeback_data),
        .fua_cs_1(fua_cs_1),
        .fua_cs_2(fua_cs_2),
        .imm(de_imm),
        .control_unit_signal(de_control_signal),
        .mem_write_data(mem_write_data),
        .alu_rs1_data(alu_rs1_data),
        .alu_rs2_data(alu_rs2_data)
    );
    
    // ALU
    alu arithmetic_logic_unit(
        .rs1(alu_rs1_data),
        .rs2(alu_rs2_data),
        .alu_op(de_alu_op),
        .result(alu_result)
    );
    
    // Execute Control Mux (handles flushes)
    execute_control_mux execute_ctrl_mux(
        .flush(flush),
        .control_unit_signal(de_control_signal),
        .o_control_unit_signal(execute_control_signal)
    );
    
    // Execute-Memory Pipeline Register
    execute_memory_reg em_reg(
        .clk(clk),
        .rd(de_rd),
        .mem_write_data(mem_write_data),
        .control_unit_signal(execute_control_signal),
        .alu_out(alu_result),
        .o_rd(em_rd),
        .o_mem_write_data(em_mem_write_data),
        .o_control_unit_signal(em_control_signal),
        .o_alu_out(em_alu_out)
    );
    
    // ===========================
    // MEMORY STAGE
    // ===========================
    
    // Data Memory
    memory2c data_memory(
        .data_out(mem_read_data),
        .data_in(em_mem_write_data),
        .addr(em_alu_out),
        .enable(em_control_signal[4] | em_control_signal[3]),
        .wr(em_control_signal[3]),
        .createdump(1'b0),
        .clk(clk),
        .rst(rst)
    );
    
    // Memory-Writeback Pipeline Register
    memory_writeback_reg mw_reg(
        .clk(clk),
        .mem_read_data(mem_read_data),
        .alu_out(em_alu_out),
        .rd(em_rd),
        .control_unit_signal(em_control_signal),
        .o_mem_read_data(mw_mem_read_data),
        .o_alu_out(mw_alu_out),
        .o_rd(mw_rd),
        .o_control_unit_signal(mw_control_signal)
    );
    
    // ===========================
    // WRITEBACK STAGE
    // ===========================
    
    // Writeback Mux (selects between memory data and ALU result)
    writeback_mux wb_mux(
        .mem_data(mw_mem_read_data),
        .execute_data(mw_alu_out),
        .control_unit_signal(mw_control_signal),
        .writeback_data(writeback_data)
    );

endmodule
