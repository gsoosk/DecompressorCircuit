module reorder_controller(clk, rst, wr_done , start, done, selAdd, ldenR, ldenG, ldenB,
                            selwdata, wr_enable, count_en_wr, count_en_rd);
//***********reoder controller interface***************//
input wire clk, rst;
input wire wr_done, start;
output reg done, ldenB, ldenR, ldenG, count_en_rd, count_en_wr, wr_enable;
output reg [1:0] selAdd, selwdata;
//****************************************************//

reg [2:0] ps, ns;

parameter[2:0] IDLE = 3'd0 , START = 3'd1, LOAD_R = 3'd2, LOAD_G = 3'd3, WR_GR_LD_B = 3'd4,
                WR_RB = 3'd5, WR_BG = 3'd6, DONE = 3'd7;

always@(ps)
begin
    done <= 1'b0;
    ldenB <= 1'b0;
    ldenR <= 1'b0;
    ldenG <= 1'b0;
    count_en_rd <= 1'b0;
    count_en_wr <= 1'b0;
    wr_enable <= 1'b0;
    selAdd <= 2'b00;
    selwdata <= 2'b00;
    case (ps)
      START : selAdd <= 2'b00;
      LOAD_R : begin ldenR <= 1'b1; selAdd <= 2'b01; end
      LOAD_G : begin ldenG <= 1'b1; selAdd <= 2'b10; end
      WR_GR_LD_B : begin ldenB <= 1'b1; selwdata <= 2'b00 ; wr_enable <= 1'b1; count_en_wr <= 1'b1; end
      WR_RB : begin selwdata <= 2'b10; wr_enable <= 1'b1; count_en_wr <= 1'b1; end
      WR_BG : begin selwdata <= 2'b01; wr_enable <= 1'b1; selAdd <= 2'b00; count_en_rd <= 1'b1; count_en_wr <=1'b1; end 
      DONE: done <= 1'b1;
      default: begin  done <= 1'b0; ldenB <= 1'b0; ldenR <= 1'b0; ldenG <= 1'b0; count_en_rd <= 1'b0;
                      count_en_wr <= 1'b0; wr_enable <= 1'b0; selAdd <= 2'b00; selwdata <= 2'b00; end
    endcase
end

always@(ps or start or wr_done)
begin
   case (ps)
    IDLE : ns <= start ? START : IDLE ;
    START : ns <= LOAD_R ;
    LOAD_R : ns <= LOAD_G ;
    LOAD_G : ns <= WR_GR_LD_B ;
    WR_GR_LD_B : ns <= WR_RB ;
    WR_RB : ns <= WR_BG ;
    WR_BG : ns <= wr_done ? DONE : LOAD_R ;
    DONE : ns <= IDLE;
    default: ns <= ps ;       
   endcase
    
end

always@(posedge clk, posedge rst) begin
    if(rst)
      ps <= 3'd0;
    else if(clk)
      ps <= ns;
end
endmodule