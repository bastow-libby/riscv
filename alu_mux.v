module alu_mux(r2, imm, sel, out);
input [31:0] r2,imm;
input [6:0] sel;
output [31:0] out;

assign out = (sel == 7'b0010011) ? imm : r2;

endmodule

