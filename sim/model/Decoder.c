//if compile in window uncommnet next line.
//#include "stdafx.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "time.h"
int W = 320;
int H = 240;

int read_sram(char sram_init[], unsigned int * sram, int size); // sram[i]: 16 bit is valid.((data[7:0]) + (data[7:0]<<8))
void write_image(char output_filename[], unsigned int * rgb); // rgb[i]: 24 bit is valid. (r + (g<<8) + (b<<16) )
void yuv_to_rgb_conversion(unsigned int *  sram, unsigned int * rgb); // sram and rgb 

int main(void){
	unsigned int * sram, *rgb;
	char fileName[50] = "../file/ca4_ut.hex";
	char outputFileName[50] = "result_file.bmp";

	sram = (unsigned int *)malloc(W*H * 3 / 2 * sizeof(unsigned int));
	read_sram(fileName, sram, W*H * 3 / 2);
	printf("read sram done.\n");
	
	rgb = (unsigned int *)malloc(W*H * sizeof(unsigned int));


	clock_t begin, end;
	begin = clock();
	yuv_to_rgb_conversion(sram, rgb);
	end = clock();
	printf("yuv to rgb and pixel reorder done. and number of clocks is %d \n", (int)(end - begin));


	write_image(outputFileName, rgb);
	printf("write image done.\n");
	return 0;
   
}

void yuv_to_rgb_matrix_multiply(int y, int u, int v, int *r, int *g, int *b)
{
	y = y - 16;
	u = u - 128; 
	v = v - 128;

	
	*r =  (int)(( (76284 * y) + (104595 * v) )/65536);
	*r =  *r > 255 ? 255 : *r;
	*r =  *r < 0 ? 0 : *r;
	*g =  (int)(( (76284 * y) + ((-25624) * u) + ((-53281) * v) )/65536);
	*g =  *g > 255 ? 255 : *g;
	*g =  *g < 0 ? 0 : *g;
	*b =  (int)(( (76284 * y) + (132251 * u) )/65536);
	*b =  *b > 255 ? 255 : *b;
	*b =  *b < 0 ? 0 : *b;

}


void yuv_to_rgb_conversion(unsigned int *  sram, unsigned int * rgb){ // sram and rgb 
	int h, w ;	
	int uu, vv, yy;
	int u, v, y;
	int r, g, b;
	// Offset of Y, U and V color in SRAM
	int yy_offset = 0;
	int uu_offset = H * W / 2;
	int vv_offset = H * W;
	for (h=0; h<H; h++)
		for (w=0; w<W; w=w+2){
			// Get Y2Y1
			yy = sram[yy_offset + (h*W + w) / 2];
			// Get U2U1
			uu = sram[uu_offset + (h*W + w) / 2];
			// Get V2V1
			vv = sram[vv_offset + (h*W + w) / 2];
			// Extract Y1,U1 and V1
			u = uu & 0x00ff;
			v = vv & 0x00ff;
			y = yy & 0x00ff;
			// Calculate R , G , B (1)
			yuv_to_rgb_matrix_multiply(y, u, v, &r, &g, &b);
			// Set YUV1
			rgb[h*W + w] = r + (g << 8) + (b << 16) ;
			//Extract Y2,U2 and V2
			u = uu >> 8;
			v = vv >> 8;
			y = yy >> 8;
			// Calculate R , G , B (2)
			yuv_to_rgb_matrix_multiply(y, u, v, &r, &g, &b);
			rgb[h*W + w + 1] = r + ( g<<8 ) + ( b <<16 ) ;
		}
}



void write_image(char output_filename[] , unsigned int * rgb){ // rgb[i]: 24 bit is valid. (r + (g<<8) + (b<<16) )
	int i,h , w ;
	FILE *fp;
	unsigned char header[54] ;
	
	// Initialize header of bmp to zero.
	for (i=0; i<54; i++)
		header[i] = 0;
	// Initialize header of bmp file.
	header[0]= 0x42;
	header[1]= 0x4d;
	header[2]= 0x36;
	header[3]= 0x84;
	header[4]= 0x01;
	header[10]= 0x36;
	header[14]= 0x28;
	header[18]= W; 
	header[19]= W >> 8; 
	header[20]= W >> 16;
	header[21]= W >> 24;
	header[22]= H; 
	header[23]= H >> 8; 
	header[24]= H >> 16;
	header[25]= H >> 24;
	header[26]= 0x01;
	header[28]= 0x18;
	header[35]= 0x84;
	header[36]= 0x03;
	
	fp = fopen(output_filename,"wb");
	
	if(!fp){
			printf("Can not create bmp file for output.");
	}
	// Write header of bmp file.
	for (i=0; i<54; i++){
		fprintf(fp, "%c",header[i]);
	}
	
	// Write RGB 
	// These are the actual image data, represented by consecutive rows, or "scan lines," of the bitmap. 
	// Each scan line consists of consecutive bytes representing the pixels in the scan line, in left-to-right order. 
	// The system maps pixels beginning with the bottom scan line of the rectangular region and ending with the top scan line.
	for (h=0; h<H; h++)
		for (w=0; w<W; w++)
			fprintf(fp, "%c%c%c",rgb[(H - h - 1)*W + w] >> 16, rgb[(H - h - 1)*W + w] >> 8, rgb[(H - h - 1)*W + w]);
	fclose(fp);
}

 int read_sram(char sram_init_filename[], unsigned int  * sram,  int size){ // sram[i]: 16 bit is valid.((data[7:0]) + (data[7:0]<<8))

	int i ;
	FILE *fp;
	fp = fopen(sram_init_filename, "r");
	if(!fp){
			printf("File name for SRAM_INIT not valid.");
			return 0;
	}
	
	//sram = (unsigned int *)malloc(size*sizeof(unsigned int));
	for (i=0; i<size; i++){
		fscanf(fp, "%x", &sram[i]);
	}
	return 1;
}
