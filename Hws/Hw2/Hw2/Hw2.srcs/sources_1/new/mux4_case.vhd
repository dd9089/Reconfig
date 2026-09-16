----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/11/2026 09:07:53 PM
-- Design Name: 
-- Module Name: mux4_case - Behavioral
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

entity mux4_case is
  Port ( 
        a, b, c, d : in std_logic_vector (7 downto 0);
        sel        : in std_logic_vector (1 downto 0);
        d_out      : out std_logic_vector (7 downto 0)
  );
end mux4_case;

architecture Behavioral of mux4_case is
begin
    process (a, b, c, d, sel)
    begin
        case sel is
            when "11" => d_out <= a;
            when "10" => d_out <= b;
            when "01" => d_out <= c;
            when others => d_out <= d;
        end case;
    end process;
 end Behavioral;
