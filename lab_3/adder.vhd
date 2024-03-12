library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is 
port (

--define ports
    sel: in std_logic_vector (1 downto 0);
    a: in std_logic_vector (5 downto 0);
    b: in std_logic_vector (5 downto 0);
    r: out std_logic_vector (5 downto 0)

);
end adder;

architecture dataflow of adder is
    signal a_long: unsigned(6 downto 0 );           --0 + a
    signal a_complement: signed(6 downto 0 );       --NOT a
    
    signal b_long: unsigned(6 downto 0 );           --0 + b
    signal b_complement: signed(6 downto 0 );       --NOT b
    
    signal sum_temp: unsigned(6 downto 0);          --7 bit sum of a_long and b_long, using or disregarding carry bit as needed
    signal carry_temp: unsigned(5 downto 0);        --"00000" + (sum_temp(6))
    signal sub_temp: unsigned(6 downto 0);          -- a_long + b_complement
    signal borrow_temp: unsigned(5 downto 0);       --"00000" + (sub_temp(6))
    
begin
    --sum 7 bit
    a_long <= '0' & unsigned(a);
    b_long <= '0' & unsigned(b);
    sum_temp <= a_long + b_long;
    --carry 6 bit
    carry_temp <= "00000" & (sum_temp(6));
    --subtraction 7 bit
    sub_temp <= a_long + ((not b_long) + 1);
    --borrow
    borrow_temp <= "00000" & (sub_temp(6));
    
    
--    r <= "00000" & std_logic(sub_temp(6));
--    r <= std_logic_vector(sub_temp(5 downto 0));
    
    with sel select 
        r <=    std_logic_vector(sum_temp(5 downto 0))          when "00",
                std_logic_vector(carry_temp)                    when "01",
                std_logic_vector(sub_temp(5 downto 0))          when "10",
                std_logic_vector(borrow_temp)                   when "11",
                "000000"                                        when others;    
end dataflow;
