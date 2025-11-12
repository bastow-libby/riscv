// define.vh - instruction set stuff

`ifndef DEFINE_VH
`define DEFINE_VH

// ------------------------------------------
// 6 different types of instruction codes
// R-Type: Contains funct7 and funct3 + opcode
// I-Type: Contains funct3 + opcode
// S-Type: Contains funct3 + special opcode
// B-Type: Contains funct3 + opcode
// U-Type: Contains special opcode
// J-Type: Contains special opcode
// ------------------------------------------
`define OPCODE_R_TYPE   7'b0110011
`define OPCODE_I_TYPE   7'b0010011
`define OPCODE_S_TYPE   7'b0100011
`define OPCODE_L_TYPE   7'b0000011
`define OPCODE_B_TYPE   7'b1100011
`define OPCODE_LUI      7'b0110111
`define OPCODE_AUIPC    7'b0010111
`define OPCODE_JAL      7'b1101111
`define OPCODE_JALR     7'b1100111
// ------------------------------------------
// funct3 field
// ------------------------------------------
`define FUNCT3_ADD_SUB  3'b000
`define FUNCT3_AND      3'b111
`define FUNCT3_OR       3'b110
`define FUNCT3_XOR      3'b100
`define FUNCT3_ADDI     3'b000
`define FUNCT3_SLLI     3'b001
`define FUNCT3_SRLI     3'b101
`define FUNCT3_SW       3'b010
`define FUNCT3_LW       3'b010
`define FUNCT3_BEQ      3'b000
`define FUNCT3_BNE      3'b001
`define FUNCT3_BLT      3'b100
`define FUNCT3_BGE      3'b101
// ------------------------------------------
// funct7 field - for R type instructions
// ------------------------------------------
`define FUNCT7_ADD      7'b0000000
`define FUNCT7_SUB      7'b0100000
`define FUNCT7_AND      7'b0000000
`define FUNCT7_OR       7'b0000000
`define FUNCT7_XOR      7'b0000000
`define FUNCT7_SRLI     7'b0000000
`define FUNCT7_SRAI     7'b0100000
// ------------------------------------------
// ALU op codes
// ------------------------------------------
`define ALU_ADD         4'b0000
`define ALU_SUB         4'b0001
`define ALU_AND         4'b0010
`define ALU_OR          4'b0011
`define ALU_XOR         4'b0100
`define ALU_ADDI        4'b1011
`define ALU_SLLI        4'b1100
`define ALU_SRLI        4'b1101
`define ALU_SRAI        4'b1110

`endif
