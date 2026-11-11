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

entity Ex2_Q3_Sending is
    Port ( 
        en          : in std_logic;
        clk_send    : in std_logic;
        en_level    : out std_logic
        );
end Ex2_Q3_Sending;

architecture Behavioral of Ex2_Q3_Sending is
    signal q : std_logic := '0';
begin
    process (clk_send)
    begin
        if rising_edge(clk_send) then
            if en = '1' then
                q <= not q;
            else
                q <= q;
            end if;
        end if;
    end process;
    
    en_level <= q;
end Behavioral;
