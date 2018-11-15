
	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"tb_top"
	set hdl_path			"../src/hdl"
	set inc_path			"../src/inc"
	
#	set run_time			"1 us"
	set run_time			"-all"

#============================ Add verilog files  ===============================
	
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/decompressor_top.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/sram_vga_controller.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/yuv_to_rgb_conversion.v
	
	vlog 	+acc -incr -source  +define+SIM 	EmulatorModule/SRAM_Emulator.v
	vlog 	+acc -incr -source  +define+SIM 	EmulatorModule/VGA_Emulator.v
	
	vlog 	+acc -incr -source  +incdir+$inc_path +define+SIM 	./tb/$TB.v
	onerror {break}

#================================ simulation ====================================

	vsim	-voptargs=+acc -debugDB $TB


#======================= adding signals to wave window ==========================

	add wave -hex -group 	 	{SRAM_Emulator}		sim:/$TB/SRAM_Emulator/*
	add wave -hex -group 	 	{VGA_Emulator}		sim:/$TB/VGA_Emulator/*
	add wave -hex -group 	 	{TB}				sim:/$TB/*
	add wave -hex -group 	 	{top}				sim:/$TB/decompressor_top/*	
	add wave -hex -group 	 	{SRAM_VGA}			sim:/$TB/decompressor_top/sram_vga_controller/*
	add wave -hex -group 	 	{REORDER}			sim:/$TB/decompressor_top/yuv_to_rgb_conversion/*
	add wave -hex -group -r		{all}				sim:/$TB/*

#=========================== Configure wave signals =============================
	
	configure wave -signalnamewidth 2
    

#====================================== run =====================================

	run $run_time 
	