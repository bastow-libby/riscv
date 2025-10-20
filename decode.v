`timescale 1us/100ns
`include "define.vh"

// TODO: Add write enable?

module decode (
    input  [31:0] inst_encoding,   // instruction bits that are encoded
    output reg [6:0] opcode, // outputs to be sent out to each module
    output reg [2:0] funct3,
    output reg [6:0] funct7,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [4:0] rd,
    output reg [31:0] imm,
    output reg writeback,
    output reg we,
    output reg [3:0] alu_op      // alu control signal,
);

    always @ (*) begin
        opcode = inst_encoding[6:0];
        rd     = inst_encoding[11:7];
        funct3 = inst_encoding[14:12];
        rs1    = inst_encoding[19:15];
        rs2    = inst_encoding[24:20];
        funct7 = inst_encoding[31:25];
        imm    = 32'b0; // default 

        // NOP code
        alu_op = 4'b0000;

        // R&I-Type Instructions (ALU Opcode selection)
        case (opcode)
            `OPCODE_R_TYPE: begin
                case (funct3)
                    `FUNCT3_ADD_SUB: begin
                        if (funct7 == `FUNCT7_SUB)
                            alu_op = `ALU_SUB;
                        else
                            alu_op = `ALU_ADD;
                    end
                    `FUNCT3_AND:	alu_op = `ALU_AND;
                    `FUNCT3_OR:		alu_op = `ALU_OR;
                    default:		alu_op = 4'bxxxx;
                endcase
            end
            // I-type instructions
            `OPCODE_I_TYPE: begin
                case (funct3)
                    `FUNCT3_ADDI:	alu_op = `ALU_ADDI;
                    default:		alu_op = 4'bxxxx;
                endcase
            end
        endcase

        // Immediate-Value (Not utilized by R-Type Instructions)
        case (opcode)
            `OPCODE_JAL: begin
                imm =       {{11{inst_encoding[31]}}, inst_encoding[31], inst_encoding[19:12], inst_encoding[20], inst_encoding[30:25], inst_encoding[24:21], 1'b0};
            end
            `OPCODE_I_TYPE: begin
                imm =       {{20{inst_encoding[31]}}, inst_encoding[31:20]};
            end
            default: imm =  {{20{inst_encoding[31]}}, inst_encoding[31:20]};
        endcase

        // Register Writeback
        case (opcode)
            // Add other opcodes here that need writeback
            `OPCODE_LUI, `OPCODE_JAL: begin
                writeback = 1'b1;
            end
            default: writeback = 1'b0;
        endcase

        // Write Enable TODO: FIX
        case (opcode)
            // Add other opcodes here that need we
            `OPCODE_I_TYPE: begin
                we = 1'b1;
            end
            default: we = 1'b0;
        endcase

    end

endmodule
