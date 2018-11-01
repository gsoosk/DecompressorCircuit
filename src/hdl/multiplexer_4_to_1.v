module multiplexer_4_to_1(in0, in1, in2, in3, sel, out);
  
  /*********Multiplexer Interface*******/
  input wire in0, in1, in2, in3;
  input wire [1:0] sel;
  output wire out;
  /************************************/
  
  wire [1:0] sel_not;
  not(sel_not[0], sel[0]);
  not(sel_not[1], sel[1]);
  
  wire [3:0] q;
  and(q[0], in0, sel_not[0], sel_not[1]);
  and(q[1], in1, sel[0], sel_not[1]);
  and(q[2], in2, sel_not[0], sel[1]);
  and(q[3], in3, sel[0], sel[1]);
  
  or(out, q[0], q[1], q[2], q[3]);
  
endmodule