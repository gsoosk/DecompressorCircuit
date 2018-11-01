module sram_vga_controller#(
		parameter AW = 20,
		parameter DW = 16,
		parameter START_ADDR = 0,
		parameter IMAGE_WIDTH = 320,
		parameter IMAGE_HEIGHT = 240)
	(
		input wire reset,
		input wire clk,
		
		input wire start, // 
		output wire done,
		
		// *********** SRAM Interface Signals ****************************
		// Read-only port
		output wire [AW-1:0]	raddr,
		input wire	[DW-1:0]	rdata,
		// Write-only port
		output wire [AW-1:0]	waddr,
		output wire [DW-1:0]	wdata,
		output wire 			wr_enable,
		// ************* VGA Controller Interface Signals *****************
		output wire vgastart,
		output wire [7:0] r,
		output wire [7:0] g,
		output wire [7:0] b
	);	
	
	localparam W = IMAGE_WIDTH;
	localparam H = IMAGE_HEIGHT;
	
	assign waddr = 0;
	assign wdata = 0;
	assign wr_enable = 0;
	
	// Add your code here ... .
	wire count_en, count_done, clear, len0, len1, len2;
	wire [1:0] sel;
	wire [23:0] mux_out;
	controller c(.clk(clk),
				 .rst(reset),
				 .start(start),
				 .count_done(count_done),
				 .clear(clear),
				 .count_en(count_en),
				 .done(done),
				 .vga_start(vgastart),
				 .len0(len0), 
				 .len1(len1), 
				 .len2(len2), 
				 .sel(sel));
	
	datapath dp(.clk(clk),
				.count_en(count_en), 
				.clear(clear), 
				.len0(len0), 
				.len1(len1), 
				.len2(len2), 
				.sel(sel), 
				.width(IMAGE_WIDTH[15:0]), 
				.height(IMAGE_HEIGHT[15:0]),  
				.cnt_done(count_done), 
				.r_addr(raddr),
				.rdata(rdata),
				.mux_out(mux_out));
	
	assign r = mux_out[7:0];
	assign g = mux_out[15:8];
	assign b = mux_out[23:16];


	
endmodule
