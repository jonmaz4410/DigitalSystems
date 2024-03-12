library ieee;
use ieee.std_logic_1164.all;

entity reg_file_tb is
-- Don't put anything in the entity.
end reg_file_tb;

architecture behavioral of reg_file_tb is
    --Add the component to be tested, here we are testing the whole thing, the wrapper.
    component reg_file is
        
        port (
            clk     : in std_logic;
            rst     : in std_logic;
            we      : in std_logic;
            addr    : in std_logic_vector(2 downto 0);
            din     : in std_logic_vector(3 downto 0);
            dout    : out std_logic_vector(3 downto 0)
        );
    end component;
    
    constant period : time := 10 ns;
    --Create a signal for whatever inputs and outputs you have.
    signal clk_tb   : std_logic;
    signal rst_tb   : std_logic;
    signal we_tb    : std_logic;
    signal addr_tb  : std_logic_vector(2 downto 0);
    signal din_tb   : std_logic_vector(3 downto 0);
    signal dout_tb  : std_logic_vector(3 downto 0);

begin
    --instantiation of unit under testing
    reg_file_inst: reg_file
    port map(
        -- BEFORE ARROW == I/O OF COMPONENTS
        -- AFTER ARROW == FROM TOP LEVEL
    
            clk     => clk_tb,
            rst     => rst_tb,
            we      => we_tb, 
            addr    => addr_tb, 
            din     => din_tb, 
            dout    => dout_tb
    );
    
    clk_gen: process
    begin
        clk_tb <= '0';
        wait for period/2; --wait for 5 ns
        clk_tb <= '1';
        wait for period/2;
    end process;
    
    tb: process
    begin
    --disable reset
    
        rst_tb <= '1';
    --write
    
        we_tb <= '1';
        addr_tb <= "000";
        din_tb <= "0000";
        wait for period;
        
        addr_tb <= "001";
        din_tb <= "0001";
        wait for period;
        
        addr_tb <= "010";
        din_tb <= "0010";
        wait for period;
        
        addr_tb <= "011";
        din_tb <= "0011";
        wait for period;
        
        addr_tb <= "100";
        din_tb <= "0100";
        wait for period;
        
        addr_tb <= "101";
        din_tb <= "0101";
        wait for period;
        
        addr_tb <= "110";
        din_tb <= "0110";
        wait for period;
        
        addr_tb <= "111";
        din_tb <= "0111";
        wait for period;
        we_tb <= '0';
    
    -- read
    
        addr_tb <= "000";
        wait for period;
        
        addr_tb <= "001";
        wait for period;
        
        addr_tb <= "010";
        wait for period;
        
        addr_tb <= "011";
        wait for period;
        
        addr_tb <= "100";
        wait for period;
        
        addr_tb <= "101";
        wait for period;
        
        addr_tb <= "110";
        wait for period;
        
        addr_tb <= "111";
        wait for period;
        
        --reset
        
        rst_tb <= '0';
        wait for 1 ns;
        rst_tb <= '1';
        
        --recheck registers
        
        addr_tb <= "000";
        wait for period;
        
        addr_tb <= "001";
        wait for period;
        
        addr_tb <= "010";
        wait for period;
        
        addr_tb <= "011";
        wait for period;
        
        addr_tb <= "100";
        wait for period;
        
        addr_tb <= "101";
        wait for period;
        
        addr_tb <= "110";
        wait for period;
        
        addr_tb <= "111";
        wait for period;
        
        wait;
        end process;
        
        
end behavioral;