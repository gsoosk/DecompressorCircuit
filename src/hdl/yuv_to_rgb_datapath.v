module yuv_to_rgb_datapath(clk, rst, ldenY, ldenU, ldenV, selWdata, count_en_wr, selNum, 
         count_en_rd, selAdd, wr_done, rd_done, w_addr, r_addr, r_data,  width, height, wdata, selPixel,
            ldR, ldG, ldB);
//****************** reorder datapath interface********************
    input wire clk, rst, ldenY, ldenU, ldenV, count_en_rd, count_en_wr, selPixel, ldR, ldG, ldB;
    input wire [1:0] selAdd, selWdata, selNum;
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

    wire [17:0] u_offset = width * height / 18'd2 ;
    wire [17:0] v_offset = u_offset * 18'd2 ;

    assign r_addr =((selAdd == 2'b00) ? 18'd0 : (selAdd == 2'b01) ? u_offset : v_offset) + r_addr_base;

    wire [15:0] y_out, u_out, v_out;
    register_16_bit y_reg(.load_en(ldenY), .clk(clk), .data_in(r_data), .data_out(y_out));
    register_16_bit u_reg(.load_en(ldenU), .clk(clk), .data_in(r_data), .data_out(u_out));
    register_16_bit v_reg(.load_en(ldenV), .clk(clk), .data_in(r_data), .data_out(v_out));

    wire [7:0] y_pixel, u_pixel, v_pixel;
    assign y_pixel = (selPixel ? y_out[7:0] : y_out[15:8]);
    assign u_pixel = (selPixel ? u_out[7:0] : u_out[15:8]);
    assign v_pixel = (selPixel ? v_out[7:0] : v_out[15:8]);
    
    wire signed [25:0] y_min, u_min, v_min;
    assign y_min =  y_pixel - 26'd16;
    assign u_min =  u_pixel - 26'd128;
    assign v_min =  v_pixel - 26'd128;

    wire signed [25:0] y_num, u_num, v_num;
    assign y_num = 26'd76284 * y_min;
    assign u_num = u_min * (selNum == 2'd0 ? 26'd0 : selNum == 2'd1 ? -26'd25624 : 26'd132251) ;
    assign v_num = v_min * (selNum == 2'd0 ? 26'd104595 : selNum == 2'd1 ? -26'd53281 : 26'd0) ;

    wire signed [25:0] to_div;
    assign to_div = y_num + u_num + v_num ;

    wire signed [8:0] div; 
    wire signed [25:0] divBig;
    assign divBig = (to_div / 26'd65536);
    assign div = divBig[8:0];

    wire signed [8:0] filter;
    assign filter = div[8] == 1'b1 ? 9'd0 : div > 9'd255 ? 9'd255 : div ;
    
    wire [7:0] uFilter;
    assign uFilter = filter;

    wire[7:0] r_out, g_out, b_out;
    register_8_bit r_reg(.load_en(ldR), .clk(clk), .data_in(uFilter), .data_out(r_out));
    register_8_bit g_reg(.load_en(ldG), .clk(clk), .data_in(uFilter), .data_out(g_out));
    register_8_bit b_reg(.load_en(ldB), .clk(clk), .data_in(uFilter), .data_out(b_out));

    assign wdata = selWdata == 2'd0 ? {g_out, r_out} : selWdata == 2'd1 ? {b_out, g_out} : {r_out, b_out};

    
endmodule