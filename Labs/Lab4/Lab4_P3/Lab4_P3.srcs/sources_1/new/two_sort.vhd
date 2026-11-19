----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2026 10:38:07 AM
-- Design Name: 
-- Module Name: two_sort - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity two_sort is
    Port (
        a : in unsigned (7 downto 0);
        b : in unsigned (7 downto 0);
        low : out unsigned (7 downto 0);
        hi : out unsigned (7 downto 0));
end two_sort;

architecture Behavioral of two_sort is
begin
    process (a, b) 
    begin
        if (a > b) then
            hi <= a;
        else
            hi <= b;
        end if;
    end process;
    
    process (a, b)
    begin
        if (a > b) then
            low <= b;
        else
            low <= a;
        end if;
    end process;
end Behavioral;
