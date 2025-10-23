`include "define.vh"

module tripple_mux(plus_4, jump, ra, sel, out);
input [31:0] plus_4,jump, ra;
input [6:0] sel;
output reg [31:0] out;

always @ (*) begin

    case (sel)
        `OPCODE_JAL: begin
            out = jump;
        end
        `OPCODE_JALR: begin
            out = ra;
        end
        default: begin
            out = plus_4;
        end
    endcase

end

endmodule
