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
