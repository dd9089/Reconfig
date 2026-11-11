----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/09/2026 01:28:13 AM
-- Design Name: 
-- Module Name: Ex2_Q4_B - Behavioral
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

entity Ex2_Q4_B is
    Port (
        a : in Integer;
        b : in Integer;
        c : in Integer;
        d : in Integer;
        y1 : out Integer);
end Ex2_Q4_B;

architecture Behavioral of Ex2_Q4_B is
begin
    process (a, b, c, d)
        variable var1 : Integer;
        variable var2 : Integer;
    begin
        if c > d then
            var1 := a;
            var2 := b;
        elsif a < b then
            var1 := a;
            var2 := c;
        else
            var1 := d;
            var2 := 1;
        end if;
        y1 <= var1 + var2;
    end process;

end Behavioral;
