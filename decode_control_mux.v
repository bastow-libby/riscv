//Dan is pretty sure this mux flushes everything
module decode_control_mux(
    input stall,
    input flush,
    input [3:0] alu_op,
    input [7:0] control_unit_signal,
    output reg [3:0] o_alu_op,
    output reg [7:0] o_control_unit_signal
);

always @ (*) begin

    o_alu_op = alu_op;
    o_control_unit_signal = control_unit_signal;

    if (control_unit_signal[7] == 1'b1 | stall == 1'b1 | flush == 1'b1) begin

        o_alu_op = 4'b0;
        o_control_unit_signal = 8'b0;

    end

end

endmodule
