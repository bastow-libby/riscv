`timescale 1us/100ns
`include "./decode.v"
`include "./define.vh"
`include "./test/tb_common.v"

module decode_tb;

    // decode.v module
    // input:
    //  [31:0] instruction_encoding
    // output:
    //  [6:0]   opcode,
    //  [2:0]   funct3,
    //  [6:0]   funct7,
    //  [4:0]   rs1,
    //  [4:0]   rs2,
    //  [4:0]   rd,
    //  [31:0]  imm,
    //  [3:0]   alu_op,
    //  [7:0]   control_unit_signal,
    //          flush_cs

    wire clk;
    wire [31:0] error;

    tb_common #(.CLK_PERIOD(2)) tb (
        .clk(clk),
        .error(error)
    );

    reg [31:0] instruction_encoding;
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [31:0] imm;
    wire [3:0] alu_op;
    wire [7:0] control_unit_signal;
    wire flush_cs;

    decode decoder(
        .instruction_encoding(instruction_encoding),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .imm(imm),
        .alu_op(alu_op),
        .control_unit_signal(control_unit_signal),
        .flush_cs(flush_cs)
    );

    initial begin

        $dumpfile("./test/dumps/decode_tb.lxt");
        $dumpvars(0, decode_tb);

        instruction_encoding = 32'b0;

        // testcase 1: lui x1, 0x60
        // outputs: opcode, rd, imm, alu_op, control_unit_signal, flush_cs
        @(negedge clk);
        instruction_encoding = 32'h000600b7;
        @(negedge clk);
        if (opcode !== `OPCODE_LUI) tb.error = 1;
        if (rd !== 5'b00001) tb.error = 2;
        if (imm != 32'b00000000000001100000000000000000) tb.error = 3;
        if (alu_op !== `ALU_ADDI) tb.error = 4;
        if (control_unit_signal[0] !== 1) tb.error = 5;
        if (control_unit_signal[1] !== 1) tb.error = 6;
        if (control_unit_signal[2] !== 0) tb.error = 7;
        if (control_unit_signal[3] !== 0) tb.error = 8;
        if (control_unit_signal[4] !== 0) tb.error = 9;
        if (control_unit_signal[5] !== 0) tb.error = 10;
        if (control_unit_signal[6] !== 0) tb.error = 11;
        if (control_unit_signal[7] !== 0) tb.error = 12;
        if (flush_cs !== 0) tb.error = 13;

        // testcase 2: addi x6, x5, 0x10
        // outputs: opcode, funct3, rs1, rd, imm, alu_op, unit_control_signal, flush_cs
        instruction_encoding = 32'h01028313;
        @(negedge clk);
        if (opcode !== `OPCODE_I_TYPE) tb.error = 13;
        if (funct3 !== `FUNCT3_ADDI) tb.error = 14;
        if (rs1 !== 5'b00101) tb.error = 15;
        if (rd !== 5'b00110) tb.error = 16;
        if (imm !== 32'h00000010) tb.error = 17;
        if (alu_op !== `ALU_ADDI) tb.error = 18;
        if (control_unit_signal[0] !== 1) tb.error = 19;
        if (control_unit_signal[1] !== 1) tb.error = 20;
        if (control_unit_signal[2] !== 0) tb.error = 21;
        if (control_unit_signal[3] !== 0) tb.error = 22;
        if (control_unit_signal[4] !== 0) tb.error = 23;
        if (control_unit_signal[5] !== 0) tb.error = 24;
        if (control_unit_signal[6] !== 0) tb.error = 25;
        if (control_unit_signal[7] !== 0) tb.error = 26;
        if (flush_cs !== 0) tb.error = 27;

        // testcase 3: slli x5, x11, 31
        // outputs: opcode, funct3, funct7, rs1, rd, imm, alu_op, unit_control_signal, flush_cs
        instruction_encoding = 32'h01f59293;
        @(negedge clk);
        if (opcode !== `OPCODE_I_TYPE) tb.error = 28;
        if (funct3 !== `FUNCT3_SLLI) tb.error = 29;
        if (funct7 !== 7'b0000000) tb.error = 30;
        if (rs1 !== 5'b01011) tb.error = 31;
        if (rd !== 5'b00101) tb.error = 32;
        if (imm !== 32'h0000001F) tb.error = 33;
        if (alu_op !== `ALU_SLLI) tb.error = 34;
        if (control_unit_signal[0] !== 1) tb.error = 35;
        if (control_unit_signal[1] !== 1) tb.error = 36;
        if (control_unit_signal[2] !== 0) tb.error = 37;
        if (control_unit_signal[3] !== 0) tb.error = 38;
        if (control_unit_signal[4] !== 0) tb.error = 39;
        if (control_unit_signal[5] !== 0) tb.error = 40;
        if (control_unit_signal[6] !== 0) tb.error = 41;
        if (control_unit_signal[7] !== 0) tb.error = 42;
        if (flush_cs !== 0) tb.error = 43;

        // testcase 3: srli x21, x23, 1
        // outputs: opcode, funct3, funct7, rs1, rd, imm, alu_op, unit_control_signal, flush_cs
        instruction_encoding = 32'h001bda93;
        @(negedge clk);
        if (opcode !== `OPCODE_I_TYPE) tb.error = 44;
        if (funct3 !== `FUNCT3_SRLI) tb.error = 45;
        if (funct7 !== 7'b0000000) tb.error = 46;
        if (rs1 !== 5'b10111) tb.error = 47;
        if (rd !== 5'b10101) tb.error = 48;
        if (imm !== 32'h00000001) tb.error = 49;
        if (alu_op !== `ALU_SRLI) tb.error = 50;
        if (control_unit_signal[0] !== 1) tb.error = 51;
        if (control_unit_signal[1] !== 1) tb.error = 52;
        if (control_unit_signal[2] !== 0) tb.error = 53;
        if (control_unit_signal[3] !== 0) tb.error = 54;
        if (control_unit_signal[4] !== 0) tb.error = 55;
        if (control_unit_signal[5] !== 0) tb.error = 56;
        if (control_unit_signal[6] !== 0) tb.error = 57;
        if (control_unit_signal[7] !== 0) tb.error = 58;
        if (flush_cs !== 0) tb.error = 59;

        // TODO(dan): Implement remaining instructions
        // testcase 4: add
        // testcase 5: sub
        // testcase 6: xor
        // testcase 7: or
        // testcase 8: and
        // testcase 9: lw
        // testcase 10: sw
        // testcase 11: jal
        // testcase 12: jalr
        // testcase 13: beq
        // testcase 14: bne
        // testcase 15: blt
        // testcase 16: bge

        #5;
        if (tb.error == 0)
            $display("decode_tb passed.");
        $finish;

    end

endmodule
