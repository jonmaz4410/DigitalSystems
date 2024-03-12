library IEEE;
use IEEE.std_logic_1164.all;

entity controller is

    port (
        x: in std_logic;
        y: in std_logic;
        rst: in std_logic;
        clk: in std_logic;
        v: out std_logic;
        z: out std_logic;
        init: out std_logic;
        write: out std_logic;
        load: out std_logic
    );

end controller;

architecture mixed of controller is

type fsm_state is (S0, S1, S2, S3, S4);

signal state: fsm_state;

begin

fsm: process (clk, rst)

begin

    if rst = '1' then
        state <= S0;
    elsif rising_edge(clk) then
        case state is
            when S0 =>
                if (x = '1') then
                    state <= S1;
                else
                    state <= S0;
                end if;
                
            when S1 =>
                if (x = '1') then
                    state <= S2;
                else
                    state <= S1;
                end if;
            
            when S2 =>
                if y = '1' then
                    state <= S3;
                else
                    state <= S4;
                end if;
            
            when S3 =>
                if (x = '0' and y = '0') then
                    state <= S1;
                elsif (x = '1') then
                    state <= S4;
                else
                    state <= S2; 
                end if;
            
            when S4 => 
                state <= S2;
        end case;
    end if;
end process;

v <= '1' when 
        (state = S1 and x = '0') OR
        (state = S2 and y = '0') ELSE
        '0';

z <= '1' when 
        (state = S2) OR
        (state = S3 and y = '0' and x = '0') ELSE
        '0';

init <= '1' when
        (state = S0) ELSE
        '0';

write <= '1' when
        (state = S3) ELSE
        '0';

load <= '1' when
        (state = S4) ELSE
        '0';


end mixed;