----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/05/2026 03:15:51 AM
-- Design Name: 
-- Module Name: Q2 - Behavioral
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

entity Q2 is
  Port ( 
    clk, a, b, c : in std_logic;
    dout         : out std_logic
  );
end Q2;

architecture cos of Q2 is

begin

    process(clk)
        variable t1, t2: std_logic := '0';
    begin
        if (clk'event and clk='1') then
            if t2 = '1' then
                dout <= t1;
            else
                dout <= '0';
            end if;
            t1 := (a or b) and t2;
            t2 := c;
        end if;
    end process;
end architecture cos;
