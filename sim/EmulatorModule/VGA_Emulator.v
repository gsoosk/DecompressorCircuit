`define default_net_type none
module VGA_Emulator
(
	input wire clk,
	input wire start,
	
	input wire [7:0] r,
	input wire [7:0] g,
	input wire [7:0] b
);
integer fid ;
localparam [31:0]maxw = 2000;
localparam [31:0]maxh = 2000;

// definition of  signal
reg done , done_r ;

wire [31:0] cnt_pixel ;
reg clear_cnt_pixel, en_cnt_pixel ;

reg en_row, en_column ;
reg [31:0] row, column, all_pixel;

// State signal for FSM
reg [2:0] state,nstate;
localparam 	STATE_IDLE =0,
			STATE_RCV_COLUMN = 1,
			STATE_RCV_ROW = 2,
			STATE_GET_PIXEL = 3,
			STATE_CHECKING_DONE = 4,
			STATE_DONE = 5;

// mem for header of bmp
reg [7:0]hbmp[0:53];
integer i ; 
initial begin
	for (i=0;i<54;i=i+1)begin
		hbmp[i] = 0;
	end
	hbmp[0]= 8'h42;
	hbmp[1]= 8'h4d;
	hbmp[2]= 8'h36;
	hbmp[3]= 8'h84;
	hbmp[4]= 8'h01;
	hbmp[10]= 8'h36;
	hbmp[14]= 8'h28;
	hbmp[18]= maxw[0+:8]; 
	hbmp[19]= maxw[8+:8]; 
	hbmp[20]= maxw[16+:8];
	hbmp[21]= maxw[24+:8];
	hbmp[22]= maxh[0+:8]; 
	hbmp[23]= maxh[8+:8]; 
	hbmp[24]= maxh[16+:8];
	hbmp[25]= maxh[24+:8];
	hbmp[26]= 8'h01;
	hbmp[28]= 8'h18;
	hbmp[35]= 8'h84;
	hbmp[36]= 8'h03;
	
end

reg [3*8-1:0]rgbmem[0:maxw*maxh-1];
reg [3*8-1:0] rgb ;
reg [7:0] c ;

integer fid_hex;

integer j;
initial begin
	#20;
	while(1)begin
		@(posedge done_r)begin
			//write ppm file.
			fid = $fopen("vga_emulator.ppm","wb");
			fid_hex = $fopen("vga_emulator.hex","w");
			$fwrite(fid,"P6\n%d %d\n255\n",column, row);
			for (i=0;i<row;i=i+1)
				for (j=0;j<column;j=j+1)begin
					rgb = rgbmem[(i)*column+j];
					$fwrite(fid,"%c%c%c",rgb[23:16],rgb[15:8],rgb[7:0]);//R,G,B
					$fwrite(fid_hex,"%6x\n",rgb);//R,G,B
					
				end
			$fclose(fid);
			$fclose(fid_hex);
			// Write bmp file.
			fid = $fopen("vga_emulator.bmp","wb");
			hbmp[18]= column[0+:8]; 
			hbmp[19]= column[8+:8]; 
			hbmp[20]= column[16+:8];
			hbmp[21]= column[24+:8];
			hbmp[22]= row[0+:8]; 
			hbmp[23]= row[8+:8]; 
			hbmp[24]= row[16+:8];
			hbmp[25]= row[24+:8];
			for(i=0;i<54;i=i+1)
				$fwrite(fid,"%c",hbmp[i]);
			
			for (i=0;i<row;i=i+1)
				for (j=0;j<column;j=j+1)begin
					rgb = rgbmem[(row-i-1)*column+j];
					$fwrite(fid,"%c%c%c",rgb[7:0],rgb[15:8],rgb[23:16]);//B,G,R
				end
			$fclose(fid);
		end
		#10;
	end
end

//Row and Column register
always@(posedge clk)begin
	if(en_row)
		row <= {16'h0000, g[7:0],r[7:0]};
	
	if(en_column)
		column <= {16'h0000, g[7:0],r[7:0]};
	
	all_pixel <= row*column ;
	done_r <= done ;
end

// Counter for count row and column
counter #(32) 
counter_pixel(
	.clk(clk),
	.en(en_cnt_pixel),
	.clear(clear_cnt_pixel),
	.cnt(cnt_pixel)
);

// Sequential part
always@(posedge clk)begin
	if(start)
		state <= STATE_RCV_COLUMN;
	else
		state <= nstate;
end

// Combinational part
always@(*)begin
	nstate <= state ;
	
	en_row <= 0;
	en_column <= 0;
	
	en_cnt_pixel <= 0;
	clear_cnt_pixel <= 0;
	
	done <=0;
	
	case (state)
		STATE_IDLE:begin
			if(start)
				nstate <= STATE_RCV_COLUMN;
		end
		STATE_RCV_COLUMN:	begin
			en_column <= 1;
			nstate <= STATE_RCV_ROW;
		end
		STATE_RCV_ROW : begin
			en_row <= 1;
			clear_cnt_pixel <= 1;
			nstate <= STATE_GET_PIXEL ;
		end
		STATE_GET_PIXEL : begin
			rgbmem[cnt_pixel] <= {r,g,b};
			nstate <= STATE_CHECKING_DONE;
		end
		STATE_CHECKING_DONE:begin
			if(cnt_pixel < all_pixel)begin
				nstate <= STATE_GET_PIXEL;
				en_cnt_pixel <= 1;
			end
			else
				nstate <= STATE_DONE;
		end
		STATE_DONE:begin
			done <=1;
			nstate <= STATE_IDLE;
		end
		default:
			nstate <= STATE_IDLE;
	endcase
end

endmodule

module counter #(parameter DW = 32)(
	input wire clk,
	input wire en,
	input wire clear,
	output reg [DW-1:0]cnt
);

	always@(posedge clk)begin
		if(clear)
			cnt <=0;
		else if (en)
			cnt <= cnt + 1 ;
	end
endmodule

