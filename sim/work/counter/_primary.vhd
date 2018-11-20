library verilog;
use verilog.vl_types.all;
entity counter is
    generic(
        DW              : integer := 32
    );
    port(
        clk             : in     vl_logic;
        en              : in     vl_logic;
        clear           : in     vl_logic;
        cnt             : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DW : constant is 1;
end counter;
