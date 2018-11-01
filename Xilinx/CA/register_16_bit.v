module register_16_bit(load_en, clk, data_in, data_out);
  /*****register_16_bit Interface *******/
  input wire load_en , clk ;
  input wire [15:0] data_in;
  output reg [15:0] data_out;
  /**************************************/
  
  always@(posedge clk)
  begin 
    if(load_en)
      data_out <= data_in;
    else
      data_out <= data_out;
  end

endmodule

