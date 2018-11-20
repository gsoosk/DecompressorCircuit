module yuv_to_rgb_controller(clk, rst, start, done, selAdd, ldenY, ldenU, ldenV, count_en_rd, count_en_wr, selPixel, selNum, ldR, ldG, ldB, selWdata,
                            wr_enable, wr_done);
//****************** yuv_tp_rgb controller interface********************
    input wire start, wr_done, clk, rst;
    
    output reg [1:0] selAdd, selNum, selWdata;
    output reg ldenY, ldenU, ldenV, count_en_rd, selPixel, ldR, ldG, ldB, wr_enable, count_en_wr, done; 
//**********************************************************************

reg [3:0] ns, ps;

parameter[3:0] IDLE = 4'd0 , START = 4'd1, LOAD_Y = 4'd2, LOAD_U = 4'd3, LOAD_V = 4'd4,
                CALC_R = 4'd5, CALC_G = 4'd6, CALC_B = 4'd7, CALC_R2 = 4'd8, CALC_G2 = 4'd9,
                CALC_B2 = 4'd10, WRITE_BG = 4'd11, DONE = 4'd12;

always@(ps)
begin
  selAdd <= 2'd0;
  selNum <= 2'd0;
  selWdata <= 2'd0;
  ldenY <= 1'b0;
  ldenU <= 1'b0;
  ldenV <= 1'b0;
  count_en_rd <= 1'b0;
  selPixel <= 1'b0;
  ldR <= 1'b0;
  ldG <= 1'b0;
  ldB <= 1'b0;
  wr_enable <= 1'b0;
  count_en_wr <= 1'b0;
  done <= 1'b0;
  case (ps)
    START: selAdd <= 2'd0;
    LOAD_Y: begin ldenY <= 1'b1; selAdd <= 2'd1; end
    LOAD_U: begin ldenU <= 1'b1; selAdd <= 2'd2;end
    LOAD_V: begin ldenV <= 1'b1; count_en_rd <= 1'b1;end
    CALC_R: begin selNum <= 2'd0; ldR <= 1'b1; selPixel <= 1'b1; end
    CALC_G: begin selNum <= 2'd1; ldG <= 1'b1; selPixel <= 1'b1;  end
    CALC_B: begin selNum <= 2'd2; selPixel <= 1'b1; ldB <= 1'b1; selWdata <= 2'd0; wr_enable <= 1'b1; count_en_wr <= 1'b1;  end
    CALC_R2: begin selPixel <= 1'b0; selNum <= 2'd0; ldR <= 1'b1; end
    CALC_G2: begin selWdata <= 2'd2; wr_enable <= 1'b1; count_en_wr <= 1'b1; selPixel <= 1'b0; selNum <= 2'd1; ldG <= 1'b1; end
    CALC_B2: begin selPixel <= 1'b0; selNum <= 2'd2; ldB <= 1'b1; end
    WRITE_BG: begin selWdata <= 2'd1; wr_enable <= 1'b1; count_en_wr <= 1'b1; end
    DONE: done <= 1'b1;
    default : begin selAdd <= 2'd0; selNum <= 2'd0; selWdata <= 2'd0; ldenY <= 1'b0; ldenU <= 1'b0; ldenV <= 1'b0; count_en_rd <= 1'b0; selPixel <= 1'b0; ldR <= 1'b0;
              ldG <= 1'b0; ldB <= 1'b0; wr_enable <= 1'b0; count_en_wr <= 1'b0; done <= 1'b0; end
  endcase
end

always@(ps or start or wr_done)
begin
    case(ps)
        IDLE: ns <= start ? START : IDLE ;
        START: ns <= LOAD_Y;
        LOAD_Y: ns <= LOAD_U;
        LOAD_U: ns <= LOAD_V;
        LOAD_V: ns <= CALC_R;
        CALC_R: ns <= CALC_G;
        CALC_G: ns <= CALC_B;
        CALC_B: ns <= CALC_R2;
        CALC_R2: ns <= CALC_G2;
        CALC_G2: ns <= CALC_B2;
        CALC_B2: ns <= WRITE_BG;
        WRITE_BG: ns <= wr_done ? DONE : LOAD_Y;
        DONE: ns <= IDLE;
    endcase
end

always@(posedge clk, posedge rst)
begin
    if(rst)
        ps <= 4'd0;
    else if(clk)
        ps <= ns;
end

endmodule