library verilog;
use verilog.vl_types.all;
entity register_16_bit is
    port(
        load_en         : in     vl_logic;
        clk             : in     vl_logic;
        data_in         : in     vl_logic_vector(15 downto 0);
        data_out        : out    vl_logic_vector(15 downto 0)
    );
end register_16_bit;
