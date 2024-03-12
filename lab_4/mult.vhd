-- MULT WRAPPER
library ieee;
use ieee.std_logic_1164.all;

entity mult is
    port(
        clk     : in std_logic;
        a       : in std_logic_vector (7 downto 0);
        b       : in std_logic_vector (7 downto 0);
        p       : out std_logic_vector (15 downto 0)
    );
end mult;

architecture structural of mult is

component carry_save_mult is
    -- add generic n
    generic (n : integer  := 8);
    port(
        a: in std_logic_vector(n-1 downto 0);
        b: in std_logic_vector(n-1 downto 0);
        p: out std_logic_vector(2*n-1 downto 0)
    );
end component;
    -- add carry_save_mult as a component
    -- we don't need to the full_adder as component here

    -- signals
    signal a_reg  : std_logic_vector(7 downto 0);
    signal b_reg  : std_logic_vector(7 downto 0);
    signal p_s    : std_logic_vector(15 downto 0);
    
begin

    carry_save_mult_inst: carry_save_mult
    port map (
    
    a => a_reg,
    b => b_reg,
    p => p_s
    
    );


    reg_mult : process(clk)
    begin
        if rising_edge(clk) then
            -- on the rising edge, make the signals equal
            -- to the inputs and outputs carry_save_mult
            a_reg <= a;
            b_reg <= b;
            p <= p_s;
            
        end if;
    end process;

end structural;

-- after completing the design, write the simulation testbench.
-- make sure to add "create clock -period 10 -name clk [get ports clk]" to your constraints file.