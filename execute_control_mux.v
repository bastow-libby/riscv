module execute_control_mux(
    input flush,
    input [7:0] control_unit_signal,
    output reg [7:0] o_control_unit_signal
);

always @(*) begin

    o_control_unit_signal = control_unit_signal;
    if (flush == 1'b1)
        o_control_unit_signal = 8'b0;

end

endmodule
