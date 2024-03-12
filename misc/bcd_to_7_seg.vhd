--import libraries

library ieee;
use ieee.std_logic_1164.all;

entity bcd_to_seg is
    port(
        BCD     : in std_logic_vector(3 downto 0); --input a decimal in binary, need 4 inputs (2^4)
        SEG     : out std_logic_vector(6 downto 0) -- output a certain combination of 7 led segments based upon input
    );
end bcd_to_7_seg;

architecture dataflow is

begin
    with BCD select
        SEG <= "1111110" when "0000", --0
        SEG <= "0110000" when "0001", --1
        SEG <= "1101101" when "0010", --2
        SEG <= "1111001" when "0011", --3
        SEG <= "0110011" when "0100", --4
        SEG <= "1011011" when "0101", --5
        SEG <= "1011111" when "0110", --6
        SEG <= "1110000" when "0111", --7
        SEG <= "1111111" when "1000", --8
        SEG <= "1110011" when "1001", --9
        SEG <= "0000000" when others; --others

end dataflow;

