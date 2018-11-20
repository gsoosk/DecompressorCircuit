library verilog;
use verilog.vl_types.all;
entity VGA_Emulator is
    port(
        clk             : in     vl_logic;
        start           : in     vl_logic;
        r               : in     vl_logic_vector(7 downto 0);
        g               : in     vl_logic_vector(7 downto 0);
        b               : in     vl_logic_vector(7 downto 0)
    );
end VGA_Emulator;
