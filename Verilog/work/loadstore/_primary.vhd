library verilog;
use verilog.vl_types.all;
entity loadstore is
    generic(
        LB              : vl_logic_vector(0 to 5) := (Hi1, Hi0, Hi0, Hi0, Hi0, Hi0);
        LBU             : vl_logic_vector(0 to 5) := (Hi1, Hi0, Hi0, Hi1, Hi0, Hi0);
        LH              : vl_logic_vector(0 to 5) := (Hi1, Hi0, Hi0, Hi0, Hi0, Hi1);
        LHU             : vl_logic_vector(0 to 5) := (Hi1, Hi0, Hi0, Hi1, Hi0, Hi1);
        LW              : vl_logic_vector(0 to 5) := (Hi1, Hi0, Hi0, Hi0, Hi1, Hi1);
        SB              : vl_logic_vector(0 to 5) := (Hi1, Hi0, Hi1, Hi0, Hi0, Hi0);
        SH              : vl_logic_vector(0 to 5) := (Hi1, Hi0, Hi1, Hi0, Hi0, Hi1);
        SW              : vl_logic_vector(0 to 5) := (Hi1, Hi0, Hi1, Hi0, Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        pc              : in     vl_logic_vector(31 downto 0);
        insn            : in     vl_logic_vector(31 downto 0);
        controls        : in     vl_logic_vector(13 downto 0);
        O               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        pc_out          : out    vl_logic_vector(31 downto 0);
        insn_out        : out    vl_logic_vector(31 downto 0);
        controls_out    : out    vl_logic_vector(13 downto 0);
        O_out           : out    vl_logic_vector(31 downto 0);
        D_out           : out    vl_logic_vector(31 downto 0);
        WM_bypass       : in     vl_logic;
        WM_B_bypass     : in     vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of LB : constant is 1;
    attribute mti_svvh_generic_type of LBU : constant is 1;
    attribute mti_svvh_generic_type of LH : constant is 1;
    attribute mti_svvh_generic_type of LHU : constant is 1;
    attribute mti_svvh_generic_type of LW : constant is 1;
    attribute mti_svvh_generic_type of SB : constant is 1;
    attribute mti_svvh_generic_type of SH : constant is 1;
    attribute mti_svvh_generic_type of SW : constant is 1;
end loadstore;
