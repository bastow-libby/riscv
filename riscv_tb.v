`timescale 1us/100ns
module riscv_tb();

reg clk, rst;
riscv dut(.clk(clk), .rst(rst));


initial begin
clk = 1'b0;
rst = 1'b0;

#2;

rst = 1'b1;
#10; 
rst = 1'b0;

end

always 
#5 clk =~clk;

endmodule
