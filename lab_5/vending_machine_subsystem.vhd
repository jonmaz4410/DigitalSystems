-- SODA LIST
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity soda_list is
    
    port(
    -- ADD PORTS
    
    soda_sel: in std_logic_vector (3 downto 0);
    soda_reserved: out std_logic;
    soda_price: out std_logic_vector(11 downto 0)
    );
end soda_list;

architecture data_flow of soda_list is

begin
    with soda_sel select
        soda_price  <=  x"037" when "0000",
                        x"055" when "0001",
                        x"05F" when "0010",
                        x"07D" when "0011",
                        x"087" when "0100",
                        x"096" when "0101",
                        x"0E1" when "0110",
                        x"0FA" when "0111",
                        x"12C" when "1000",
                        x"000" when others;

with soda_sel select
        soda_reserved  <=   '1' when "1001",
                            '1' when "1010",
                            '1' when "1011",
                            '1' when "1100",
                            '1' when "1101",
                            '1' when "1110",
                            '1'when "1111",
                            '0' when others;
                        
                        
                        
end data_flow;


-- COIN LIST
library ieee;
use ieee.std_logic_1164.all;

entity coin_list is
    -- ADD PORTS
    port(
        coin_sel: in std_logic_vector(1 downto 0);
        coin_amt: out std_logic_vector(11 downto 0)
    );
    
end coin_list;

architecture data_flow of coin_list is

begin
    -- ADD ARCHITECTURE
    with coin_sel select
        coin_amt <=     x"001" when "00",
                        x"005" when "01",
                        x"00A" when "10",
                        x"019" when "11",
                        x"000" when others;
end data_flow;


-- DEPOSIT REGISTER
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity deposit_register is
    port(
        clk       : in  std_logic;
        rst       : in  std_logic;
        incr      : in  std_logic;
        incr_amt  : in  std_logic_vector(11 downto 0);
        decr      : in  std_logic;
        decr_amt  : in  std_logic_vector(11 downto 0);
        amt       : out std_logic_vector(11 downto 0) 
    );
end deposit_register;

architecture behavioral of deposit_register is
    signal amt_reg : std_logic_vector(11 downto 0);
begin
    DEPOSIT_REG : process(clk)
    begin
        -- ADD REGISTER PROCESS
        if rising_edge(clk) then
            if rst = '0' then
                amt_reg <= x"000";
            elsif incr = '1' then
                amt_reg <= std_logic_vector(unsigned(amt_reg) + unsigned(incr_amt));
            elsif decr = '1' then
                amt_reg <= std_logic_vector(unsigned(amt_reg) - unsigned(decr_amt));
            end if;
        end if;
    end process;
    
    
    amt <= amt_reg; -- output is set equal to the signal
end behavioral;


-- VENDING MACHINE CONTROLLER
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vending_machine_ctrl is
    port(
        clk               : in  std_logic;
        rst               : in  std_logic;

        lock              : in  std_logic;

        soda_reserved     : in  std_logic;
        soda_price        : in  std_logic_vector(11 downto 0);
        soda_req          : in  std_logic;
        soda_drop         : out std_logic;
        
        deposit_amt       : in  std_logic_vector(11 downto 0);
        deposit_incr      : out std_logic;
        deposit_decr      : out std_logic;
        
        coin_push         : in  std_logic;
        coin_amt          : in  std_logic_vector(11 downto 0);
        coin_reject       : out std_logic;
        
        error_amt         : out std_logic;
        error_reserved    : out std_logic
    );
end vending_machine_ctrl;

architecture behavioral of vending_machine_ctrl is
    -- CREATE FSM SIGNAL
type FSM_state is   (IDLE, SODA_CHECK, SODA_DECLINE_RESERVED, SODA_DECLINE_AMT, SODA_ACCEPT, SODA_ACCEPT_WAIT,
                    COIN_ACCEPT, COIN_CHECK, COIN_DECLINE);
    signal state: FSM_state;
                        
begin
    FSM: PROCESS (CLK)
    begin
        if rising_edge(clk) then
            if rst = '0' then
                state <= idle;
            end if;
            
            case state is
                when IDLE =>
                    if soda_req = '1' then
                        state <= soda_check;
                    elsif coin_push = '1' then
                        state <= coin_check;
                    end if;
                    
                when soda_check =>
                    if soda_reserved = '1' then
                        state <= soda_decline_reserved;
                    elsif (soda_reserved /= '1' and (deposit_amt < soda_price)) then
                        state <= soda_decline_amt;  
                    elsif (soda_reserved /= '1' and (deposit_amt >= soda_price)) then
                        state <= soda_accept;
                    end if;
                
                when soda_accept =>
                    state <= soda_accept_wait;
                
                when soda_accept_wait =>
                    if lock /= '1' then
                        state <= idle;
                    end if;
                
                when soda_decline_amt =>
                    if lock /= '1' then
                        state <= idle;
                    end if;
                
                when soda_decline_reserved =>
                    if lock /= '1' then
                        state <= idle;
                    end if;
                
                when coin_check =>
                    if (((unsigned(coin_amt) + unsigned(deposit_amt))) <= x"03E8") then
                        state <= coin_accept;
                    elsif (((unsigned(coin_amt) + unsigned(deposit_amt))) > x"03E8") then
                        state <= coin_decline;
                    end if;
                
                when coin_decline =>
                    if lock /= '1' then
                        state <= idle;
                    end if;
                
                when coin_accept =>
                    state <= idle;
                
                when others =>
                    state <= idle;
            end case;
        end if;
    end process;
    
    
    deposit_decr <= '1' when (state = soda_accept) else '0';
    soda_drop <= '1' when (state = soda_accept_wait) else '0';
    error_amt <= '1' when (state = soda_decline_amt) else '0';
    error_reserved <= '1' when (state = soda_decline_reserved) else '0';
    deposit_incr <= '1' when (state = coin_accept) else '0';
    coin_reject <= '1' when (state = coin_decline) else '0';

