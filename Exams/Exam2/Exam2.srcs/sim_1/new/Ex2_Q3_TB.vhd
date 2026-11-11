----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/08/2026 10:58:59 PM
-- Design Name: 
-- Module Name: Ex2_Q3_TB - Behavioral
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

entity Ex2_Q3_TB is
--  Port ( );
end Ex2_Q3_TB;

architecture Behavioral of Ex2_Q3_TB is
-- b1
    constant SEND_T     : time := 10 ns;
    constant RECEIVE_T  : time := 17 ns;
    
-- b2
--    constant SEND_T    : time := 20 ns;
--    constant RECEIVE_T : time := 10 ns;
    
    signal clk_send     : std_logic := '0';
    signal clk_receive  : std_logic := '0';
    signal en           : std_logic := '0';
    signal en_level     : std_logic := '0';
    signal en_out       : std_logic := '0'; 
begin
    clk_send <= not clk_send after SEND_T / 2;
    clk_receive <= not clk_receive after RECEIVE_T / 2;
    
    sender : entity work.Ex2_Q3_Sending
        port map (
            en => en,
            clk_send => clk_send,
            en_level => en_level);
   
    receiver : entity work.Ex2_Q3_Receiving
        port map (
            en_level => en_level,
            clk_receive => clk_receive,
            en_out => en_out);
      
    --b1
    process
    begin
        wait until Falling_edge(clk_send);
        en <= '1';
        wait until Falling_edge(clk_send);
        en <= '0';
        wait for 3 * SEND_T;
        wait until Falling_edge(clk_send);
        en <= '1';
        wait until Falling_edge(clk_send);
        en <= '0';
        wait for SEND_T;
        wait until Falling_edge(clk_send);
        en <= '1';
        wait until Falling_edge(clk_send);
        en <= '0';
        wait for 9 * SEND_T;
        report "finished"
            severity failure;
    end process;
    
    -- B2
--    process
--    begin
--        wait until Rising_edge(clk_receive);
--        en <= '1';
--        wait until Rising_edge(clk_receive);
--        en <= '0';
--        wait until Rising_edge(clk_receive);
--        en <= '1';
--        wait until Rising_edge(clk_receive);
--        en <= '0';
--        wait for 2 * RECEIVE_T;
--        wait until Rising_edge(clk_receive);
--        en <= '1';
--        wait until Rising_edge(clk_receive);
--        en <= '0';
--        wait for 11 * RECEIVE_T;
--        report "finished"
--            severity failure;
--    end process;
end Behavioral;
