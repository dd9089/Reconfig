----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    
-- Design Name: 
-- Module Name:    UART - TB
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


ENTITY TB IS
END TB;

ARCHITECTURE behavior OF TB IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT UART
        PORT(
                CLK_100MHZ : in  std_logic;
                BTN_UP     : in  std_logic;
                UART_RX    : in  std_logic;
                LEDS       : out  std_logic_vector(7 downto 0)
            );
    END COMPONENT;

    --Inputs
    signal CLK_100MHZ : std_logic := '0';
    signal BTN_UP : std_logic := '0';
    signal UART_RX : std_logic;

    --Outputs
    signal LEDS : std_logic_vector(7 downto 0);

    -- Clock period definitions
    constant CLK_100MHZ_period : time := 10 ns;
    constant CLK_16xbaud : time := CLK_100MHZ_period*54*16;

    signal DATA : std_logic_vector(9 downto 0);

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut: UART PORT MAP (
         CLK_100MHZ => CLK_100MHZ,
         BTN_UP => BTN_UP,
         UART_RX => UART_RX,
         LEDS => LEDS
    );

    -- Clock process definitions
    CLK_100MHZ_process :process
    begin
        CLK_100MHZ <= '0';
        wait for CLK_100MHZ_period/2;
        CLK_100MHZ <= '1';
        wait for CLK_100MHZ_period/2;
    end process;

    -- Stimulus process for 115200 baud rate
    stim_proc: process
    begin		
        UART_RX <= '1';
        wait for CLK_16xbaud;

        DATA <= B"0_10001100_1";
        wait for 0 ns;
        for i in DATA'range loop
            UART_RX <= DATA(i);
            wait for CLK_16xbaud;
        end loop;

        wait for 100 us;

        assert false
        report "End of simulation"
        severity failure;
    end process;
end;
