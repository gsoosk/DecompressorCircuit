library verilog;
use verilog.vl_types.all;
entity counter_18bit is
    port(
        start_addr      : in     vl_logic_vector(17 downto 0);
        limit           : in     vl_logic_vector(17 downto 0);
        clk             : in     vl_logic;
        count_en        : in     vl_logic;
        clear           : in     vl_logic;
        r_addr          : out    vl_logic_vector(17 downto 0);
        count_done      : out    vl_logic
    );
end counter_18bit;
