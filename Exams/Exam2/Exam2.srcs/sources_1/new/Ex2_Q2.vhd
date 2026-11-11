----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2026 06:36:47 PM
-- Design Name: 
-- Module Name: Ex2_Q2 - Behavioral
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

entity Ex2_Q2 is
    Port (
        D   : in std_logic;
        clk : in std_logic;
        rst : in std_logic;
        Q   : out std_logic
        );
end Ex2_Q2;

architecture Behavioral of Ex2_Q2 is
    constant SETUP_T        : time := 3 ns;
    constant HOLD_T         : time := 2 ns;
    constant CLOCK_2_Q      : time := 4 ns;
    constant RESET_2_Q      : time := 4 ns;
    constant RESOLVE_T      : time := 15 ns;
begin
    process (clk, D)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                Q <= '0' after RESET_2_Q;
            elsif D'last_event < SETUP_T then
                Q <= 'X' after CLOCK_2_Q, D after RESOLVE_T;

                report "There was a Setup time violation"
                    severity warning;
            else
                Q <= D after CLOCK_2_Q;
            end if;
        elsif clk = '1' and rst = '0' and clk'last_event < HOLD_T then
            Q <= 'X' after (CLOCK_2_Q - clk'last_event), D after (RESOLVE_T - clk'last_event);
            report "There was a Hold time violation" 
                severity warning;
        end if;
    end process;

end Behavioral;
