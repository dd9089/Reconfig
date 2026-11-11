----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/13/2026 12:55:08 PM
-- Design Name: 
-- Module Name: AXIS_UART_RX - Behavioral
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

entity AXIS_UART_TX is
  Port (
    data_in : in std_logic_vector (7 downto 0);
    almost_empty      : in std_logic;
    CLK_100MHZ        : in std_logic;
    sclk_en_16_x_baud : in std_logic;
    valid             : in std_logic;
    ready             : out std_logic;
    UART_TX           : out std_logic );
end AXIS_UART_TX;

architecture Behavioral of AXIS_UART_TX is
    component MLUART_TX is
        port(
            CLK_100MHZ          : in std_logic;
            clk_en              : in std_logic;
            data_in             : in std_logic_vector (7 downto 0);
            send_data           : in std_logic;
            UART_TX             : out std_logic;
            send_data_complete  : out std_logic );
    end component;
        
    signal send_data_complete : std_logic;
    signal send_data : std_logic := '0';
    signal tx_data   : std_logic_vector (7 downto 0) := (others => '0');
    signal busy      : std_logic := '0';
       
begin
    ready <= not busy;
    
    TX_inst : MLUART_TX port map
    ( CLK_100MHZ         => CLK_100MHZ,
      clk_en             => sclk_en_16_x_baud,
      send_data_complete => send_data_complete,
      data_in            => tx_data,
      send_data          => send_data,
      UART_TX            => UART_TX);
    
    process(CLK_100MHZ)
    begin
        if CLK_100MHZ'event and CLK_100MHZ = '1' then
            send_data <= '0';
            if valid = '1' and busy = '0' then
                tx_data <= data_in;
                send_data <= '1';
                busy <= '1';
            elsif send_data_complete = '1' then
                busy <= '0';
            end if;
        end if;
    end process;
end Behavioral;
