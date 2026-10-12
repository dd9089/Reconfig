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

entity UART is
    port(
            CLK_100MHZ : in  std_logic;	                     -- Main FPGA clock
            UART_RX	   : in std_logic;	                     -- UART TX (transmit)
            LEDs       : out std_logic_vector (7 downto 0)   -- Display the code
        );
end UART;

architecture RTL of UART is
    component MLUART_RX is
        port ( CLK_100MHZ         : in std_logic;
               clk_en_16_x_baud   : in std_logic;
               read_data_complete : out std_logic;
               data_out           : out std_logic_vector(7 downto 0);
               UART_RX            : in std_logic);
    end component;

    signal scount12 : unsigned (11 downto 0) := (others => '0');
    signal sclk_en_16_x_baud : std_logic := '0';

    signal read_data : std_logic_vector(7 downto 0);
    signal read_data_complete : std_logic;

begin
    process(CLK_100MHZ)
    begin
        if CLK_100MHZ'event and CLK_100MHZ = '1' then
            if sclk_en_16_x_baud = '1' then
                if read_data_complete = '1' then
                    LEDS <= read_data;
                end if;
            end if;
        end if;
    end process;

    RX_inst : MLUART_RX port map
    ( CLK_100MHZ         => CLK_100MHZ,
      clk_en_16_x_baud   => sclk_en_16_x_baud,
      read_data_complete => read_data_complete,
      data_out           => read_data,
      UART_RX            => UART_RX);


    -- clock enable according to the required baud value
    process(CLK_100MHZ)
    begin
        if CLK_100MHZ'event and CLK_100MHZ = '1' then
            -- if scount = X"28B" then  ----  for    9600 baud : 100 MHZ / (16 * 9600)   = 651 => 0x28B /
            if scount12 = X"36" then    ----  for  115200 baud : 100 MHZ / (16 * 115200) =  54 => 0x 36 /
                scount12 <= (others => '0');
            else
                scount12 <= scount12 + 1;
            end if;
        end if;
    end process;

    sclk_en_16_x_baud <= '1' when scount12 = X"36" else '0';

end RTL;

