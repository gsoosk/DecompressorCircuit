library verilog;
use verilog.vl_types.all;
entity decompressor_top is
    generic(
        AW              : integer := 20;
        DW              : integer := 16;
        IMAGE_WIDTH     : integer := 320;
        IMAGE_HEIGHT    : integer := 240;
        ADDR_REORDER_PIXEL: integer := 0;
        ADDR_ORDER_PIXEL: integer := 115200
    );
    port(
        reset           : in     vl_logic;
        clk             : in     vl_logic;
        start           : in     vl_logic;
        done            : out    vl_logic;
        sram_raddr      : out    vl_logic_vector;
        sram_rdata      : in     vl_logic_vector;
        sram_waddr      : out    vl_logic_vector;
        sram_wdata      : out    vl_logic_vector;
        sram_wr_enable  : out    vl_logic;
        vgastart        : out    vl_logic;
        r               : out    vl_logic_vector(7 downto 0);
        g               : out    vl_logic_vector(7 downto 0);
        b               : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of AW : constant is 1;
    attribute mti_svvh_generic_type of DW : constant is 1;
    attribute mti_svvh_generic_type of IMAGE_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of IMAGE_HEIGHT : constant is 1;
    attribute mti_svvh_generic_type of ADDR_REORDER_PIXEL : constant is 1;
    attribute mti_svvh_generic_type of ADDR_ORDER_PIXEL : constant is 1;
end decompressor_top;
