library verilog;
use verilog.vl_types.all;
entity register_8_bit is
    port(
        load_en         : in     vl_logic;
        clk             : in     vl_logic;
        data_in         : in     vl_logic_vector(7 downto 0);
        data_out        : out    vl_logic_vector(7 downto 0)
    );
end register_8_bit;
