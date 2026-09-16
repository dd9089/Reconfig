----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/11/2026 08:58:15 PM
-- Design Name: 
-- Module Name: mux4 - Behavioral
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

entity mux4_if is
    port (
        a, b, c, d : in std_logic_vector (7 downto 0);
        sel        : in std_logic_vector (1 downto 0);
        d_out      : out std_logic_vector (7 downto 0)
    ); 
end mux4_if;

architecture Behavioral of mux4_if is
begin
    process (a, b, c, d, sel)
    begin
        if (sel = "11") then
            d_out <= a;
        else
            if (sel = "10") then
                d_out <= b;
            else
                if (sel = "01") then 
                    d_out <= c;
                else
                    d_out <= d;
                end if;
            end if;
         end if;
   end process;        

end Behavioral;
