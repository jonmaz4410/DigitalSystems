library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter is

port(

    a: in std_logic_vector(5 downto 0);
    b: in std_logic_vector(2 downto 0);
    sel: in std_logic_vector(1 downto 0);
    r: out std_logic_vector(5 downto 0)
);
    
end shifter;

architecture dataflow of shifter is
  
begin
    --
    with sel select r <=
    std_logic_vector(shift_left(unsigned(a), to_integer(unsigned(b))))          when "00", --Logic Left
    std_logic_vector(shift_left(unsigned(a), to_integer(unsigned(b))))          when "01",--Logic Left
    std_logic_vector(shift_right(unsigned(a), to_integer(unsigned(b))))         when "10",--Logic Right
    std_logic_vector(shift_right(signed(a), to_integer(unsigned(b))))           when "11",--Arith Right
    "000000"                                                                    when others;
    
end dataflow;