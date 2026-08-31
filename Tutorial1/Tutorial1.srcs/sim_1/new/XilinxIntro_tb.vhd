----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/26/2026 11:50:30 PM
-- Design Name: 
-- Module Name: XilinxIntro_tb - Behavioral
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

entity XilinxIntro_tb is
--  Port ( );
end XilinxIntro_tb;

architecture Behavioral of XilinxIntro_tb is

    component XilinxIntro is
    port (
        i_a      : in std_logic;
        i_b      : in std_logic;
        i_s0     : in std_logic;
        i_s1     : in std_logic;
        o_result : out std_logic
   );
   end component;
   
   signal a      : std_logic := '0';
   signal b      : std_logic := '0';
   signal s0     : std_logic := '0';
   signal s1     : std_logic := '0';
   signal result : std_logic;
   
begin
    uut: XilinxIntro port map(
        i_a => a,
        i_b => b,
        i_s0 => s0,
        i_s1 => s1,
        o_result => result
    );
    
    stim_proc: process
    begin
        s1 <= '0'; s0 <= '0'; --NOT
        a <= '1';             --res should be 0
        wait for 10ns;
        a <= '0';             --res should be 1
        wait for 10ns;
        s1 <= '0'; s0 <='1';  --AND
        a <= '0';
        b <= '1';
        wait for 10ns;
        a <= '1';
        b <= '1';
        wait for 10ns;
        s1 <= '1'; s0 <= '0'; --OR
        a <= '0';
        b <= '0';
        wait for 10ns;
        a <= '0';
        b <= '1';
        wait for 10ns;
        s1 <= '1'; s0 <= '1'; --XOR
        a <= '1';
        b <= '1';
        wait for 10ns; 
        a <= '1';
        b <= '0';
        wait for 10 ns;
        
        wait;
    end process;
end Behavioral;
