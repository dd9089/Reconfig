----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/26/2026 11:35:45 PM
-- Design Name: 
-- Module Name: XilinxIntro - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity XilinxIntro is
port (
    i_a     : in std_logic;
    i_b     : in std_logic;
    i_s0    : in std_logic;
    i_s1    : in std_logic;
   o_result : out std_logic
);
end XilinxIntro;

architecture Behavioral of XilinxIntro is
begin

    process (i_a, i_b, i_s1, i_s0)
        variable sel : std_logic_vector(1 downto 0);

    begin
        sel := std_logic_vector'(i_s1, i_s0);
        case sel is
            when "00"   => o_result <= not i_a;
            when "01"   => o_result <= i_a and i_b;
            when "10"   => o_result <= i_a or i_b;
            when others => o_result <= i_a xor i_b;
        end case;
   end process;

end Behavioral;
