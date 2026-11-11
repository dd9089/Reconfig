----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/08/2026 09:44:50 PM
-- Design Name: 
-- Module Name: Ex2_Q2_TB - Behavioral
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

entity Ex2_Q2_TB is
--  Port ( );
end Ex2_Q2_TB;

architecture Behavioral of Ex2_Q2_TB is
    constant CLK_PERIOD_T  : time := 20 ns;
    
    signal clk              : std_logic := '0';
    signal rst              : std_logic := '0';
    signal D                : std_logic := '0';
    signal Q                : std_logic := '0';
begin
    UUT : entity work.Ex2_Q2
        port map (
            D   => D,
            clk => clk,
            rst => rst,
            Q   => Q
        );
    
    clk <= not clk after CLK_PERIOD_T /2;
    
    process
    begin
        rst <= '1'; 
        D <= '0';
        wait for 15 ns;
        rst <= '0';
        wait for 5 ns;
        D <= '1';
        wait for 20 ns;
        D <= '0';
        wait for 29 ns;
        D <= '1';
        wait for 42 ns;
        D <= '0';
        wait for CLK_PERIOD_T;
        report "Finished"
            severity failure;    
    end process;
end Behavioral;
