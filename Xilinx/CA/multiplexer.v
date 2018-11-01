module multiplexer(in0, in1, in2, in3, sel, out);
  
  input wire [23:0] in0, in1, in2, in3;
  input wire [1:0] sel;
  output wire [23:0] out;
  
  genvar index;  
  generate  
  for (index=0; index < 24; index=index+1)  
    begin : mult
      multiplexer_4_to_1 m(in0[index], in1[index], in2[index], in3[index], sel, out[index]);
    end  
  endgenerate  
  
endmodule