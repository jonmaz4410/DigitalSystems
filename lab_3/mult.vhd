library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult is
port(
    sel: in std_logic;
    a: in std_logic_vector(5 downto 0);
    b: in std_logic_vector(5 downto 0);
    r: out std_logic_vector(5 downto 0)
);
end mult;

architecture dataflow of mult is
    --signals
    signal high_result: unsigned(5 downto 0);
    signal low_result: unsigned(5 downto 0);
    signal mult_result: unsigned(11 downto 0);
    

begin
    mult_result <= unsigned(a) * unsigned(b);
    low_result <= mult_result(5 downto 0);
    high_result <= mult_result(11 downto 6);
    
    r <= std_logic_vector(low_result) when sel = '0' else std_logic_vector(high_result);

end dataflow;