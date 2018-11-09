module reorder_datapath(clk, rst, ldenR, ldenG, ldenB, selWdata, count_en_wr,
         count_en_rd, selAdd, wr_done, rd_done, w_addr, r_addr, r_data,  width, height, wdata);
//****************** reorder datapath interface********************
    input wire clk, rst, ldenB, ldenR, ldenG, count_en_rd, count_en_wr;
    input wire [1:0] selAdd, selWdata;
    input wire [15:0] r_data;
    input wire [15:0] width, height;
    output wire wr_done, rd_done;
    output wire[17:0] w_addr, r_addr;
    output wire [15:0] wdata;
//*****************************************************************
    wire[17:0] start_addr = width*height*3/2;
    wire[17:0] wlimit = width*height*3 ;
    wire[17:0] rlimit = width*height/2 ;
    counter_18bit write_counter(.start_addr(start_addr), .limit(wlimit),.clk(clk),
     .count_en(count_en_wr), .clear(rst), .r_addr(w_addr), .count_done(wr_done));
    
    wire [17:0] r_addr_base;
    counter_18bit read_counter(.start_addr(18'b0), .limit(rlimit),.clk(clk),
     .count_en(count_en_rd), .clear(rst), .r_addr(r_addr_base), .count_done(rd_done));

    wire [17:0] g_offset = width * height / 18'd2 ;
    wire [17:0] b_offset = g_offset * 18'd2 ;

    assign r_addr =((selAdd == 2'b00) ? 18'd0 : (selAdd == 2'b01) ? g_offset : b_offset) + r_addr_base;

    wire [15:0] r_out, g_out, b_out;
    register_16_bit r_reg(.load_en(ldenR), .clk(clk), .data_in(r_data), .data_out(r_out));
    register_16_bit g_reg(.load_en(ldenG), .clk(clk), .data_in(r_data), .data_out(g_out));
    register_16_bit b_reg(.load_en(ldenB), .clk(clk), .data_in(r_data), .data_out(b_out));

    assign wdata = (selWdata == 2'b0) ? {g_out[7:0],r_out[7:0]} : (selWdata == 2'b01) ? {b_out[15:8], g_out[15:8]}:
                    {r_out[15:8], b_out[7:0]};
    
endmodule