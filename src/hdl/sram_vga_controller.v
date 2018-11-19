`default_nettype none
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
		output reg done,
		
		// *********** SRAM Interface Signals ****************************
		// Read-only port
		output wire [AW-1:0]	raddr,
		input wire	[DW-1:0]	rdata,
		// Write-only port
		output wire [AW-1:0]	waddr,
		output wire [DW-1:0]	wdata,
		output wire 			wr_enable,
		// ************* VGA Controller Interface Signals *****************
		output reg vgastart,
		output wire [7:0] r,
		output wire [7:0] g,
		output wire [7:0] b
	);	
	
	localparam W = IMAGE_WIDTH;
	localparam H = IMAGE_HEIGHT;
	
	assign waddr = 0;
	assign wdata = 0;
	assign wr_enable = 0;
	
	// Definition of signals 
	reg [23:0] rgb;
	reg vga_start_int ;
	
	reg [15:0] rdata0, rdata1, rdata2;
	reg [1:0] sel_rgb;
	
	reg [31:0] cnt ;
	reg clear_cnt , en_cnt ;
	
	reg [2:0] en_rdata ;
	
	reg eq;
	
	// Definition of state
	reg [7:0] s, ns;
	
	always@(posedge clk)begin
		// state register
		if(reset)
			s <=1;
		else
			s <= ns;
		
		// cnt register
		if(reset || clear_cnt)
			cnt <= START_ADDR;
		else if (en_cnt)
			cnt <= cnt + 1 ;
		
		// rdata0,1,2 register
		if(en_rdata[0])
			rdata0 <= rdata;
		if(en_rdata[1])
			rdata1 <= rdata;
		if(en_rdata[2])
			rdata2 <= rdata;
		
		// rgb mux and register
		case (sel_rgb)
			2'h0:
				rgb <= {8'h0,W[15:0]};
			2'h1:
				rgb <= {8'h0,H[15:0]};
			2'h2:
				rgb <= {rdata1[7:0],rdata0[15:0]};
			2'h3:
				rgb <= {rdata2[15:0],rdata1[15:8]};
			
		endcase
		
		vgastart <= vga_start_int;
	end
	
	// assign output
	assign r = rgb[0+:8];
	assign g = rgb[8+:8];
	assign b = rgb[16+:8];
	
	// assign read address for SRAM
	assign raddr = cnt[AW-1:0];
	
	wire [1:0] a = {start, eq};
	
	// Conbinational logic for control and next state signal
	always@(*)begin
		clear_cnt = start;
		en_rdata[0] = s[2] | s[6];
		en_rdata[1] = s[3] | s[7];
		en_rdata[2] = s[4] & ~eq;
		
		eq = cnt == (START_ADDR+W*H*3/2 + 3);
		
		ns[0] = s[0] &&(~a[1]) || s[4]&a[0];
		ns[1] = s[0] &&(a[1]);
		ns[2] = s[1] ;
		ns[3] = s[2] ;
		ns[4] = s[3] || s[7];
		ns[5] = s[4] && ~a[0];
		ns[6] = s[5];
		ns[7] = s[6];
		
		
		sel_rgb[0]= s[3] | s[6] | s[7];
		sel_rgb[1]= s[4] | s[5] | s[6] | s[7];
		
		en_cnt = ~s[0] & ~s[4];
		done = s[4] & eq;
		vga_start_int = s[1];
	end		
endmodule
