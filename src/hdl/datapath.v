module datapath(clk, count_en, clear, len0, len1, len2, sel, width, height, vga_start, cnt_done, r_addr, rdata, mux_out);
  /******DataPath Interface*****/
  input wire clk, count_en, clear, len0, len1, len2, vga_start;
  input wire [1:0] sel;
  input wire [15:0] width, height;
  input wire [15:0] rdata;
  output wire cnt_done;
  output wire [17:0] r_addr;
  output wire [23:0] mux_out;
  /****************************/
  counter_18bit cn(.clk(clk), .count_en(count_en), .clear(clear),
             .width(width), .height(height), .r_addr(r_addr), .count_done(cnt_done));

  wire [15:0] rout0;
  register_16_bit r0(.load_en(len0), .clk(clk), .data_in(rdata), .data_out(rout0));
  
  wire [15:0] rout1;
  register_16_bit r1(.load_en(len1), .clk(clk), .data_in(rdata), .data_out(rout1));
  
  wire [15:0] rout2;
  register_16_bit r2(.load_en(len2), .clk(clk), .data_in(rdata), .data_out(rout2));
  
  multiplexer mux(.in0({8'b0, width}), .in1({8'b0, height}), .in2({rout1[7:0], rout0}),
                  .in3({rout2, rout1[15:8]}), .sel(sel), .out(mux_out));
  
  
  
  
endmodule