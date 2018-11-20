library verilog;
use verilog.vl_types.all;
entity yuv_to_rgb_datapath is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        ldenY           : in     vl_logic;
        ldenU           : in     vl_logic;
        ldenV           : in     vl_logic;
        selWdata        : in     vl_logic_vector(1 downto 0);
        count_en_wr     : in     vl_logic;
        selNum          : in     vl_logic_vector(1 downto 0);
        count_en_rd     : in     vl_logic;
        selAdd          : in     vl_logic_vector(1 downto 0);
        wr_done         : out    vl_logic;
        rd_done         : out    vl_logic;
        w_addr          : out    vl_logic_vector(17 downto 0);
        r_addr          : out    vl_logic_vector(17 downto 0);
        r_data          : in     vl_logic_vector(15 downto 0);
        width           : in     vl_logic_vector(15 downto 0);
        height          : in     vl_logic_vector(15 downto 0);
        wdata           : out    vl_logic_vector(15 downto 0);
        selPixel        : in     vl_logic;
        ldR             : in     vl_logic;
        ldG             : in     vl_logic;
        ldB             : in     vl_logic
    );
end yuv_to_rgb_datapath;
