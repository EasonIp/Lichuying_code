library verilog;
use verilog.vl_types.all;
entity adder_half is
    port(
        a               : in     vl_logic;
        b               : in     vl_logic;
        sum             : out    vl_logic;
        c_out           : out    vl_logic
    );
end adder_half;
