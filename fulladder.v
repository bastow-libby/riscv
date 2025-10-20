`timescale 1us/100ns
module fulladder(
    input a, 
    input b,
    input cin, 
    output reg s,
    output reg cout
);

always @(*) begin
    case({a, b, cin})
        3'b000: begin
            //do the stuff in here
            s = 1'b0;
            cout = 1'b0;
        end
        3'b001: begin
            //do the stuff in here
            s = 1'b1;
            cout = 1'b0;
        end
        3'b010: begin
            //do the stuff in here
            s = 1'b1;
            cout = 1'b0;
        end
        3'b011: begin
            //do the stuff in here
            s = 1'b0;
            cout = 1'b1;
        end
        3'b100: begin
            //do the stuff in here
            s = 1'b1;
            cout = 1'b0;
        end
        3'b101: begin
            //do the stuff in here
            s = 1'b0;
            cout = 1'b1;
        end
        3'b110: begin
            //do the stuff in here
            s = 1'b0;
            cout = 1'b1;
        end
        3'b111: begin
            //do the stuff in here
            s = 1'b1;
            cout = 1'b1;
        end
        default: begin
            s = 1'b0;
            cout = 1'b0;
        end
    endcase
end

endmodule
