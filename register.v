module register(do1, do2, A2, we, din);

genvar i;
generate

  for(i = 0; i < 32; i = i + 1) begin
    dff rgstr(.q(dout[i]), .d(we ? din[i] : dout[i]), .clk(clk), .rst(rst));
  end
endgenerate

endmodule

