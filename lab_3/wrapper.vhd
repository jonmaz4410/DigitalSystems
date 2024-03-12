library ieee;
use ieee.std_logic_1164.all;

entity wrapper is
    port (
        sel: in std_logic_vector(3 downto 0);
        a: in std_logic_vector(5 downto 0);
        b: in std_logic_vector(5 downto 0);
        r:  out std_logic_vector(5 downto 0)
    );

end wrapper;

architecture structural of wrapper is

component adder is 
port (

--define ports
    sel: in std_logic_vector (1 downto 0);
    a: in std_logic_vector (5 downto 0);
    b: in std_logic_vector (5 downto 0);
    r: out std_logic_vector (5 downto 0)

);
end component;

component logic_unit is

port(

    a: in std_logic_vector(5 downto 0);
    b: in std_logic_vector(5 downto 0);
    sel: in std_logic_vector(1 downto 0);
    r: out std_logic_vector(5 downto 0)

);

end component;

component mult is
port(
    sel: in std_logic;
    a: in std_logic_vector(5 downto 0);
    b: in std_logic_vector(5 downto 0);
    r: out std_logic_vector(5 downto 0)
);
end component;

component shifter is

port(

    a: in std_logic_vector(5 downto 0);
    b: in std_logic_vector(2 downto 0);
    sel: in std_logic_vector(1 downto 0);
    r: out std_logic_vector(5 downto 0)
);
    
end component;

signal adder_output: std_logic_vector(5 downto 0);
signal mult_output: std_logic_vector(5 downto 0);
signal logic_unit_output: std_logic_vector(5 downto 0);
signal shifter_output: std_logic_vector(5 downto 0);


begin

adder_inst: adder
port map (

sel     => sel(1 downto 0),
a       => a,
b       => b,
r       => adder_output

);

mult_inst: mult
port map (

sel => sel(0),
a => a(5 downto 0),
b => b(5 downto 0),
r => mult_output
);

logic_unit_inst: logic_unit
port map (

sel => sel(1 downto 0),
a => a (5 downto 0),
b => b(5 downto 0),
r => logic_unit_output
);

shifter_inst: shifter
port map (

sel => sel(1 downto 0),
a => a(5 downto 0),
b => b(2 downto 0),
r => shifter_output
);

with sel(3 downto 2) select
    r <=    adder_output        when "00",
            mult_output         when "01",
            logic_unit_output   when "10",
            shifter_output      when "11",
            "000000"            when others;
    
end structural;