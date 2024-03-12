library ieee;
use ieee.std_logic_1164.all;

entity reg_file is
    generic (n: integer := 4);
    port (
        clk     : in std_logic;
        rst     : in std_logic;
        we      : in std_logic;
        addr    : in std_logic_vector(2 downto 0);
        din     : in std_logic_vector(3 downto 0);
        dout    : out std_logic_vector(3 downto 0)
        );
end reg_file;

architecture structural of reg_file is

component reg_module is
    generic (n: integer := 4);
    port (
        clk     : in std_logic;
        rst     : in std_logic;
        we      : in std_logic;
        din     : in std_logic_vector(n-1 downto 0);
        dout    : out std_logic_vector(n-1 downto 0)
        );
end component;

component decoder_3to8 is
    port (
        en          : in std_logic;
        din         : in std_logic_vector(2 downto 0);
        dout        : out std_logic_vector(7 downto 0)
        );
end component;

component mux_8to1 is
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
end component;
--reg enable
signal reg_en : std_logic_vector(7 downto 0);
--mux input, new type
type array_8of4 is array (0 to 7) of std_logic_vector(3 downto 0);
signal mux_in: arrayu__8of4;

begin

--label: component name
--generic map
--port map

decoder_inst: decoder_3to8
port map (
    en      =>  we,
    din     =>  addr,
    dout    =>  reg_en
);

mux_inst: mux_8to1
generic map (n => 4)
port map (
    sel     =>  addr,
    din0    =>  mux_in(0),
    din1    =>  mux_in(1),
    din2    =>  mux_in(2),
    din3    =>  mux_in(3),
    din4    =>  mux_in(4),
    din5    =>  mux_in(5),
    din6    =>  mux_in(6),
    din7    =>  mux_in(7),
    dout    =>  dout
    );
 
reg_module_gen : for i in 0 to 7 generate
    reg_module_inst: reg_module
    generic map ( n => 4)
    port map (
        clk          => clk,
        rst          => rst,
        we           => reg_en(i),
        din          => din,
        dout         => mux_in(i)
);

end generate;
end structural;