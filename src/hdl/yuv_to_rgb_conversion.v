`default_nettype none
module yuv_to_rgb_conversion#(
	parameter ADDR_REORDER_PIXEL = 0,
	parameter ADDR_ORDER_PIXEL = 115200,
	parameter W = 320,
	parameter H = 240,
	parameter DW = 16,
	parameter AW = 18)
(
	input wire clk,
	input wire reset,
	input wire start, // 
	output wire done,
	// *********** SRAM Interface Signals ****************************
	// Read-only port
	output wire [AW-1:0]	raddr,
	input wire	[DW-1:0]	rdata,
	// Write-only port
	output wire [AW-1:0]	waddr,
	output wire [DW-1:0]	wdata,
	output wire 			wr_enable
);
	
	
	wire ldenY, ldenU, ldenV, count_en_rd, count_en_wr, wr_done, rd_done, selPixel, ldR, ldG, ldB;
	wire[1:0] selWdata, selNum, selAdd;
	yuv_to_rgb_datapath dp(.clk(clk), .rst(reset), .ldenY(ldenY), .ldenU(ldenU), .ldenV(ldenV), .selWdata(selWdata)
		, .count_en_wr(count_en_wr), .count_en_rd(count_en_rd), .selAdd(selAdd), .wr_done(wr_done), .rd_done(rd_done)
		, .w_addr(waddr), .r_addr(raddr), .r_data(rdata), .width(W[15:0]), .height(H[15:0]), .wdata(wdata), .selPixel(selPixel)
        , .ldR(ldR), .ldG(ldG), .ldB(ldB), .selNum(selNum));
	
	yuv_to_rgb_controller c(.clk(clk), .rst(reset), .start(start), .done(done), .selAdd(selAdd), .ldenY(ldenY), .ldenU(ldenU)
		, .ldenV(ldenV), .count_en_rd(count_en_rd), .count_en_wr(count_en_wr), .selPixel(selPixel), .selNum(selNum), .ldR(ldR)
		, .ldG(ldG), .ldB(ldB), .selWdata(selWdata), .wr_enable(wr_enable), .wr_done(wr_done));

endmodule

