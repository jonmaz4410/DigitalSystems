library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


---------------------------------Original Code ---------------------------
entity upcount is
    port (
        clock, resetn, E    : in std_logic;
        Q                   : out std_logic_vector(3 downto 0)
    );
end upcount;

architecture behavioral of upcount is
    signal count: std_logic_vector(3 downto 0);
begin
    process (clock, resetn)                                         --sensitivity list
    begin
        if resetn = '0' then                                        --reset is active low, so if at any point, reset is low, reset the counter
            count <= "0000";
        elsif (clock'event AND clock = '1') then                    --at the rising edge,
            if E = '1' then                                         --if the enable is active,
                count <= count + 1;                                 --increment counter
            else
                count <= count;                                    
            end if;
        end if;
    end process;
    Q <= count;                                                     
end behavioral;

---------------------------------Updated code ---------------------------

entity upcount is

    generic (
        N                   : integer := 4                          -- declaration of generic, set to 4
    );
    
    port (
        clock, resetn, E    : in std_logic;
        Q                   : out std_logic_vector(N-1 downto 0)    --updated out vector based on generic
    );
end upcount;

architecture behavioral of upcount is
    signal count: std_logic_vector(n-1 downto 0);                   --updated signal count based on generic
begin
    process (clock, resetn)
    begin
        if resetn = '0' then
            count <= (others => '0');                               --# of output digits is based on N, used others to make code reusable
        elsif (clock'event AND clock = '1') then
            if E = '1' then
                count <= count + 1;
            else
                count <= count;
            end if;
        end if;
    end process;
    Q <= count;
end behavioral;