`timescale 1us/100ns
module genadder(A, B, S, Cin, Cout);
input [31:0]A;
input [31:0]B;
input Cin;
output [31:0]S;
output Cout;
wire [32:0] internal_carry;

genvar i;

generate

    for(i = 0; i < 32; i = i + 1) begin
        fulladder U (.a(A[i]), .b(B[i]), .cin(internal_carry[i]), .s(S[i]), .cout(internal_carry[i+1]));
    end

endgenerate

assign internal_carry[0] = Cin;
assign Cout = internal_carry[32];

endmodule


