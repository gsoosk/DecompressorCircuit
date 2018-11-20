library verilog;
use verilog.vl_types.all;
entity tb_top is
    generic(
        IMAGE_WIDTH     : integer := 320;
        IMAGE_HEIGHT    : integer := 240;
        SRAM_INIT_SIZE  : vl_notype;
        INIT_FILE_NAME  : string  := "./file/ca4_kintex7.hex";
        SRAM_INIT_START : integer := 0;
        ADDR_ORDER_PIXEL: integer := 115200;
        AW              : integer := 18;
        DW              : integer := 16
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IMAGE_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of IMAGE_HEIGHT : constant is 1;
    attribute mti_svvh_generic_type of SRAM_INIT_SIZE : constant is 3;
    attribute mti_svvh_generic_type of INIT_FILE_NAME : constant is 1;
    attribute mti_svvh_generic_type of SRAM_INIT_START : constant is 1;
    attribute mti_svvh_generic_type of ADDR_ORDER_PIXEL : constant is 1;
    attribute mti_svvh_generic_type of AW : constant is 1;
    attribute mti_svvh_generic_type of DW : constant is 1;
end tb_top;
