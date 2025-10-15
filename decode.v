`timescale 1us/100ns
`include "define.vh"

// wtf is a rf_we write enable I thought that was something so different

module decode (
    input  [31:0] instruction,   // instruction bits that are encoded
    output reg [6:0] opcode,
    output reg [2:0] funct3,
    output reg [6:0] funct7,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [4:0] rd,
    output reg [31:0] imm,
    output reg [3:0] alu_op      // alu control signal
);

    always @(*) begin
        opcode = instruction[6:0];
        rd     = instruction[11:7];
        funct3 = instruction[14:12];
        rs1    = instruction[19:15];
        rs2    = instruction[24:20];
        funct7 = instruction[31:25];
        imm    = 32'b0; 

        // default ALU thing??? idk google says to do it
        alu_op = 4'b0000;

        case (opcode)
            // -----------------------------------------
            // R-type instructions
            // -----------------------------------------
            `OPCODE_R_TYPE: begin
                case (funct3)
                    `FUNCT3_ADD_SUB: begin
                        if (funct7 == `FUNCT7_SUB)
                            alu_op = `ALU_SUB;
                        else
                            alu_op = `ALU_ADD;
                    end
                    `FUNCT3_AND: alu_op = `ALU_AND;
                    `FUNCT3_OR:  alu_op = `ALU_OR;
                    default:     alu_op = 4'bxxxx;
                endcase
            end

        endcase
    end

endmodule
