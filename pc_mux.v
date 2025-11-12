// Determines the next program counter based on control signals

module pc_mux(
    input [31:0] pc,
    input [31:0] target_address,
    input branch_comp,
    input jump,
    output reg [31:0] next_pc
);

always @(*) begin
    next_pc = ((branch_comp | jump) ? (target_address) : (pc + 4));
end

endmodule