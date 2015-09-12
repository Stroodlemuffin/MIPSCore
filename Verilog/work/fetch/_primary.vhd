library verilog;
use verilog.vl_types.all;
entity fetch is
    port(
        clk             : in     vl_logic;
        stall           : in     vl_logic;
        branch_taken    : in     vl_logic;
        pc_effective    : in     vl_logic_vector(31 downto 0);
        pc_out          : out    vl_logic_vector(31 downto 0);
        insn_out        : out    vl_logic_vector(31 downto 0)
    );
end fetch;
