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