module counter_18bit(clk, count_en, clear,width, height, r_addr, count_done);
  
  /*********CounterInterface*******/
  input wire clk, clear, count_en;
  input wire [15:0] width, height;
  output reg [17:0] r_addr;
  output reg count_done;
  /********************************/
  
  wire[17:0] limit;
  assign limit = width*height*3/2 + 2;
  always@(posedge clk)
  begin
    if(clear)
      begin
         r_addr <= 18'b0;
         count_done <= 0;
      end
    
    if(r_addr == limit)
      count_done <= 1;
    else if(count_en)
      r_addr <= r_addr + 1;
  end
  
endmodule 