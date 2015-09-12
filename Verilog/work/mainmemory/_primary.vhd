library verilog;
use verilog.vl_types.all;
entity mainmemory is
    generic(
        MEGABYTES       : integer := 1;
        OFFSET          : vl_logic_vector(31 downto 0) := (Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0)
    );
    port(
        data_out        : out    vl_logic_vector(0 to 31);
        busy            : out    vl_logic;
        enable          : in     vl_logic;
        address_in      : in     vl_logic_vector(0 to 31);
        data_in         : in     vl_logic_vector(0 to 31);
        read_write      : in     vl_logic;
        access_size     : in     vl_logic_vector(0 to 1);
        clk             : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MEGABYTES : constant is 1;
    attribute mti_svvh_generic_type of OFFSET : constant is 1;
end mainmemory;
