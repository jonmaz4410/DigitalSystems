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
        -- do some test
        wait for 10 ns;
        end loop;
        
        a_tb <= "110001";
        b_tb <= "110010";
        sel_tb <= "0000";
        for sel_val in 0 to 15 loop
        sel_tb <= std_logic_vector(to_unsigned(sel_val, 4));
        -- do some test
        wait for 10 ns;
        end loop;
        
        a_tb <= "111111";
        b_tb <= "111111";
        sel_tb <= "0000";
        for sel_val in 0 to 15 loop
        sel_tb <= std_logic_vector(to_unsigned(sel_val, 4));
        -- do some test
        wait for 10 ns;
        end loop;
        
        wait;
    
    
    end process;
end behavioral;