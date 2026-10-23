library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fa_1bit is
port ( 
    i_a    : in std_logic;
    i_b    : in std_logic;
    i_cin  : in std_logic;
    o_sum  : out std_logic;
    o_cout : out std_logic
);
end fa_1bit;

architecture Behavioral of fa_1bit is
begin
    o_sum <= i_a xor i_b xor i_cin;
    o_cout <= (i_a and i_b) or (i_cin and (i_a xor i_b));
end Behavioral;