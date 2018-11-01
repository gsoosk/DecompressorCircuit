module tb_ca2;
`include "param.v"

parameter AW  = 18;
parameter DW  = 16;

reg reset, clk ;

reg start;
wire done;

// *********** SRAM Interface Signals ****************************
// Read-only port
wire [AW-1:0]	sram_raddr;
wire [DW-1:0]	sram_rdata;
// Write-only port
wire [AW-1:0]	sram_waddr;
wire [DW-1:0]	sram_wdata;
wire 			sram_wr_enable;
// ************* VGA Controller Interface Signals *****************
wire vgastart;
wire [7:0] r;
wire [7:0] g;
wire [7:0] b;

initial begin
	//Initialize signal
	reset = 0;
	clk = 0;
	start = 0;
	@(posedge clk);
	// Reset system
	@(posedge clk);
	reset = 1;
	@(posedge clk);
	reset = 0;
	// Starting .... 
	@(posedge clk);
	start = 1;
	@(posedge clk);
	start = 0;
	// Waiting for done signal
	@(posedge done); 
	
	repeat(10) @(posedge clk);
	$stop;
end

// 50MHz clock generation
always begin
	clk = #10 !clk;
end
		
decompressor_top#(
	.AW(AW),
	.DW(DW),
	.IMAGE_WIDTH(IMAGE_WIDTH),
	.IMAGE_HEIGHT(IMAGE_HEIGHT)
)
decompressor_top
(
	.reset	(reset	),
	.clk	(clk	),
	
	.start	(start	),
	.done	(done	),
// *********** SRAM Interface Signals ****************************
// Read-only port
	.sram_raddr		(sram_raddr		),
	.sram_rdata		(sram_rdata		),
// Write-only port
	.sram_waddr		(sram_waddr		),
	.sram_wdata		(sram_wdata		),
	.sram_wr_enable	(sram_wr_enable	),	
	
// ************* VGA Controller Interface Signals *****************
	.vgastart	(vgastart	),
	.r			(r			),
	.g			(g			),
	.b			(b			)
);

	
// SRAM-Emulator instant	
SRAM_Emulator#(
	.INIT_SIZE(SRAM_INIT_SIZE),
	.INIT_START(SRAM_INIT_START),
	.AW(AW),
	.DW(DW),
	.INIT_FILE_NAME(INIT_FILE_NAME)
)
SRAM_Emulator
(
	.clk(clk),
// Read-only port
	.raddr		(sram_raddr),
	.rdata		(sram_rdata),
// Write-only port
	.waddr		(sram_waddr),
	.wdata		(sram_wdata),
	.wr_enable	(sram_wr_enable)
);

// VGA-Emulator instant
VGA_Emulator
VGA_Emulator
(
	.clk(clk),
	.start(vgastart),
	
	.r(r),
	.g(g),
	.b(b)
);

endmodule
