library verilog;
use verilog.vl_types.all;
entity sram_vga_controller is
    generic(
        AW              : integer := 20;
        DW              : integer := 16;
        START_ADDR      : integer := 0;
        IMAGE_WIDTH     : integer := 320;
        IMAGE_HEIGHT    : integer := 240
    );
    port(
        reset           : in     vl_logic;
        clk             : in     vl_logic;
        start           : in     vl_logic;
        done            : out    vl_logic;
        raddr           : out    vl_logic_vector;
        rdata           : in     vl_logic_vector;
        waddr           : out    vl_logic_vector;
        wdata           : out    vl_logic_vector;
        wr_enable       : out    vl_logic;
        vgastart        : out    vl_logic;
        r               : out    vl_logic_vector(7 downto 0);
        g               : out    vl_logic_vector(7 downto 0);
        b               : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of AW : constant is 1;
    attribute mti_svvh_generic_type of DW : constant is 1;
    attribute mti_svvh_generic_type of START_ADDR : constant is 1;
    attribute mti_svvh_generic_type of IMAGE_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of IMAGE_HEIGHT : constant is 1;
end sram_vga_controller;
