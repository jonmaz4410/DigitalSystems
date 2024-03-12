library ieee;
use ieee.std_logic_1164.all;

entity control_circuit is
    port (
        start       : in std_logic
        stop        : in std_logic
        clock       : in std_logic
        run         : out std_logic
    );
end control_circuit;

architecture behavioral of control_circuit is
begin
    P1: process(clock)
    begin
        if rising_edge(clock) then
            if start = '1' then
                run <= '1';
            elsif stop = '1' then
                run <= '0';
            end if;
        end if;
    end process;
end behavioral; 