// mostly from maikmerten repository

`ifndef TB_COMMON_V
`define TB_COMMON_V

module tb_common #(parameter CLK_PERIOD = 2) (
    output reg clk,
    output reg [31:0] error
);

    initial clk = 0;
    always # (CLK_PERIOD / 2) clk = !clk;

    initial error = 0;
    always @(error) begin
        if (error !== 0) begin
            $display("Test Failed. Error at %0d.", error);
            // # (CLK_PERIOD * 2);
            // $finish;
        end
    end

endmodule

`endif