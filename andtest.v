`timescale 1us/100ns
module andtest(
input clk, 
input rst, 
output jerry);

wire tom;

dff flop(.q(tom), .d(jerry), .clk(clk), .rst(rst));

assign jerry = ~tom;

endmodule
