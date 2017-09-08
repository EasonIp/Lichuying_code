library verilog;
use verilog.vl_types.all;
entity rca_16 is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
        c_in            : in     vl_logic;
        sum             : out    vl_logic_vector(15 downto 0);
        c_out           : out    vl_logic
    );
end rca_16;
