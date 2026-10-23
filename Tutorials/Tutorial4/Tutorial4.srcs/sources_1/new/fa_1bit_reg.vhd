library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- i_* indicates input
-- o_* indicates output
-- *_d0 indicates 0 clock cycles of delay
-- *_d2 indicates 2 clock cycles of delay (after d0) 
entity fa_1bit_reg is
port ( 
    i_clk     : in std_logic;
    i_a_d0    : in std_logic;
    i_b_d0    : in std_logic;
    i_cin_d0  : in std_logic;
    o_sum_d2  : out std_logic;
    o_cout_d2 : out std_logic
);
end fa_1bit_reg;

architecture Behavioral of fa_1bit_reg is
    signal a_d1 : std_logic;
    signal b_d1 : std_logic;
    signal cin_d1 : std_logic;
    signal sum_d1 : std_logic;
    signal cout_d1 : std_logic;
    
begin
    process (i_clk) 
    begin
        -- in a clocked process, signals get delayed by a cycle 
        -- (d0 -> d1, d1 -> d2, etc)
        if rising_edge(i_clk) then
            a_d1 <= i_a_d0;
            b_d1 <= i_b_d0;
            cin_d1 <= i_cin_d0;
            
            o_sum_d2 <= sum_d1;
            o_cout_d2 <= cout_d1;
        end if;
    end process;
    
    sum_d1 <= a_d1 xor b_d1 xor cin_d1;
    cout_d1 <= (a_d1 and b_d1) or (cin_d1 and (a_d1 xor b_d1));
    
end Behavioral;
