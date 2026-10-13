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
            BTN_UP     : in std_logic;
            UART_TX    : out std_logic;
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
    
    component MLUART_TX is
        port(
            CLK_100MHZ          : in std_logic;
            clk_en              : in std_logic;
            data_in             : in std_logic_vector (7 downto 0);
            send_data           : in std_logic;
            UART_TX             : out std_logic;
            send_data_complete  : out std_logic );
    end component;
    
    COMPONENT axis_data_fifo_0
      PORT (
        s_axis_aresetn : IN STD_LOGIC;
        s_axis_aclk : IN STD_LOGIC;
        s_axis_tvalid : IN STD_LOGIC;
        s_axis_tready : OUT STD_LOGIC;
        s_axis_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        m_axis_tvalid : OUT STD_LOGIC;
        m_axis_tready : IN STD_LOGIC;
        m_axis_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        almost_empty : OUT STD_LOGIC;
        almost_full : OUT STD_LOGIC
      );
    END COMPONENT;

    signal scount12 : unsigned (11 downto 0) := (others => '0');
    signal sclk_en_16_x_baud : std_logic := '0';

    signal read_data : std_logic_vector(7 downto 0);
    signal read_data_complete : std_logic;
    
    signal send_data_complete : std_logic;
    signal send_data : std_logic := '0';
    signal tx_data   : std_logic_vector (7 downto 0) := (others => '0');
    
    signal aresetn : std_logic;
    
    signal rx_tdata: std_logic_vector (7 downto 0);
    signal rx_tvalid, rx_tready, rx_almost_full : std_logic;
    
    signal mid_tdata : std_logic_vector (7 downto 0);
    signal mid_tvalid, mid_tready : std_logic;
    
    signal tx_tdata : std_logic_vector (7 downto 0);
    signal tx_tvalid, tx_tready, tx_almost_empty : std_logic;
    
begin
    aresetn <= not BTN_UP;

    process(CLK_100MHZ)
    begin
        if CLK_100MHZ'event and CLK_100MHZ = '1' then
            send_data <= '0';
            if sclk_en_16_x_baud = '1' then
                if read_data_complete = '1' then
                    LEDS <= read_data;
                    tx_data <= read_data;
                    send_data <= '1';
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
      
    TX_inst : MLUART_TX port map
    ( CLK_100MHZ         => CLK_100MHZ,
      clk_en             => sclk_en_16_x_baud,
      send_data_complete => send_data_complete,
      data_in            => tx_data,
      send_data          => send_data,
      UART_TX            => UART_TX);

    AXIS_FIFO_RX : axis_data_fifo_0 PORT MAP 
    (   s_axis_aresetn => aresetn,
        s_axis_aclk => CLK_100MHZ,
        s_axis_tvalid => rx_tvalid,
        s_axis_tready => rx_tready,
        s_axis_tdata =>  rx_tdata,
        m_axis_tvalid => rx_tvalid,
        m_axis_tready => rx_tready,
        m_axis_tdata => mid_tdata,
        almost_empty => tx_almost_empty,
        almost_full => rx_almost_full
  );

    AXIS_FIFO_TX : axis_data_fifo_0 PORT MAP 
    (   s_axis_aresetn => aresetn,
        s_axis_aclk => CLK_100MHZ,
        s_axis_tvalid => mid_tvalid,
        s_axis_tready => mid_tready,
        s_axis_tdata => mid_tdata,
        m_axis_tvalid => tx_tvalid,
        m_axis_tready => tx_tready,
        m_axis_tdata => tx_tdata,
        almost_empty => tx_almost_empty,
        almost_full => rx_almost_full
  );

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

