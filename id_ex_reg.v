module if_id_reg();

    input [4:0] rs1;
    input [4:0] rs2;
    input [4:0] rd;


    always @ (*) begin

        o_inst_encoding = inst_encoding;
        o_pc = pc;

    end

endmodule