end behavioral;


-- VENDING MACHINE SUBSYSTEM
library ieee;
use ieee.std_logic_1164.all;
entity vending_machine_subsystem is
    port(
        clk             : in  std_logic;
        rst             : in  std_logic;
        lock            : in  std_logic;
        soda_sel        : in  std_logic_vector(3 downto 0);
        soda_req        : in  std_logic;
        coin_push       : in  std_logic;
        coin_sel        : in  std_logic_vector(1 downto 0);
        coin_reject     : out std_logic;
        soda_reserved   : out std_logic;
        soda_price      : out std_logic_vector(11 downto 0);
        soda_drop       : out std_logic;
        deposit_amt     : out std_logic_vector(11 downto 0);
        error_amt       : out std_logic;
        error_reserved  : out std_logic
    );
end vending_machine_subsystem;

architecture structural of vending_machine_subsystem is
    -- ADD COMPONENTS
    
component soda_list is
    
    port(
    -- ADD PORTS
    
    soda_sel: in std_logic_vector (3 downto 0);
    soda_reserved: out std_logic;
    soda_price: out std_logic_vector(11 downto 0)
    );
end component;
    
component coin_list is
    -- ADD PORTS
    port(
        coin_sel: in std_logic_vector(1 downto 0);
        coin_amt: out std_logic_vector(11 downto 0)
    );
    
end component;

component deposit_register is
    port(
        clk       : in  std_logic;
        rst       : in  std_logic;
        incr      : in  std_logic;
        incr_amt  : in  std_logic_vector(11 downto 0);
        decr      : in  std_logic;
        decr_amt  : in  std_logic_vector(11 downto 0);
        amt       : out std_logic_vector(11 downto 0) 
    );
end component;

component vending_machine_ctrl is
    port(
        clk               : in  std_logic;
        rst               : in  std_logic;

        lock              : in  std_logic;

        soda_reserved     : in  std_logic;
        soda_price        : in  std_logic_vector(11 downto 0);
        soda_req          : in  std_logic;
        soda_drop         : out std_logic;
        
        deposit_amt       : in  std_logic_vector(11 downto 0);
        deposit_incr      : out std_logic;
        deposit_decr      : out std_logic;
        
        coin_push         : in  std_logic;
        coin_amt          : in  std_logic_vector(11 downto 0);
        coin_reject       : out std_logic;
        
        error_amt         : out std_logic;
        error_reserved    : out std_logic
    );
end component;

    -- ADD SIGNALS
    --soda_list has input soda_sel, and outputs, soda_reserved ,and soda_price
    signal soda_price_signal: std_logic_vector (11 downto 0);
    signal soda_reserved_signal: std_logic;
    signal coin_amt_signal: std_logic_vector(11 downto 0);
    signal deposit_incr_signal: std_logic;
    signal deposit_decr_signal: std_logic;
    signal deposit_amt_signal: std_logic_vector(11 downto 0);

begin
    -- INSTANTIATE ALL COMPONENTS AND CREATE THEIR PORT MAPS
    u_coin_list: coin_list
    port map(
        coin_sel => coin_sel,
        coin_amt => coin_amt_signal
    );
    
    u_vending_machine_ctrl: vending_machine_ctrl
    port map(
        clk => clk,
        rst => rst,
        lock => lock,
        soda_reserved => soda_reserved_signal,
        soda_price => soda_price_signal,
        soda_req => soda_req,
        deposit_amt => deposit_amt_signal,
        coin_push => coin_push,
        coin_amt => coin_amt_signal,
        deposit_incr => deposit_incr_signal,
        deposit_decr => deposit_decr_signal,
        soda_drop => soda_drop,
        error_amt => error_amt,
        error_reserved => error_reserved,
        coin_reject => coin_reject
    );
    
    u_soda_list: soda_list
    port map(
        soda_sel => soda_sel,
        soda_price => soda_price_signal,
        soda_reserved => soda_reserved_signal
    );
    

    
    u_deposit_register: deposit_register
    port map(
    clk => clk,
    rst => rst,
    incr => deposit_incr_signal,
    decr => deposit_decr_signal,
    incr_amt => coin_amt_signal,
    decr_amt => soda_price_signal,
    amt => deposit_amt_signal 
    );
    
    soda_price <= soda_price_signal;
    deposit_amt <= deposit_amt_signal;
    soda_reserved <= soda_reserved_signal;
    -- ASSIGN VALUES FOR THE 3 OUTPUTS THAT GO INTO 7-SEGMENT DISPLAY
end structural;
