library ieee;
use ieee.std_logic_1164.all;

entity mux_8to1 is
    generic (n: integer := 4);
    port (
        sel      : in std_logic_vector(2 downto 0);
        din0     : in std_logic_vector(n-1 downto 0);
        din1     : in std_logic_vector(n-1 downto 0);
        din2     : in std_logic_vector(n-1 downto 0);
        din3     : in std_logic_vector(n-1 downto 0);
        din4     : in std_logic_vector(n-1 downto 0);
        din5     : in std_logic_vector(n-1 downto 0);
        din6     : in std_logic_vector(n-1 downto 0);
        din7     : in std_logic_vector(n-1 downto 0);
        dout     : out std_logic_vector(n-1 downto 0)
        );
end mux_8to1;

architecture dataflow of mux_8to1 is

begin
    with sel select
        dout <= din0 when "000",
                din1 when "001",
                din2 when "010",
                din3 when "011",
                din4 when "100",
                din5 when "101",
                din6 when "110",
                din7 when others;

end dataflow;

