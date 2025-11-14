`timescale 1us/100ns
`include "define.vh"

module decode (
    input [31:0]        instruction_encoding,
    output reg [6:0]    opcode,
    output reg [2:0]    funct3,
    output reg [6:0]    funct7,
    output reg [4:0]    rs1,
    output reg [4:0]    rs2,
    output reg [4:0]    rd,
    output reg [31:0]   imm,
    output reg [3:0]    alu_op,
    output reg [7:0]    control_unit_signal,
    output reg flush_cs
);

always @ (*) begin
    opcode = instruction_encoding[6:0];
    rd     = instruction_encoding[11:7];
    funct3 = instruction_encoding[14:12];
    rs1    = instruction_encoding[19:15];
    rs2    = instruction_encoding[24:20];
    funct7 = instruction_encoding[31:25];
    imm    = 32'b0;

    // NOP code
    alu_op = 4'b0000;

    // R&I-Type Instructions
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
                `FUNCT3_SLLI:   alu_op = `ALU_SLLI;
                `FUNCT3_SRLI: begin
                    if (funct7 == `FUNCT7_SRLI)
                        alu_op = `ALU_SRLI;
                    else
                        alu_op = `ALU_SRAI;
                end
                default:		alu_op = 4'bxxxx;
            endcase
        end
        `OPCODE_LUI: begin
            alu_op = `ALU_ADDI;
            rs1 = 5'b00000;
        end
        // S-Type
        `OPCODE_S_TYPE: begin
            case (funct3)
                `FUNCT3_SW:     alu_op = `ALU_ADDI;
            endcase
        end
        // L-Type
        `OPCODE_L_TYPE: begin
            case (funct3)
                `FUNCT3_LW:     alu_op = `ALU_ADDI;
            endcase
        end
    endcase

    // Immediate-Value (Not utilized by R-Type Instructions)
    case (opcode)
        `OPCODE_JAL: begin
            imm =       {{11{instruction_encoding[31]}}, instruction_encoding[31], instruction_encoding[19:12], instruction_encoding[20], instruction_encoding[30:21], 1'b0};
        end
        `OPCODE_I_TYPE: begin
            case (funct3)
                `FUNCT3_SLLI, `FUNCT3_SRLI: begin
                imm =   {{27{instruction_encoding[27]}}, instruction_encoding[24:20]};
                end
            default: begin
                imm =   {{20{instruction_encoding[31]}}, instruction_encoding[31:20]};
            end
            endcase
        end
        `OPCODE_L_TYPE: begin
            imm =       {{20{instruction_encoding[31]}}, instruction_encoding[31:20]};
        end
        `OPCODE_LUI: begin // Cheating a bit for this instruction
            imm =       {{instruction_encoding[31:12]}, 12'b0};
        end
        `OPCODE_JALR: begin
            imm =       {{20{instruction_encoding[31]}}, instruction_encoding[31:20]};
        end
        `OPCODE_S_TYPE: begin
            imm =       {{20{instruction_encoding[31]}}, instruction_encoding[31:25], instruction_encoding[11:7]};
        end
        `OPCODE_L_TYPE: begin
            imm =       {{20{instruction_encoding[31]}}, instruction_encoding[31:20]};
        end
        `OPCODE_B_TYPE: begin
            imm =       {{20{instruction_encoding[31]}}, instruction_encoding[12], instruction_encoding[10:5], instruction_encoding[4:1], instruction_encoding[11]};
        end
    endcase

    // ---
    // Control Unit Logic
    // ---

    // This outputs a 8-bit control signal in the format of
    // register_write_enable, alu_src, writeback, mem_read, mem_write_enable, branch, jump, jalr
    // Bit[0] is the MOST significant bit, weird.

    control_unit_signal = 8'b00000000;

    case (opcode)
        `OPCODE_R_TYPE: begin
            control_unit_signal =   8'b00000001;
        end
        `OPCODE_I_TYPE, `OPCODE_LUI, `OPCODE_AUIPC: begin
            control_unit_signal =   8'b00000011;
        end
        `OPCODE_L_TYPE: begin
            control_unit_signal =   8'b00001111;
        end
        `OPCODE_S_TYPE: begin
            control_unit_signal =   8'b00010010;
        end
        `OPCODE_B_TYPE: begin
            control_unit_signal =   8'b00100000;
        end
        `OPCODE_JAL: begin
            control_unit_signal =   8'b01000001;
        end
        `OPCODE_JALR: begin
            control_unit_signal =   8'b11000011;
        end
    endcase

    // Jump flush control signal

    flush_cs = ((opcode == `OPCODE_JAL) | (opcode == `OPCODE_JALR));

end

endmodule
