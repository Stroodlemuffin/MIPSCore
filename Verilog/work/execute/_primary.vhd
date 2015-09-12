library verilog;
use verilog.vl_types.all;
entity execute is
    port(
        clk             : in     vl_logic;
        pc              : in     vl_logic_vector(31 downto 0);
        insn            : in     vl_logic_vector(31 downto 0);
        s1_val          : in     vl_logic_vector(31 downto 0);
        s2_val          : in     vl_logic_vector(31 downto 0);
        controls        : in     vl_logic_vector(13 downto 0);
        branch_taken    : out    vl_logic;
        pc_effective    : out    vl_logic_vector(31 downto 0);
        pc_out          : out    vl_logic_vector(31 downto 0);
        insn_out        : out    vl_logic_vector(31 downto 0);
        controls_out    : out    vl_logic_vector(13 downto 0);
        O_out           : out    vl_logic_vector(31 downto 0);
        B_out           : out    vl_logic_vector(31 downto 0);
        MX_abypass      : in     vl_logic;
        MX_bbypass      : in     vl_logic;
        MX_bypassval    : in     vl_logic_vector(31 downto 0);
        WX_abypass      : in     vl_logic;
        WX_bbypass      : in     vl_logic;
        WX_bypassval    : in     vl_logic_vector(31 downto 0)
    );
end execute;
