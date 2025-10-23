`include "define.vh"

module write_mux(jump, alu_out, dmem_out, sel, out);
input [31:0] jump, alu_out, dmem_out;
input [6:0] sel;
output reg [31:0] out;

always @ (*) begin

    case (sel)
        `OPCODE_JAL: begin
            out = jump;
        end
        `OPCODE_S_TYPE: begin
            out = dmem_out;
        end
        `OPCODE_L_TYPE: begin
            out = dmem_out;
        end
        default: begin
            out = alu_out;
        end
    endcase

end

endmodule
