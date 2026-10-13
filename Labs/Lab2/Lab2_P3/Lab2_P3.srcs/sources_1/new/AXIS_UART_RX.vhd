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

entity AXIS_UART_RX is
  Port ( 
    UART_RX           : in std_logic;
    almost_full       : in std_logic;
    CLK_100MHZ        : in std_logic;
    sclk_en_16_x_baud : in std_logic;
    ready             : in std_logic;
    valid             : out std_logic;
    data_out          : out std_logic_vector (7 downto 0));
end AXIS_UART_RX;

architecture Behavioral of AXIS_UART_RX is
    component MLUART_RX is
        port ( CLK_100MHZ         : in std_logic;
               clk_en_16_x_baud   : in std_logic;
               read_data_complete : out std_logic;
               data_out           : out std_logic_vector(7 downto 0);
               UART_RX            : in std_logic);
    end component;
    
    signal read_data : std_logic_vector(7 downto 0);
    signal read_data_complete : std_logic;
    signal tdata     : std_logic_vector (7 downto 0) := (others => '0');
    signal tvalid    : std_logic := '0';
        
begin

    data_out <= tdata;
    valid    <= tvalid;
    
    RX_inst : MLUART_RX port map
    ( CLK_100MHZ         => CLK_100MHZ,
      clk_en_16_x_baud   => sclk_en_16_x_baud,
      read_data_complete => read_data_complete,
      data_out           => read_data,
      UART_RX            => UART_RX);
    
    process(CLK_100MHZ)
    begin
        if CLK_100MHZ'event and CLK_100MHZ = '1' then
            if sclk_en_16_x_baud = '1' and read_data_complete = '1' and almost_full = '0' then
                tdata <= read_data;
                tvalid <= '1';
            elsif tvalid = '1' and ready = '1' then
                tvalid <= '0';
            end if;
        end if;
    end process;
end Behavioral;
