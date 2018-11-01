`define default_net_type none

module decompressor_top#(
		parameter AW = 20,
		parameter DW = 16,
		parameter IMAGE_WIDTH = 320,
		parameter IMAGE_HEIGHT = 240
		)
	(
		input wire reset,
		input wire clk,
		
		input wire start, 
		output wire done,
		
		// *********** SRAM Interface Signals ****************************
		// Read-only port
		output reg [AW-1:0]	sram_raddr,
		input wire [DW-1:0] sram_rdata,
		// Write-only port
		output reg [AW-1:0]	sram_waddr,
		output reg [DW-1:0]	sram_wdata,
		output reg 			sram_wr_enable,
		// ************* VGA Controller Interface Signals *****************
		output wire vgastart,
		output wire [7:0] r,
		output wire [7:0] g,
		output wire [7:0] b
	);	
	
	
	
	// ======================= Define internal signals ==========================
		
	// ***** signal for sram_vga_controller *****
	wire [AW-1:0]	sram_vga_raddr;
	wire [DW-1:0]	sram_vga_rdata;
	
	// Write-only port
	wire [AW-1:0]	sram_vga_waddr;
	wire [DW-1:0]	sram_vga_wdata;
	wire 			sram_vga_wr_enable;
	
	
	// **** signal for decompressor_top ****
	wire [2:0] sram_sel;
	
	// ================================= Internal Logic =============================
	assign sram_sel = 3'h0; // for CA2
	
	
	// **** This section code used for other phase of project ****
	// 
	// 
	// ***********************************************************
	
	// **** Mux for select module that granted for access to sram ****
	always@(*)begin
		case (sram_sel)
			3'h0: begin // sram_vga_controller
				sram_raddr		<= sram_vga_raddr		;
				sram_waddr		<= sram_vga_waddr   	;
				sram_wdata		<= sram_vga_wdata   	;
				sram_wr_enable	<= sram_vga_wr_enable	;
			end
			default:begin
				sram_raddr		<= 0;
				sram_waddr		<= 0;
				sram_wdata		<= 0;
				sram_wr_enable	<= 0;
			end
		endcase
	end
	
	// ====================== sram_vga_controller module ===================
	assign sram_vga_rdata = sram_rdata;
	
	sram_vga_controller#(
		.AW(AW),
		.DW(DW),
		.IMAGE_WIDTH(IMAGE_WIDTH),
		.IMAGE_HEIGHT(IMAGE_HEIGHT)
	)
	sram_vga_controller
	(
		.reset	(reset	),
		.clk	(clk	),
		
		.start	(start	),
		.done	(done	),
	// *********** SRAM Interface Signals ****************************
	// Read-only port
		.raddr		(sram_vga_raddr		),
		.rdata		(sram_vga_rdata		),
	// Write-only port
		.waddr		(sram_vga_waddr		),
		.wdata		(sram_vga_wdata		),
		.wr_enable	(sram_vga_wr_enable	),	
		
	// ************* VGA Controller Interface Signals *****************
		.vgastart	(vgastart	),
		.r			(r			),
		.g			(g			),
		.b			(b			)
	);
	
endmodule
