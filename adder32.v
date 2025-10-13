`timescale 1us/100ns
module adder32(A, B, S, Cin, Cout);

input [31:0] A;
input [31:0] B;
input Cin;
output [31:0] S, Cout;
wire [31:0] internalcarry;


fulladder B0(.a(A[0]), .b(B[0]), .cin(Cin), .cout(internalcarry[0]), .s(S[0]));
fulladder B1(.a(A[1]), .b(B[1]), .cin(internalcarry[0]), .cout(internalcarry[1]), .s(S[1]));
fulladder B2(.a(A[2]), .b(B[2]), .cin(internalcarry[1]), .cout(internalcarry[2]), .s(S[2]));
fulladder B3(.a(A[3]), .b(B[3]), .cin(internalcarry[2]), .cout(internalcarry[3]), .s(S[3]));
fulladder B4(.a(A[4]), .b(B[4]), .cin(internalcarry[3]), .cout(internalcarry[4]), .s(S[4]));
fulladder B5(.a(A[5]), .b(B[5]), .cin(internalcarry[4]), .cout(internalcarry[5]), .s(S[5]));
fulladder B6(.a(A[6]), .b(B[6]), .cin(internalcarry[5]), .cout(internalcarry[6]), .s(S[6]));
fulladder B7(.a(A[7]), .b(B[7]), .cin(internalcarry[6]), .cout(internalcarry[7]), .s(S[7]));
fulladder B8(.a(A[8]), .b(B[8]), .cin(internalcarry[7]), .cout(internalcarry[8]), .s(S[8]));
fulladder B9(.a(A[9]), .b(B[9]), .cin(internalcarry[8]), .cout(internalcarry[9]), .s(S[9]));
fulladder B10(.a(A[10]), .b(B[10]), .cin(internalcarry[9]), .cout(internalcarry[10]), .s(S[10]));
fulladder B11(.a(A[11]), .b(B[11]), .cin(internalcarry[10]), .cout(internalcarry[11]), .s(S[11]));
fulladder B12(.a(A[12]), .b(B[12]), .cin(internalcarry[11]), .cout(internalcarry[12]), .s(S[12]));
fulladder B13(.a(A[13]), .b(B[13]), .cin(internalcarry[12]), .cout(internalcarry[13]), .s(S[13]));
fulladder B14(.a(A[14]), .b(B[14]), .cin(internalcarry[13]), .cout(internalcarry[14]), .s(S[14]));
fulladder B15(.a(A[15]), .b(B[15]), .cin(internalcarry[14]), .cout(internalcarry[15]), .s(S[15]));
fulladder B16(.a(A[16]), .b(B[16]), .cin(internalcarry[15]), .cout(internalcarry[16]), .s(S[16]));
fulladder B17(.a(A[17]), .b(B[17]), .cin(internalcarry[16]), .cout(internalcarry[17]), .s(S[17]));
fulladder B18(.a(A[18]), .b(B[18]), .cin(internalcarry[17]), .cout(internalcarry[18]), .s(S[18]));
fulladder B19(.a(A[19]), .b(B[19]), .cin(internalcarry[18]), .cout(internalcarry[19]), .s(S[19]));
fulladder B20(.a(A[20]), .b(B[20]), .cin(internalcarry[19]), .cout(internalcarry[20]), .s(S[20]));
fulladder B21(.a(A[21]), .b(B[21]), .cin(internalcarry[20]), .cout(internalcarry[21]), .s(S[21]));
fulladder B22(.a(A[22]), .b(B[22]), .cin(internalcarry[21]), .cout(internalcarry[22]), .s(S[22]));
fulladder B23(.a(A[23]), .b(B[23]), .cin(internalcarry[22]), .cout(internalcarry[23]), .s(S[23]));
fulladder B24(.a(A[24]), .b(B[24]), .cin(internalcarry[23]), .cout(internalcarry[24]), .s(S[24]));
fulladder B25(.a(A[25]), .b(B[25]), .cin(internalcarry[24]), .cout(internalcarry[25]), .s(S[25]));
fulladder B26(.a(A[26]), .b(B[26]), .cin(internalcarry[25]), .cout(internalcarry[26]), .s(S[26]));
fulladder B27(.a(A[27]), .b(B[27]), .cin(internalcarry[26]), .cout(internalcarry[27]), .s(S[27]));
fulladder B28(.a(A[28]), .b(B[28]), .cin(internalcarry[27]), .cout(internalcarry[28]), .s(S[28]));
fulladder B29(.a(A[29]), .b(B[29]), .cin(internalcarry[28]), .cout(internalcarry[29]), .s(S[29]));
fulladder B30(.a(A[30]), .b(B[30]), .cin(internalcarry[29]), .cout(internalcarry[30]), .s(S[30]));
fulladder B31(.a(A[31]), .b(B[31]), .cin(internalcarry[30]), .cout(internalcarry[31]), .s(S[31]));

endmodule
