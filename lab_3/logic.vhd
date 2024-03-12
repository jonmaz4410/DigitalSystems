library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity logic_unit is

port(

    a: in std_logic_vector(5 downto 0);
    b: in std_logic_vector(5 downto 0);
    sel: in std_logic_vector(1 downto 0);
    r: out std_logic_vector(5 downto 0)

);
    
end logic_unit;

architecture dataflow of logic_unit is

begin
    
    with sel select r <=
        not a       when "00",
        a and b     when "01",
        a or b      when "10",
        a xor b     when "11",
        "000000"    when others;

end dataflow;