library verilog;
use verilog.vl_types.all;
entity yuv_to_rgb_controller is
    generic(
        IDLE            : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi0, Hi0);
        \START\         : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi0, Hi1);
        LOAD_Y          : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi1, Hi0);
        LOAD_U          : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi1, Hi1);
        LOAD_V          : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi0, Hi0);
        CALC_R          : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi0, Hi1);
        CALC_G          : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi1, Hi0);
        CALC_B          : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi1, Hi1);
        CALC_R2         : vl_logic_vector(3 downto 0) := (Hi1, Hi0, Hi0, Hi0);
        CALC_G2         : vl_logic_vector(3 downto 0) := (Hi1, Hi0, Hi0, Hi1);
        CALC_B2         : vl_logic_vector(3 downto 0) := (Hi1, Hi0, Hi1, Hi0);
        WRITE_BG        : vl_logic_vector(3 downto 0) := (Hi1, Hi0, Hi1, Hi1);
        \DONE\          : vl_logic_vector(3 downto 0) := (Hi1, Hi1, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        start           : in     vl_logic;
        done            : out    vl_logic;
        selAdd          : out    vl_logic_vector(1 downto 0);
        ldenY           : out    vl_logic;
        ldenU           : out    vl_logic;
        ldenV           : out    vl_logic;
        count_en_rd     : out    vl_logic;
        count_en_wr     : out    vl_logic;
        selPixel        : out    vl_logic;
        selNum          : out    vl_logic_vector(1 downto 0);
        ldR             : out    vl_logic;
        ldG             : out    vl_logic;
        ldB             : out    vl_logic;
        selWdata        : out    vl_logic_vector(1 downto 0);
        wr_enable       : out    vl_logic;
        wr_done         : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 2;
    attribute mti_svvh_generic_type of \START\ : constant is 2;
    attribute mti_svvh_generic_type of LOAD_Y : constant is 2;
    attribute mti_svvh_generic_type of LOAD_U : constant is 2;
    attribute mti_svvh_generic_type of LOAD_V : constant is 2;
    attribute mti_svvh_generic_type of CALC_R : constant is 2;
    attribute mti_svvh_generic_type of CALC_G : constant is 2;
    attribute mti_svvh_generic_type of CALC_B : constant is 2;
    attribute mti_svvh_generic_type of CALC_R2 : constant is 2;
    attribute mti_svvh_generic_type of CALC_G2 : constant is 2;
    attribute mti_svvh_generic_type of CALC_B2 : constant is 2;
    attribute mti_svvh_generic_type of WRITE_BG : constant is 2;
    attribute mti_svvh_generic_type of \DONE\ : constant is 2;
end yuv_to_rgb_controller;
