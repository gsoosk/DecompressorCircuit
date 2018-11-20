library verilog;
use verilog.vl_types.all;
entity yuv_to_rgb_conversion is
    generic(
        ADDR_REORDER_PIXEL: integer := 0;
        ADDR_ORDER_PIXEL: integer := 115200;
        W               : integer := 320;
        H               : integer := 240;
        DW              : integer := 16;
        AW              : integer := 18
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        start           : in     vl_logic;
        done            : out    vl_logic;
        raddr           : out    vl_logic_vector;
        rdata           : in     vl_logic_vector;
        waddr           : out    vl_logic_vector;
        wdata           : out    vl_logic_vector;
        wr_enable       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ADDR_REORDER_PIXEL : constant is 1;
    attribute mti_svvh_generic_type of ADDR_ORDER_PIXEL : constant is 1;
    attribute mti_svvh_generic_type of W : constant is 1;
    attribute mti_svvh_generic_type of H : constant is 1;
    attribute mti_svvh_generic_type of DW : constant is 1;
    attribute mti_svvh_generic_type of AW : constant is 1;
end yuv_to_rgb_conversion;
