module mux_TB();
  reg [23:0] in0, in1, in2, in3;
  reg [1:0] sel;
  wire [23:0] out;
  
  initial 
    begin
      #100 in0 = 24'd134;
      #0 in1 = 24'd897;
      #0 in2 = 24'd123;
      #0 in3 = 24'd15;
      #10 sel = 2'd0;
      #10 sel = 2'd1;
      #10 sel = 2'd2;
      #10 sel = 2'd3;
      #10 sel = 2'd0;
    end
  
  multiplexer uut(in0, in1, in2, in3, sel, out);
endmodule