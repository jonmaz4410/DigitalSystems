-- Full Adder

library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
    port(       
        a: in std_logic;
        b: in std_logic;
        cin: in std_logic;
        cout: out std_logic;
        sum: out std_logic  
    );
end full_adder;

architecture dataflow of full_adder is
    signal a_xor_b: std_logic;
begin
    a_xor_b <= a xor b;
    sum <= cin xor a_xor_b;
    cout <= b when a_xor_b = '0' else cin;

end dataflow;

-- Carry Save Multiplier

library ieee;
use ieee.std_logic_1164.all;

entity carry_save_mult is
    -- add generic n
    generic (n : integer  := 8);
    port(
        a: in std_logic_vector(n-1 downto 0);
        b: in std_logic_vector(n-1 downto 0);
        p: out std_logic_vector(2*n-1 downto 0)
    );
end carry_save_mult;

architecture structural of carry_save_mult is
    -- add full_adder as component

    component full_adder is
    port(       
        a: in std_logic;
        b: in std_logic;
        cin: in std_logic;
        cout: out std_logic;
        sum: out std_logic  
    );
    end component;

    -- variable array of n-bit std_logic_vector
    type arr2d is array (integer range <>) of std_logic_vector(n-1 downto 0);
    -- signal ab has dimensions (n x n)
    signal ab : arr2d(0 to n-1);

    -- full_adder signals, all have dimension ((n-1) x n)
    signal FA_a    : arr2d(0 to n-2);
    signal FA_b    : arr2d(0 to n-2);
    signal FA_cin  : arr2d(0 to n-2);
    signal FA_sum  : arr2d(0 to n-2);
    signal FA_cout : arr2d(0 to n-2);
    
begin
    -- use nested for-generate to assign values to ab 2D-array
    gen_ab_rows: for i in 0 to n-1 generate
        gen_ab_cols: for j in 0 to n-1 generate
            ab(i)(j) <= a(i) and b(j);
        -- write code here
        end generate;
    end generate;
    
      gen_FA_rows: for i in 0 to n-2 generate
        gen_Fa_cols: for j in 0 to n-1 generate
            full_adder_inst: full_adder
            port map (
                a => FA_a(i)(j),
                b => FA_b(i)(j),
                cin => FA_cin(i)(j),
                cout => FA_cout(i)(j),
                sum => FA_sum(i)(j)
            );
        -- write code here
        end generate;
    end generate;

    -- First row:
        FA_a(0) <= '0' & ab(0)(n-1 downto 1);
        FA_b(0) <= ab(1)(n-1 downto 0);
        FA_cin(0) <= ab(2)(n-2 downto 0) & '0';
         
    -- Intermediate rows:
        gen_FA_rowmid: for i in 1 to n-3 generate
            FA_a(i) <= ab(i+1)(n-1) & FA_sum(i-1)(n-1 downto 1);
            FA_b(i) <= FA_cout(i-1)(n-1 downto 0);
            FA_cin(i) <= ab(i+2)(n-2 downto 0) & '0';
        end generate;
    -- Last row:
        FA_a(n-2) <= ab(n-1)(n-1) & FA_sum(n-3)(n-1 downto 1);
        FA_b(n-2) <= FA_cout(n-3)(n-1 downto 0);
        fa_cin(n-2) <= FA_cout(n-2)(n-2 downto 0) & '0';    
    -- finally, do the last steps to compute the product.
        p(0) <= ab(0)(0);
        product: for i in 1 to n-2 generate
            p(i) <= FA_sum(i-1)(0);
        end generate;
        p(2*n-2 downto n-1) <= FA_sum(n-2)(n-1 downto 0);
        p(2*n-1) <= FA_cout(n-2)(n-1);
end structural;

-- MULT WRAPPER
library ieee;
use ieee.std_logic_1164.all;

entity mult is
    port(
        clk     : in std_logic;
        a       : in std_logic_vector (7 downto 0);
        b       : in std_logic_vector (7 downto 0);
        p       : out std_logic_vector (15 downto 0)
    );
end mult;

architecture structural of mult is

component carry_save_mult is
    -- add generic n
    generic (n : integer  := 8);
    port(
        a: in std_logic_vector(n-1 downto 0);
        b: in std_logic_vector(n-1 downto 0);
        p: out std_logic_vector(2*n-1 downto 0)
    );
end component;
    -- add carry_save_mult as a component
    -- we don't need to the full_adder as component here

    -- signals
    signal a_reg  : std_logic_vector(7 downto 0);
    signal b_reg  : std_logic_vector(7 downto 0);
    signal p_s    : std_logic_vector(15 downto 0);
    
begin

    carry_save_mult_inst: carry_save_mult
    port map (
    
    a => a_reg,
    b => b_reg,
    p => p_s
    
    );


    reg_mult : process(clk)
    begin
        if rising_edge(clk) then
            -- on the rising edge, make the signals equal
            -- to the inputs and outputs carry_save_mult
            a_reg <= a;
            b_reg <= b;
            p <= p_s;
            
        end if;
    end process;

end structural;

--Testbench

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

entity mult_tb is
end mult_tb;

architecture behavioral of mult_tb is
    -- ADD "mult8x8.dat" AS A SIMULATION SOURCE FIRST

    -- file variable to read data from
    file MULT_FILE : text OPEN READ_MODE is "mult8x8.dat";
    constant period: TIME := 10 ns;

    -- create period constant

    -- mult components
    component mult is
        port(
            clk     : in std_logic;
            a       : in std_logic_vector (7 downto 0);
            b       : in std_logic_vector (7 downto 0);
            p       : out std_logic_vector (15 downto 0)
        );
    end component;
    -- add signals
   signal clk_tb:           std_logic;
   signal a_tb:             std_logic_vector (7 downto 0);
   signal b_tb:             std_logic_vector (7 downto 0);
   signal p_tb:             std_logic_vector (15 downto 0);
    
    
begin
    -- instantiate mult component and complete the port map for it
    mult_inst: mult
    port map (
    clk => clk_tb,
    a => a_tb,
    b => b_tb,
    p => p_tb
    );

    -- generate the process for the clock similar to previous lab 0 and lab 2
    
    clk_gen: process
    begin
        clk_tb <= '0';
        wait for period/2;
        clk_tb <= '1';
        wait for period/2;
    end process;

    -- variables for reading for MULT_FILE
    tb: process
        variable cur_line   : integer := 1;
        variable v_line     : line;
        variable v_space    : character;
        variable v_a        : std_logic_vector(7 downto 0);
        variable v_b        : std_logic_vector(7 downto 0);
        variable v_p_exp    : std_logic_vector(15 downto 0);

    begin
        while not endfile(MULT_file) loop
            readline(MULT_FILE, v_line);
            hread(v_line, v_a);
            read(v_line, v_space);
            hread(v_line, v_b);
            read(v_line, v_space);
            hread(v_line, v_p_exp);
            
            
            a_tb <= v_a;
            b_tb <= v_b;
            
            wait for 2*period;
            
            assert p_tb = v_p_exp
                report "Actual result not matching expected result at line " & integer'image(cur_line)
                    severity failure;
            
            cur_line := cur_line + 1;
        end loop;
        
        report "Simulation complete";
        wait;            

    end process;
    

end behavioral;

