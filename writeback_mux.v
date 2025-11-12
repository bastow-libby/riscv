module writeback_mux(
    input [31:0] mem_data,
    input [31:0] execute_data,
    input [7:0] control_unit_signal,
    output reg [31:0] writeback_data
);

always @(*) begin

    writeback_data = 32'b0;

    if (control_unit_signal[2] == 1'b1) // lw
        writeback_data = mem_data;
    else
        writeback_data = execute_data;

end

endmodule
