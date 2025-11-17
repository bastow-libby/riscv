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
        // testcase 4: add x3, x4, x5
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

        // testcase 4: add x3, x4, x5
        instruction_encoding = 32'h005201b3;
        @(negedge clk);
        if (opcode !== `OPCODE_R_TYPE) tb.error = 60;
        if (funct3 !== `FUNCT3_ADD_SUB) tb.error = 61;
        if (funct7 !== 7'b0000000) tb.error = 62;
        if (rs1 !== 5'b00100) tb.error = 63;
        if (rs2 !== 5'b00101) tb.error = 64;
        if (rd !== 5'b00011) tb.error = 65;
        if (alu_op !== `ALU_ADD) tb.error = 66;
        if (control_unit_signal[0] !== 1) tb.error = 67;
        if (control_unit_signal[1] !== 0) tb.error = 68;
        if (control_unit_signal[2] !== 0) tb.error = 69;
        if (control_unit_signal[3] !== 0) tb.error = 70;
        if (control_unit_signal[4] !== 0) tb.error = 71;
        if (control_unit_signal[5] !== 0) tb.error = 72;
        if (control_unit_signal[6] !== 0) tb.error = 73;
        if (control_unit_signal[7] !== 0) tb.error = 74;
        if (flush_cs !== 0) tb.error = 75;

        // testcase 5: sub x7, x8, x9
        instruction_encoding = 32'h409403b3;
        @(negedge clk);
        if (opcode !== `OPCODE_R_TYPE) tb.error = 76;
        if (funct3 !== `FUNCT3_ADD_SUB) tb.error = 77;
        if (funct7 !== 7'b0100000) tb.error = 78;
        if (rs1 !== 5'b01000) tb.error = 79;
        if (rs2 !== 5'b01001) tb.error = 80;
        if (rd !== 5'b00111) tb.error = 81;
        if (alu_op !== `ALU_SUB) tb.error = 82;
        if (control_unit_signal[0] !== 1) tb.error = 83;
        if (control_unit_signal[1] !== 0) tb.error = 84;
        if (control_unit_signal[2] !== 0) tb.error = 85;
        if (control_unit_signal[3] !== 0) tb.error = 86;
        if (control_unit_signal[4] !== 0) tb.error = 87;
        if (control_unit_signal[5] !== 0) tb.error = 88;
        if (control_unit_signal[6] !== 0) tb.error = 89;
        if (control_unit_signal[7] !== 0) tb.error = 90;
        if (flush_cs !== 0) tb.error = 91;

        // testcase 6: xor x10, x11, x12
        instruction_encoding = 32'h00c5c533;
        @(negedge clk);
        if (opcode !== `OPCODE_R_TYPE) tb.error = 92;
        if (funct3 !== `FUNCT3_XOR) tb.error = 93;
        if (funct7 !== 7'b0000000) tb.error = 94;
        if (rs1 !== 5'b01011) tb.error = 95;
        if (rs2 !== 5'b01100) tb.error = 96;
        if (rd !== 5'b01010) tb.error = 97;
        if (alu_op !== `ALU_XOR) tb.error = 98;
        if (control_unit_signal[0] !== 1) tb.error = 99;
        if (control_unit_signal[1] !== 0) tb.error = 100;
        if (control_unit_signal[2] !== 0) tb.error = 101;
        if (control_unit_signal[3] !== 0) tb.error = 102;
        if (control_unit_signal[4] !== 0) tb.error = 103;
        if (control_unit_signal[5] !== 0) tb.error = 104;
        if (control_unit_signal[6] !== 0) tb.error = 105;
        if (control_unit_signal[7] !== 0) tb.error = 106;
        if (flush_cs !== 0) tb.error = 107;

        // testcase 7: or x13, x14, x15
        instruction_encoding = 32'h00f766b3;
        @(negedge clk);
        if (opcode !== `OPCODE_R_TYPE) tb.error = 108;
        if (funct3 !== `FUNCT3_OR) tb.error = 109;
        if (funct7 !== 7'b0000000) tb.error = 110;
        if (rs1 !== 5'b01110) tb.error = 111;
        if (rs2 !== 5'b01111) tb.error = 112;
        if (rd !== 5'b01101) tb.error = 113;
        if (alu_op !== `ALU_OR) tb.error = 114;
        if (control_unit_signal[0] !== 1) tb.error = 115;
        if (control_unit_signal[1] !== 0) tb.error = 116;
        if (control_unit_signal[2] !== 0) tb.error = 117;
        if (control_unit_signal[3] !== 0) tb.error = 118;
        if (control_unit_signal[4] !== 0) tb.error = 119;
        if (control_unit_signal[5] !== 0) tb.error = 120;
        if (control_unit_signal[6] !== 0) tb.error = 121;
        if (control_unit_signal[7] !== 0) tb.error = 122;
        if (flush_cs !== 0) tb.error = 123;

        // testcase 8: and x16, x17, x18
        instruction_encoding = 32'h0128f833;
        @(negedge clk);
        if (opcode !== `OPCODE_R_TYPE) tb.error = 124;
        if (funct3 !== `FUNCT3_AND) tb.error = 125;
        if (funct7 !== 7'b0000000) tb.error = 126;
        if (rs1 !== 5'b10001) tb.error = 127;
        if (rs2 !== 5'b10010) tb.error = 128;
        if (rd !== 5'b10000) tb.error = 129;
        if (alu_op !== `ALU_AND) tb.error = 130;
        if (control_unit_signal[0] !== 1) tb.error = 131;
        if (control_unit_signal[1] !== 0) tb.error = 132;
        if (control_unit_signal[2] !== 0) tb.error = 133;
        if (control_unit_signal[3] !== 0) tb.error = 134;
        if (control_unit_signal[4] !== 0) tb.error = 135;
        if (control_unit_signal[5] !== 0) tb.error = 136;
        if (control_unit_signal[6] !== 0) tb.error = 137;
        if (control_unit_signal[7] !== 0) tb.error = 138;
        if (flush_cs !== 0) tb.error = 139;

        // testcase 9: lw x2, 8(x3)
        instruction_encoding = 32'h0081a103;
        @(negedge clk);
        if (opcode !== `OPCODE_L_TYPE) tb.error = 140;
        if (funct3 !== `FUNCT3_LW) tb.error = 141;
        if (rs1 !== 5'b00011) tb.error = 142;
        if (rd !== 5'b00010) tb.error = 143;
        if (imm !== 32'h00000008) tb.error = 144;
        if (alu_op !== `ALU_ADDI) tb.error = 145;
        if (control_unit_signal[0] !== 1) tb.error = 146;
        if (control_unit_signal[1] !== 1) tb.error = 147;
        if (control_unit_signal[2] !== 1) tb.error = 148;
        if (control_unit_signal[3] !== 1) tb.error = 149;
        if (control_unit_signal[4] !== 0) tb.error = 150;
        if (control_unit_signal[5] !== 0) tb.error = 151;
        if (control_unit_signal[6] !== 0) tb.error = 152;
        if (control_unit_signal[7] !== 0) tb.error = 153;
        if (flush_cs !== 0) tb.error = 154;

        // testcase 10: sw x4, 12(x5)
        instruction_encoding = 32'h0042a623;
        @(negedge clk);
        if (opcode !== `OPCODE_S_TYPE) tb.error = 155;
        if (funct3 !== `FUNCT3_SW) tb.error = 156;
        if (rs1 !== 5'b00101) tb.error = 157;
        if (rs2 !== 5'b00100) tb.error = 158;
        if (imm !== 32'h0000000C) tb.error = 159;
        if (alu_op !== `ALU_ADDI) tb.error = 160;
        if (control_unit_signal[0] !== 0) tb.error = 161;
        if (control_unit_signal[1] !== 1) tb.error = 162;
        if (control_unit_signal[2] !== 0) tb.error = 163;
        if (control_unit_signal[3] !== 0) tb.error = 164;
        if (control_unit_signal[4] !== 1) tb.error = 165;
        if (control_unit_signal[5] !== 0) tb.error = 166;
        if (control_unit_signal[6] !== 0) tb.error = 167;
        if (control_unit_signal[7] !== 0) tb.error = 168;
        if (flush_cs !== 0) tb.error = 169;

        // testcase 11: jal x1, 0x100
        instruction_encoding = 32'h100000ef;
        @(negedge clk);
        if (opcode !== `OPCODE_JAL) tb.error = 170;
        if (rd !== 5'b00001) tb.error = 171;
        if (imm !== 32'h00000100) tb.error = 172;
        if (control_unit_signal[0] !== 1) tb.error = 174;
        if (control_unit_signal[1] !== 0) tb.error = 175;
        if (control_unit_signal[2] !== 0) tb.error = 176;
        if (control_unit_signal[3] !== 0) tb.error = 177;
        if (control_unit_signal[4] !== 0) tb.error = 178;
        if (control_unit_signal[5] !== 0) tb.error = 179;
        if (control_unit_signal[6] !== 1) tb.error = 180;
        if (control_unit_signal[7] !== 0) tb.error = 181;
        if (flush_cs !== 1) tb.error = 182;

        // testcase 12: jalr x1, 4
        instruction_encoding = 32'h004000e7;
        @(negedge clk);
        if (opcode !== `OPCODE_JALR) tb.error = 183;
        if (funct3 !== 3'b000) tb.error = 184;
        if (rs1 !== 5'b00000) tb.error = 185;
        if (rd !== 5'b00001) tb.error = 186;
        if (imm !== 32'h00000004) tb.error = 187;
        if (control_unit_signal[0] !== 1) tb.error = 189;
        if (control_unit_signal[1] !== 1) tb.error = 190;
        if (control_unit_signal[2] !== 0) tb.error = 191;
        if (control_unit_signal[3] !== 0) tb.error = 192;
        if (control_unit_signal[4] !== 0) tb.error = 193;
        if (control_unit_signal[5] !== 0) tb.error = 194;
        if (control_unit_signal[6] !== 1) tb.error = 195;
        if (control_unit_signal[7] !== 1) tb.error = 196;
        if (flush_cs !== 1) tb.error = 197;

        // testcase 13: beq x6, x7, 0x20
        instruction_encoding = 32'h02730063;
        @(negedge clk);
        if (opcode !== `OPCODE_B_TYPE) tb.error = 198;
        if (funct3 !== `FUNCT3_BEQ) tb.error = 199;
        if (rs1 !== 5'b00110) tb.error = 200;
        if (rs2 !== 5'b00111) tb.error = 201;
        if (imm !== 32'h00000040) tb.error = 202;
        if (control_unit_signal[0] !== 0) tb.error = 204;
        if (control_unit_signal[1] !== 0) tb.error = 205;
        if (control_unit_signal[2] !== 0) tb.error = 206;
        if (control_unit_signal[3] !== 0) tb.error = 207;
        if (control_unit_signal[4] !== 0) tb.error = 208;
        if (control_unit_signal[5] !== 1) tb.error = 209;
        if (control_unit_signal[6] !== 0) tb.error = 210;
        if (control_unit_signal[7] !== 0) tb.error = 211;
        if (flush_cs !== 0) tb.error = 212;

        // testcase 14: bne x8, x9, 0x10
        instruction_encoding = 32'h00941863;
        @(negedge clk);
        if (opcode !== `OPCODE_B_TYPE) tb.error = 213;
        if (funct3 !== `FUNCT3_BNE) tb.error = 214;
        if (rs1 !== 5'b01000) tb.error = 215;
        if (rs2 !== 5'b01001) tb.error = 216;
        if (imm !== 32'h00000020) tb.error = 217;
        if (control_unit_signal[0] !== 0) tb.error = 219;
        if (control_unit_signal[1] !== 0) tb.error = 220;
        if (control_unit_signal[2] !== 0) tb.error = 221;
        if (control_unit_signal[3] !== 0) tb.error = 222;
        if (control_unit_signal[4] !== 0) tb.error = 223;
        if (control_unit_signal[5] !== 1) tb.error = 224;
        if (control_unit_signal[6] !== 0) tb.error = 225;
        if (control_unit_signal[7] !== 0) tb.error = 226;
        if (flush_cs !== 0) tb.error = 227;

        // testcase 15: blt x10, x11, 0x8
        instruction_encoding = 32'h00b54463;
        @(negedge clk);
        if (opcode !== `OPCODE_B_TYPE) tb.error = 228;
        if (funct3 !== `FUNCT3_BLT) tb.error = 229;
        if (rs1 !== 5'b01010) tb.error = 230;
        if (rs2 !== 5'b01011) tb.error = 231;
        if (imm !== 32'h00000010) tb.error = 232;
        if (control_unit_signal[0] !== 0) tb.error = 234;
        if (control_unit_signal[1] !== 0) tb.error = 235;
        if (control_unit_signal[2] !== 0) tb.error = 236;
        if (control_unit_signal[3] !== 0) tb.error = 237;
        if (control_unit_signal[4] !== 0) tb.error = 238;
        if (control_unit_signal[5] !== 1) tb.error = 239;
        if (control_unit_signal[6] !== 0) tb.error = 240;
        if (control_unit_signal[7] !== 0) tb.error = 241;
        if (flush_cs !== 0) tb.error = 242;

        // testcase 16: bge x12, x13, 0x14
        instruction_encoding = 32'h00d65a63;
        @(negedge clk);
        if (opcode !== `OPCODE_B_TYPE) tb.error = 243;
        if (funct3 !== `FUNCT3_BGE) tb.error = 244;
        if (rs1 !== 5'b01100) tb.error = 245;
        if (rs2 !== 5'b01101) tb.error = 246;
        if (imm !== 32'h00000028) tb.error = 247;
        if (control_unit_signal[0] !== 0) tb.error = 249;
        if (control_unit_signal[1] !== 0) tb.error = 250;
        if (control_unit_signal[2] !== 0) tb.error = 251;
        if (control_unit_signal[3] !== 0) tb.error = 252;
        if (control_unit_signal[4] !== 0) tb.error = 253;
        if (control_unit_signal[5] !== 1) tb.error = 254;
        if (control_unit_signal[6] !== 0) tb.error = 255;
        if (control_unit_signal[7] !== 0) tb.error = 256;
        if (flush_cs !== 0) tb.error = 257;

        #5;
        if (tb.error == 0)
            $display("decode_tb passed.");
        $finish;

    end

endmodule
