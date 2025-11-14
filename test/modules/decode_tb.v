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
    wire integer error;

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
        if (rd !== 5'b00001) tb.error = 1;
        if (imm != 32'b00000000000001100000000000000000) tb.error = 1;
        if (alu_op !== `ALU_ADDI) tb.error = 1;
        if (control_unit_signal[0] !== 0) tb.error = 1; // jalr
        if (control_unit_signal[1] !== 0) tb.error = 1; // jump
        if (control_unit_signal[2] !== 0) tb.error = 1; // branch
        if (control_unit_signal[3] !== 0) tb.error = 1; // mem_write_enable
        if (control_unit_signal[4] !== 0) tb.error = 1; // mem_read
        if (control_unit_signal[5] !== 0) tb.error = 1; // writeback (MemToReg)
        if (control_unit_signal[6] !== 1) tb.error = 1; // alu_src
        if (control_unit_signal[7] !== 1) tb.error = 1; // register_write_enable


        // testcase 1: addi x1, x0, 0x06
        // outputs: opcode, 
        // @(negedge clk);
        // instruction_encoding = 32'h00600093;
        // @(negedge clk);
        // if (opcode !== `OPCODE_I_TYPE) error <= 1;
        // if (funct3 !== `FUNCT3_ADDI) error <= 1;
        // if (funct7 !== `FUNCT7_A)


        #5;
        if (tb.error == 0)
            $display("decode_tb passed.");
        $finish;

    end

endmodule
