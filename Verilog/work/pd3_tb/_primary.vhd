library verilog;
use verilog.vl_types.all;
entity pd3_tb is
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
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of LB : constant is 1;
    attribute mti_svvh_generic_type of LBU : constant is 1;
    attribute mti_svvh_generic_type of LH : constant is 1;
    attribute mti_svvh_generic_type of LHU : constant is 1;
    attribute mti_svvh_generic_type of LW : constant is 1;
    attribute mti_svvh_generic_type of SB : constant is 1;
    attribute mti_svvh_generic_type of SH : constant is 1;
    attribute mti_svvh_generic_type of SW : constant is 1;
end pd3_tb;
