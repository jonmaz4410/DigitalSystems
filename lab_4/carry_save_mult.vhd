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
    
    

    -- Figure 3 shows that we will use ((n-1) x n) full adders
    -- use nested for-generate to instantiate each full_adder component.
    -- ports are mapped to each bit of the 2D-arrays FA_a, FA_b, FA_cin, FA_sum, FA_cout
    
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

    -- after instantiating the full adders, we need to assign values 
    -- for the inputs of the FAs.
    -- use the three patterns from the pdf to complete this part
    -- and assign values to each row.

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
