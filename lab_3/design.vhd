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


----end adder

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

----end mult

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

-- end logic

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

--end shifter

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

--end wrapper

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is
-- Don't put anything in the entity.
end alu_tb;

architecture behavioral of alu_tb is
    --Add the component to be tested, here we are testing the whole thing, the wrapper.
    component wrapper is
    
    port (
    
        sel: in std_logic_vector (3 downto 0);
        a: in std_logic_vector (5 downto 0);
        b: in std_logic_vector (5 downto 0);
        r: out std_logic_vector (5 downto 0)
        
        );
    end component;
    
    constant period : time := 10 ns;
    --Create a signal for whatever inputs and outputs you have.
    signal sel_tb   : std_logic_vector (3 downto 0);
    signal a_tb   : std_logic_vector(5 downto 0);
    signal b_tb    : std_logic_vector (5 downto 0);
    signal r_tb  : std_logic_vector(5 downto 0);
    
    begin
    --instantiation of unit under testing
    alu_tb_inst: wrapper
    port map(
        -- BEFORE ARROW == I/O OF COMPONENTS
        -- AFTER ARROW == FROM TOP LEVEL
    
            sel => sel_tb,
            a => a_tb,
            b => b_tb,
            r => r_tb
    );
    
    tb: process
    begin
        a_tb <= "000100";
        b_tb <= "000010";
        sel_tb <= "0000";
        for sel_val in 0 to 15 loop
        sel_tb <= std_logic_vector(to_unsigned(sel_val, 4));
        
        wait for 10 ns;
        end loop;
        
        a_tb <= "110001";
        b_tb <= "110010";
        sel_tb <= "0000";
        for sel_val in 0 to 15 loop
        sel_tb <= std_logic_vector(to_unsigned(sel_val, 4));
        
        wait for 10 ns;
        end loop;
        
        a_tb <= "111111";
        b_tb <= "111111";
        sel_tb <= "0000";
        for sel_val in 0 to 15 loop
        sel_tb <= std_logic_vector(to_unsigned(sel_val, 4));
        
        wait for 10 ns;
        end loop;
        
        wait;
    
    
    end process;
end behavioral;

--end testbench