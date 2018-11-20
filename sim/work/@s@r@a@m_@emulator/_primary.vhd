library verilog;
use verilog.vl_types.all;
entity SRAM_Emulator is
    generic(
        AW              : integer := 18;
        DW              : integer := 16;
        INIT_SIZE       : vl_notype;
        INIT_START      : integer := 0;
        INIT_FILE_NAME  : string  := "SRAM_INIT_chip.dat"
    );
    port(
        clk             : in     vl_logic;
        raddr           : in     vl_logic_vector;
        rdata           : out    vl_logic_vector;
        waddr           : in     vl_logic_vector;
        wdata           : in     vl_logic_vector;
        wr_enable       : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of AW : constant is 1;
    attribute mti_svvh_generic_type of DW : constant is 1;
    attribute mti_svvh_generic_type of INIT_SIZE : constant is 3;
    attribute mti_svvh_generic_type of INIT_START : constant is 1;
    attribute mti_svvh_generic_type of INIT_FILE_NAME : constant is 1;
end SRAM_Emulator;
