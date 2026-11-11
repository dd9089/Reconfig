----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/09/2026 01:15:22 AM
-- Design Name: 
-- Module Name: Ex2_Q4_A - Behavioral
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

entity Ex2_Q4_A is
    Port (
        a : in std_logic_vector (7 downto 0);
        amt1 : in std_logic_vector (2 downto 0);
        y1  : out std_logic_vector (7 downto 0));
end Ex2_Q4_A;

architecture Behavioral of Ex2_Q4_A is
    signal s1 : std_logic_vector (7 downto 0);
    signal s2 : std_logic_vector (7 downto 0);
begin
    s1 <= a(0) & a(7 downto 1) when amt1(0) = '1' else a;
    s2 <= s1(1 downto 0) & s1(7 downto 2) when amt1(1) = '1' else s1;
    y1 <= s2(3 downto 0) & s2(7 downto 4) when amt1(2) = '1' else s2;
end Behavioral;
