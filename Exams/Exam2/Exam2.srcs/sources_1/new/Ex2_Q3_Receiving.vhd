----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/08/2026 10:24:05 PM
-- Design Name: 
-- Module Name: Ex2_Q3_Sending - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Ex2_Q3_Receiving is
    Port ( 
        en_level    :in std_logic;
        clk_receive : in std_logic;
        en_out      : out std_logic
        );
end Ex2_Q3_Receiving;

architecture Behavioral of Ex2_Q3_Receiving is
    signal q : std_logic_vector (2 downto 0)   := (others => '0');
begin
    process (clk_receive)
    begin
        if rising_edge(clk_receive) then
            q <= q(1 downto 0) & en_level;
        end if;
    end process;
    
    process (q) 
    begin
        en_out <= q(1) XOR q(2);
    end process;
end Behavioral;
