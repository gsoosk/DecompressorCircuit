module counter_18bit(start_addr, limit, clk, count_en, clear, r_addr, count_done);
  
  /*********CounterInterface*******/
  input wire clk, clear, count_en;
  input wire [17:0] start_addr;
  input wire[17:0] limit;
  output reg [17:0] r_addr;
  output reg count_done;
  /********************************/
  
  always@(posedge clk)
  begin
    if(clear)
      begin
         r_addr <= start_addr;
         count_done <= 0;
      end
    
    if(r_addr == limit)
      count_done <= 1;
    else if(count_en)
      r_addr <= r_addr + 1;
  end
  
endmodule 