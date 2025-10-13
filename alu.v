`timescale 1us/100ns
//Attempt at ALU using case statements
module alu(
input [31:0] a,b,                   
input [3:0] func,// ALU Selection
output [31:0] out);


reg [31:0] result;
assign out = result;

//I'm sort of worried abt the cases not being complete...
//adder 
wire [31:0] add_result;
wire cout;
adder32 alu_adder(.A(a), .B(b), .Cin(1'b0), .S(add_result), .Cout(cout));

always @(*) begin
	case(func)
		4'b0000: begin
			//adder
			
			result = add_result;
			end
		
        	4'b0001: begin
			//subtracter
           		result = a - b;
			end

        	4'b0100: begin
			// logic shift left
           		result = a<<1;
			end

         	4'b0101: begin
			// logical shift right
           		result = a>>1;
			end

         	4'b0110: begin 
			// ROL
           		result = {a[30:0],a[31]};
			end

         	4'b0111: begin
			// ROR
           		result = {a[0],a[30:1]};
			end

          	4'b1000: begin
			//and
           		result = a & b;
			end

          	4'b1001: begin
			//or
           		result = a | b;
			end

          	4'b1010: begin
			//xor 
           		result = a ^ b;
			end

          	4'b1011: begin
			//nor
           		result = ~(a | b);
			end

          	4'b1100: begin
			//nand 
           		result = ~(a & b);
			end
          	4'b1101: begin
			//xnor
           		result = ~(a ^ b);
			end 

		default: begin
			
			result = 32'h00000000;
		end
	endcase
end



endmodule
