library verilog;
use verilog.vl_types.all;
entity alu is
    port(
        s1val           : in     vl_logic_vector(31 downto 0);
        s2val           : in     vl_logic_vector(31 downto 0);
        sa              : in     vl_logic_vector(4 downto 0);
        ALUop           : in     vl_logic_vector(5 downto 0);
        result          : out    vl_logic_vector(31 downto 0);
        branch          : out    vl_logic
    );
end alu;
