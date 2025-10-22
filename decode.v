`timescale 1us/100ns
`include "define.vh"

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
    output reg [3:0] alu_op,      // alu control signal
    output reg is_jump,              // signal for JAL/JALR instructions
    output reg mem_read,             // signal for load instructions
    output reg mem_write             // signal for store instructions
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
        is_jump = 1'b0; // default not a jump
        mem_read = 1'b0; // default not a load
        mem_write = 1'b0; // default not a store

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
            `OPCODE_LUI: begin // cheating for this one
                alu_op = `ALU_ADDI;
                rs1 = 5'b00000;
            end
            `OPCODE_JAL: begin
                is_jump = 1'b1;
                alu_op = 4'b0000; // JAL doesn't use ALU
            end
	    `OPCODE_JALR: begin
		is_jump = 1'b1;
		alu_op = 4'b0000;
	    end
            `OPCODE_LW: begin
                mem_read = 1'b1;
                alu_op = `ALU_ADD; // calculate address = rs1 + imm
            end
            `OPCODE_SW: begin
                mem_write = 1'b1;
                alu_op = `ALU_ADD; // calculate address = rs1 + imm
            end

        endcase

        // Immediate-Value (Not utilized by R-Type Instructions)
        case (opcode)
            `OPCODE_JAL: begin
                // JAL immediate: imm[20|10:1|11|19:12] from inst[31:12]
                // Result: imm[20:0] = {inst[31], inst[19:12], inst[20], inst[30:21], 1'b0}
                imm =       {{11{inst_encoding[31]}}, inst_encoding[31], inst_encoding[19:12], inst_encoding[20], inst_encoding[30:21], 1'b0};
            end
            `OPCODE_I_TYPE: begin
                imm =       {{20{inst_encoding[31]}}, inst_encoding[31:20]};
            end
            `OPCODE_LUI: begin // Cheating a bit for this instruction
                imm =       {{inst_encoding[31:12]}, 12'b0};
            end
	    `OPCODE_JALR: begin
		imm =       {{20{inst_encoding[31]}}, inst_encoding[31:20]};
	     end
            `OPCODE_LW: begin
                // I-type immediate for loads
                imm =       {{20{inst_encoding[31]}}, inst_encoding[31:20]};
            end
            `OPCODE_SW: begin
                // S-type immediate for stores: imm[11:5] = inst[31:25], imm[4:0] = inst[11:7]
                imm =       {{20{inst_encoding[31]}}, inst_encoding[31:25], inst_encoding[11:7]};
            end
            default: imm =  {{20{inst_encoding[31]}}, inst_encoding[31:20]};
        endcase

        // Register Writeback
        case (opcode)
            // Add other opcodes here that need writeback
            `OPCODE_LUI, `OPCODE_JAL, `OPCODE_JALR, `OPCODE_LW: begin
                writeback = 1'b1;
            end
            default: writeback = 1'b0;
        endcase
        // Write Enable
        case (opcode)
            `OPCODE_R_TYPE, `OPCODE_I_TYPE, `OPCODE_LUI, `OPCODE_JAL, `OPCODE_JALR, `OPCODE_LW: begin
                we = 1'b1;
            end
            default: we = 1'b0;
        endcase

    end

endmodule
