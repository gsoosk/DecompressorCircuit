`default_nettype none
module pixel_reorder#(
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
	output wire wr_enable
);
	
	wire wr_done, rd_done;
	wire ldenB, ldenR, ldenG, count_en_rd, count_en_wr;
	wire [1:0] selAdd, selwdata;
	reorder_datapath dp(.clk(clk), .rst(reset), .ldenR(ldenR), .ldenG(ldenG), .ldenB(ldenB), .selWdata(selwdata),
	 	.count_en_wr(count_en_wr), .count_en_rd(count_en_rd), .selAdd(selAdd), .wr_done(wr_done), .rd_done(rd_done),
		.w_addr(waddr), .r_addr(raddr), .r_data(rdata),  .width(W[15:0]), .height(H[15:0]), .wdata(wdata));
	
	reorder_controller c(.clk(clk), .rst(reset), .wr_done(wr_done) , .start(start), .done(done), .selAdd(selAdd), .ldenR(ldenR), .ldenG(ldenG), .ldenB(ldenB), 
		.selwdata(selwdata), .wr_enable(wr_enable), .count_en_wr(count_en_wr), .count_en_rd(count_en_rd));
endmodule

