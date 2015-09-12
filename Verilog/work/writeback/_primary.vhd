library verilog;
use verilog.vl_types.all;
entity writeback is
    generic(
        JAL             : vl_logic_vector(0 to 5) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi1)
    );
    port(
        pc              : in     vl_logic_vector(31 downto 0);
        insn            : in     vl_logic_vector(31 downto 0);
        controls        : in     vl_logic_vector(13 downto 0);
        O               : in     vl_logic_vector(31 downto 0);
        \D\             : in     vl_logic_vector(31 downto 0);
        rdval           : out    vl_logic_vector(31 downto 0);
        rwe             : out    vl_logic;
        d               : out    vl_logic_vector(4 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of JAL : constant is 1;
end writeback;
