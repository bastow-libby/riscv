// Fowarding unit inside of decode phase of the pipeline
// Prevents data hazards by modifying behavior using signals when
// 1. Instruction in MEM stage wants to write to register and the result from the EX stage is the value being written back (addi).
//      register_write_enable & !writeback
// 2. Instruction in MEM stage wants to write the value from the MEM stage (lw).
//      register_write_enable & writeback

module forwarding_unit_branch(
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] mem_rd,
    input mem_stage_register_write_enable,
    input mem_stage_writeback,
    output reg [1:0] fub_cs_1,
    output reg [1:0] fub_cs_2
);

always @(*) begin
    
    if (mem_stage_register_write_enable == 1'b1) begin
        if (rs1 == mem_rd) begin // MEM.RD == ID.RS1
            if (mem_stage_writeback == 1'b0) // Forward ALU output
                fub_cs_1 = 2'b10;
            else // Foward memory read output
                fub_cs_1 = 2'b01;
        end
        else if (rs2 == mem_rd) begin // MEM.RD == ID.RS2
            if (mem_stage_writeback == 1'b0) // Forward ALU output
                fub_cs_2 = 2'b10;
            else // Foward memory read output
                fub_cs_2 = 2'b01;
        end
    end
    else begin // No forwarding needed
        fub_cs_1 = 2'b00;
        fub_cs_2 = 2'b00;
    end
    
end

endmodule
