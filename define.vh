// define.vh - instruction set stuff

// for 10/15, implement add, sub, addi
// maybe add or, and, and JAL (if i can figure it out)

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
`define OPCODE_R_TYPE   7`b0110011
`define OPCODE_I_TYPE   7`b0010011
`define OPCODE_SW       7`b0100011
`define OPCODE_LW       7`b0000011
`define OPCODE_B_TYPE   7`b1100011
`define OPCODE_LUI      7`b0110111
`define OPCODE_AUIPC    7`b0010111
`define OPCODE_JAL      7`b1101111

// ------------------------------------------
// funct3 field
// ------------------------------------------
`define FUNCT3_ADD      3`b000
`define FUNCT3_SUB      3`b000
`define FUNCT3_ANDI     3`b111

// ------------------------------------------
// funct7 field - for R type instructions
// ------------------------------------------
`define FUNCT7_ADD      7`b0000000
`define FUNCT7_SUB      7`b0100000

// Maybe implement ALU control bits from 5b of funct7 + funct3

`endif
