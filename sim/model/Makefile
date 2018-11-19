# this makefile is intended for gcc on linux

CC = gcc

all: Decoder

clean: 
	rm -f *.o Decoder

Decoder: Decoder.o 
	$(CC)  Decoder.o -o Decoder
 
Decoder.o : Decoder.c

