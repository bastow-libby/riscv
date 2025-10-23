`include "define.vh"

module alu_mux(r2, imm, sel, out);
input [31:0] r2,imm;
input [6:0] sel;
output reg [31:0] out;

always @ (*) begin

    case (sel)
        `OPCODE_I_TYPE, `OPCODE_LUI, `OPCODE_S_TYPE, `OPCODE_L_TYPE: begin
            out = imm;
        end
        default: begin
            out = r2;
        end
    endcase

end

endmodule
