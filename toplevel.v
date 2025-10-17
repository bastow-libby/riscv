`timescale 1us/100ns
module toplevel();

reg clk, rst;

riscv dut(.clk(clk), .rst(rst));

initial begin
    clk = 0;
    rst = 0;

    #2;
    rst = 1;
    #10;
    rst = 0;

end

always
#5 clk = ~clk;


endmodule
