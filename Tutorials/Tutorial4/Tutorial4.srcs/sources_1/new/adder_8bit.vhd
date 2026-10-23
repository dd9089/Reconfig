library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder_8bit is
port ( 
    i_a    : in std_logic_vector(7 downto 0);
    i_b    : in std_logic_vector(7 downto 0);
    o_sum  : out std_logic_vector(7 downto 0);
    o_cout : out std_logic
);
end adder_8bit;

architecture Behavioral of adder_8bit is
    signal sum : std_logic_vector(8 downto 0); -- room for carry out
begin   
    sum <= std_logic_vector(unsigned('0' & i_a) + unsigned('0' & i_b));
    
    o_sum <= sum(7 downto 0);
    o_cout <= sum(8);
end Behavioral;
