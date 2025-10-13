`timescale 1us/100ns
module orgate(
input b, 
input a, 
output c);

assign c = a | b;

endmodule
