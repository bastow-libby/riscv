// Calculates PC target for JALR and Branching and outputs target based on control signal.

module pc_unit(
    input [31:0] pc,
    input [31:0] rs1,
    input [31:0] imm,
    input is_jalr,
    output reg [31:0] target_address
);

always @(*) begin
    target_address = ((is_jalr) ? (rs1 + imm) : ((imm << 1) + pc));
end

endmodule
