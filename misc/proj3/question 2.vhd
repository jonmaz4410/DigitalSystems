library IEEE;
use IEEE.STD_LOGIC_1164.all;
ENTITY controller IS
PORT( clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    a : IN STD_LOGIC;
    b : IN STD_LOGIC;
    x : OUT STD_LOGIC;
    y : OUT STD_LOGIC;
    z : OUT STD_LOGIC);
END controller;

ARCHITECTURE mixed OF controller IS

    TYPE FSM_state IS (S0, S1, S2, S3, S4);
    SIGNAL State: FSM_state;
    BEGIN
        FSM: PROCESS (clk, rst)
    BEGIN
        IF(rst = '1') THEN
            State <= S0;
        ELSIF rising_edge(clk) THEN
            CASE State IS
                WHEN S0 =>
                    IF a = '1' THEN
                        State <= S1;
                    ELSE
                        State <= S0;
                    END IF;
                WHEN S1 =>
                    State <= S2;
                WHEN S2 =>
                    IF a = '1' THEN
                        State <= S3;
                    ELSE
                        State <= S4;
                    END IF;
                WHEN S3 =>
                    IF b = '1' THEN
                        State <= S4;
                    ELSE
                        State <= S2;
                    END IF;
                WHEN S4 =>
                    IF a = '1' THEN
                        State <= S1;
                    ELSIF b = '1' THEN
                        State <= S3;
                    ELSE
                        State <= S0;
                    END IF;
            END CASE;
        END IF;
END PROCESS;

x <= '1' WHEN 
    (State = S1 and a='0') OR 
    (State = S2 and a='1') OR
    (State = S4 and a='0') ELSE
    '0';
    
y <= '1' WHEN 
    (State = S2) OR 
    (State = S3 and b='1') OR 
    (State = S4) ELSE
    '0';
z <= '1' WHEN 
    (State = S1 and a='0') OR 
    (State = S2 and a='0') OR
    (State = S3 and b='0') OR
    (State = S4 and a='0' and b='1') ELSE
    '0';
                          
END mixed;

library IEEE;
use IEEE.STD_LOGIC_1164.all;


ENTITY tb IS
end tb;

architecture behavioral of tb is

component controller is

PORT( clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    a : IN STD_LOGIC;
    b : IN STD_LOGIC;
    x : OUT STD_LOGIC;
    y : OUT STD_LOGIC;
    z : OUT STD_LOGIC);
END component;

signal clk_tb: std_logic;
signal rst_tb: std_logic;
signal a_tb:   std_logic;
signal b_tb:   std_logic;
signal x_tb:   std_logic;
signal y_tb:   std_logic;
signal z_tb:   std_logic;
constant period : time := 100ns;

begin

controller_inst: controller

port map (

    clk => clk_tb,
    a => a_tb,
    rst => rst_tb,
    b => b_tb,
    x => x_tb,
    y => y_tb,
    z => z_tb
);

clk_gen: process
begin
    clk_tb <= '1';
    wait for period/2;
    clk_tb <= '0';
    wait for period / 2;
end process;

a_gen: process
begin
    a_tb <= '1';
    wait for period/4;
    a_tb <= '0';
    wait for period / 2;
    a_tb <= '1';
    wait for 3*period / 4;
end process;

b_gen: process
begin
    b_tb <= '1';
    wait for 50 ns;
    b_tb <= '0';
    wait for 100 ns;
    b_tb <= '1';
    wait for 75 ns;
    b_tb <= '0';
    wait for 50 ns;
    b_tb <= '1';
    wait for 75 ns;
    b_tb <= '0';
    wait for 100 ns;
    b_tb <= '1';
    wait for 60 ns;
    b_tb <= '0';
    wait for 90 ns;
end process;

rst_gen: process

begin
    rst_tb <= '1';
    wait for 50 ns;
    rst_tb <= '0';
    wait for 550 ns;
end process;

end behavioral;
