----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:
-- Design Name:
-- Module Name:    UART - RTL
-- Project Name:
-- Target Devices:
-- Tool versions:
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
use  IEEE.NUMERIC_STD.ALL;

entity Ex2_Q3_TOP is
    port(
            CLK_100MHZ : in  std_logic;	                     -- Main FPGA clock
            UART_RX	   : in std_logic;	                     -- UART TX (transmit)
            BTN_UP     : in std_logic;
            UART_TX    : out std_logic;
            LEDs       : out std_logic_vector (7 downto 0)   -- Display the code
        );
end Ex2_Q3_Top;

architecture RTL of Ex2_Q3_Top is
    component Ex2_Q3_Sending is
        port ( en         : in std_logic;
               clk_send   : in std_logic;
               en_level   : out std_logic);
    end component;
    
    component Ex2_Q3_Receiving is
        port(
            en_level    : in std_logic;
            clk_receive : in std_logic;
            en_out      : out std_logic );
    end component;
    signal en : std_logic;
    signal clk_send : std_logic;
    signal en_level : std_logic;
    
    signal clk_receive : std_logic;
    signal en_out : std_logic;
begin
    Sending_inst : Ex2_Q3_Sending port map
    ( en        => en,
      clk_send  => clk_send,
      en_level  => en_level);
      
    Receiving_inst : Ex2_Q3_Receiving port map
    ( en_level      => en_level,
      clk_receive   => clk_receive,
      en_out        => en_out);


    
    process (clk_send)
    begin
        if Rising_edge(clk_send)
            
        end if;
    end process;
end RTL;

