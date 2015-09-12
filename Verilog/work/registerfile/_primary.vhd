library verilog;
use verilog.vl_types.all;
entity registerfile is
    port(
        clk             : in     vl_logic;
        wb              : in     vl_logic_vector(31 downto 0);
        we              : in     vl_logic;
        s1              : in     vl_logic_vector(4 downto 0);
        s2              : in     vl_logic_vector(4 downto 0);
        d               : in     vl_logic_vector(4 downto 0);
        s1val           : out    vl_logic_vector(31 downto 0);
        s2val           : out    vl_logic_vector(31 downto 0)
    );
end registerfile;
