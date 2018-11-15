`define default_net_type none
module SRAM_Emulator#(
	parameter AW = 18,
	parameter DW = 16,
	parameter INIT_SIZE = 1<<AW ,
	parameter INIT_START = 0,
	parameter INIT_FILE_NAME = "SRAM_INIT_chip.dat"
)
(
	input wire clk,
	// Read-only port
	input wire [AW-1:0]	raddr,
	output wire[DW-1:0] rdata,
	// Write-only port
	input wire [AW-1:0]	waddr,
	input wire [DW-1:0]	wdata,
	input wire 			wr_enable
);

localparam SRAM_DEPTH = 1<<AW;

reg [DW-1:0]sram[0:SRAM_DEPTH-1];

reg [DW-1:0]rdata_int;
integer i ;
integer j ;
integer temp;
initial begin
	$readmemh(INIT_FILE_NAME,sram, INIT_START, INIT_START + INIT_SIZE-1);
	
end

always@(posedge clk)begin
	rdata_int <= sram[raddr];
	if(wr_enable)
		sram[waddr] <= wdata;
end
assign rdata = rdata_int;

endmodule
