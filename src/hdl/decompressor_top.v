`default_nettype none
module decompressor_top#(
		parameter AW = 20,
		parameter DW = 16,
		parameter IMAGE_WIDTH = 320,
		parameter IMAGE_HEIGHT = 240,
		parameter ADDR_REORDER_PIXEL = 0,
		parameter ADDR_ORDER_PIXEL = 115200
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
	reg				sram_vga_start;
	// Write-only port
	wire [AW-1:0]	sram_vga_waddr;
	wire [DW-1:0]	sram_vga_wdata;
	wire 			sram_vga_wr_enable;
	
	// ***** signal for reorder_pixel *****
	wire 			reorder_done;
	wire [AW-1:0]	reorder_raddr;
	wire [DW-1:0]	reorder_rdata;
	
	// Write-only port
	wire [AW-1:0]	reorder_waddr;
	wire [DW-1:0]	reorder_wdata;
	wire 			reorder_wr_enable;
	
	// **** signal for decompressor_top ****
	wire [2:0] sram_sel;
	
	reg [2:0] state;
	localparam 	STATE_SRAM_VGA = 0,
				STATE_REORDER = 1;
				
	localparam 	SEL_SRAM_VGA = 0,
				SEL_REORDER = 1;
				
	// ================================= Internal Logic =============================
	assign sram_sel = state;
	always@(posedge clk)begin
		if(reset)begin
			state <= STATE_REORDER;
			sram_vga_start <=0;
		end 
		else begin
			sram_vga_start <=0;
			case(state)
				STATE_REORDER:begin
					if(reorder_done)begin
						state <= STATE_SRAM_VGA;
						sram_vga_start <=1;
					end
				end
				STATE_SRAM_VGA:begin
					
				end
			endcase
		end
	end
	
	
	// **** This section code used for other phase of project ****
	// 
	// 
	// ***********************************************************
	
	// **** Mux for select module that granted for access to sram ****
	always@(*)begin
		case (sram_sel)
			SEL_SRAM_VGA: begin // sram_vga_controller
				sram_raddr		<= sram_vga_raddr		;
				sram_waddr		<= sram_vga_waddr   	;
				sram_wdata		<= sram_vga_wdata   	;
				sram_wr_enable	<= sram_vga_wr_enable	;
			end
			SEL_REORDER: begin // pixel_reorder
				sram_raddr		<= reorder_raddr	;
				sram_waddr		<= reorder_waddr   	;
				sram_wdata		<= reorder_wdata   	;
				sram_wr_enable	<= reorder_wr_enable;
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
	assign reorder_rdata = sram_rdata;
	
	yuv_to_rgb_conversion#(
		.ADDR_REORDER_PIXEL(ADDR_REORDER_PIXEL),
		.ADDR_ORDER_PIXEL(ADDR_ORDER_PIXEL),
		.W(IMAGE_WIDTH),
		.H(IMAGE_HEIGHT))
	yuv_to_rgb_conversion(
		.clk		(clk),
		.reset		(reset),
		
		.start		(start), // 
		.done		(reorder_done),
	// *********** SRAM Interface Signals ****************************
	// Read-only port
		.raddr		(reorder_raddr),
		.rdata		(reorder_rdata),
	// Write-only port
		.waddr		(reorder_waddr),
		.wdata		(reorder_wdata),
		.wr_enable	(reorder_wr_enable)
);

	//sram_vga_controller#(
	sram_vga_controller#(
		.AW(AW),
		.DW(DW),
		.START_ADDR(ADDR_ORDER_PIXEL),
		.IMAGE_WIDTH(IMAGE_WIDTH),
		.IMAGE_HEIGHT(IMAGE_HEIGHT)
	)
	sram_vga_controller
	(
		.reset	(reset	),
		.clk	(clk	),
		
		.start	(sram_vga_start	),
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
