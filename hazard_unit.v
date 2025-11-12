// Hazard unit inside decode phase of pipeline
// Detects the conditions EX.RD == ID.RS1/RS2 when EX.mem_read == 1
// Inserts NOP with stall

module hazard_unit(
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] execute_rd,
    input [4:0] mem_rd,
    input execute_mem_read,
    input mem_mem_read,
    output reg stall
);

always @(*) begin

    stall = 1'b0;

    if (execute_mem_read | mem_mem_read) begin

        if (rs1 == execute_rd && execute_rd != 5'b0)
            stall = 1'b1;
        if (rs2 == execute_rd && execute_rd != 5'b0)
            stall = 1'b1;

    end

end

endmodule
