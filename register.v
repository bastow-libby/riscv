// 32x32-bit register file
module register(a0, a1, wr, write_enable, din, clk, rst, q0, q1);
    input [31:0] din;
    input [4:0] wr;
    input clk, rst, write_enable;

    input [4:0] a0;
    input [4:0] a1;

    output [31:0] q0,q1;

    wire [31:0] r[0:31];

    // Hardcode first reg to 0
    assign r[0] = 32'b0;
    genvar i;
    generate
        for(i = 1; i < 32; i = i + 1) begin
            register32 rgstr(.din(din), .write_enable((|(wr^i)&write_enable) ? 1'b0 : 1'b1), .dout(r[i]), .clk(clk), .rst(rst));
        end
    endgenerate

    assign q0 = r[a0];
    assign q1 = r[a1];

endmodule

