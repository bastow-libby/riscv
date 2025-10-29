module if_id_reg(inst_encoding, pc, o_inst_encoding, o_pc, stall_cs, clk);

    input [31:0] inst_encoding;
    input [31:0] pc;
    input stall_cs, clk;

    output reg [31:0] o_inst_encoding;
    output reg [31:0] o_pc;

    always @ (posedge clk) begin

        case (stall_cs)

            1'b0:        o_inst_encoding = inst_encoding;
            default:    o_inst_encoding = o_inst_encoding;

        endcase

    end

endmodule


