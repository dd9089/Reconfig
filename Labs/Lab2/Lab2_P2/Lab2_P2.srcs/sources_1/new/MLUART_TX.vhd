----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/12/2026 05:38:30 PM
-- Design Name: 
-- Module Name: MLUART_TX - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MLUART_TX is
  Port (
    CLK_100MHZ          : in std_logic;
    clk_en              : in std_logic;
    data_in             : in std_logic_vector (7 downto 0);
    send_data           : in std_logic;
    UART_TX             : out std_logic;
    send_data_complete  : out std_logic );
end MLUART_TX;

architecture RTL of MLUART_TX is
    type tstateTX is (idle, tstart, tstop, td0, td1, td2, td3, td4, td5, td6, td7, write_strobe);
    signal sstateTX     : tstateTX;
    signal scount4      : std_logic_vector (3 downto 0) := (others => '0');
    signal sdata        : std_logic_vector (7 downto 0);
begin
    
    -- State Machine Process
    process (CLK_100MHZ)
    begin
        if rising_edge(CLK_100MHZ) then
            if sstateTX = idle then
                if send_data = '1' then
                    sstateTX <= tstart;
                end if;
            elsif clk_en = '1' then
                case sstateTX is
                    when tstart => 
                        if scount4 = X"F" then
                            sstateTX <= td0;
                        end if;
                    when td0 =>
                        if scount4 = X"F" then
                            sstateTX <= td1;
                        end if;
                    when td1 =>  
                        if scount4 = X"F" then
                            sstateTX <= td2;
                        end if;
                    when td2 =>
                        if scount4 = X"F" then
                            sstateTX <= td3;
                        end if;
                    when td3 =>
                        if scount4 = X"F" then
                            sstateTX <= td4;
                        end if;
                    when td4 =>
                        if scount4 = X"F" then
                            sstateTX <= td5;
                        end if;
                    when td5 => 
                        if scount4 = X"F" then
                            sstateTX <= td6;
                        end if;
                    when td6 =>
                        if scount4 = X"F" then
                            sstateTX <= td7;
                        end if;
                    when td7 =>
                        if scount4 = X"F" then
                            sstateTX <= tstop;
                        end if;
                    when tstop => 
                        if scount4 = X"F" then
                            sstateTX <= write_strobe;
                        end if;
                    when write_strobe => sstateTX <= idle;
                    when others => sstateTX <= idle;
                end case;
           end if;
        end if;
    end process;
    
    --Data Latch
    process (send_data) 
    begin
        if send_data = '1' then
            sdata <= data_in;
        end if;
    end process;
    
    -- State Machine Output
    process (sstateTX) 
    begin
        case sstateTX is
            when write_strobe => send_data_complete <= '1';
            when others       => send_data_complete <= '0';
        end case;
    end process;
    
    --Datapath
    
    --counter
    process (CLK_100MHZ)
    begin
        if rising_edge(CLK_100MHZ) then
            if clk_en = '1' then
                case sstateTX is
                    when tstart | td0 | td1 | td2 | td3 | td4 | td5 | td6 | td7 | tstop =>
                        scount4 <= scount4 + '1';
                     when others => scount4 <= (others => '0');
                end case;
            end if;
        end if;
    end process;
    
    --Data drive
    process (CLK_100MHZ) 
    begin
        if rising_edge(CLK_100MHZ) then
            if clk_en = '1' then
                case sstateTX is
                    when tstart => UART_TX <= '0';
                    when td0 => UART_TX <= sdata(0);
                    when td1 => UART_TX <= sdata(1);
                    when td2 => UART_TX <= sdata(2);
                    when td3 => UART_TX <= sdata(3);
                    when td4 => UART_TX <= sdata(4);
                    when td5 => UART_TX <= sdata(5);
                    when td6 => UART_TX <= sdata(6);
                    when td7 => UART_TX <= sdata(7);
                    when others => UART_TX <= '1';
                end case;
            end if;
        end if;
    end process;
end RTL;
