
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fpga_top is
end tb_fpga_top;

architecture behavior of tb_fpga_top is

    signal  clk        :  std_logic:='0';
    signal  sys_rst    :  std_logic:='1';
    signal  i_UART_RX  :  std_logic:='1';
    signal  o_UART_TX  :  std_logic;

    -- Clock period definitions
    constant  clk_period   :  time     :=  10 ns;
    constant  clk_per_sym  :  integer  :=  868;
    constant  symbol_len   :  time     :=  clk_period*clk_per_sym;  --   100  MHz  /  115200  =  868.1  clock/symbol

    component fpga_top_BRAM is
        port(
            clk_100MHz  :  in     std_logic;
            sys_rst     :  in     std_logic;
            i_UART_RX   :  in     std_logic;
            o_UART_TX   :  out    std_logic
        );
    end component;

begin

    fpga_top_BRAM_0 : fpga_top_BRAM
    port map(
        clk_100MHz           => clk,
        sys_rst              => sys_rst,
        i_UART_RX            => i_UART_RX,
        o_UART_TX            => o_UART_TX
    );

    -- Clock process definitions
    process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    process
        procedure send_char(
            chr : in unsigned(7 downto 0)
        ) is begin
            i_UART_RX <= '0';
            wait for symbol_len;
            for i in 0 to chr'high loop
                i_UART_RX <= chr(i);
                wait for symbol_len;
            end loop;
            i_UART_RX <= '1';
            wait for symbol_len;
        end send_char;

        procedure rx_char(
            chr : out integer
        ) is
            variable vect : std_logic_vector(7 downto 0);
        begin
            if o_UART_TX /= '0' then        -- in case UART is started
                wait until o_UART_TX = '0'; -- start
            end if;
            wait for symbol_len/2; -- center
            wait for symbol_len; -- start bit
            for i in 0 to vect'high loop
                vect(i) := o_UART_TX;
                wait for symbol_len;
            end loop;
            chr := to_integer(unsigned(vect));
            wait for symbol_len/2;
        end rx_char;
        
        variable v : integer;
    begin
        wait for 200 ns;
        sys_rst <= '0';
        wait for 200 ns; -- wait for ui_clk_sync_rst
        
        send_char(x"A2");
        send_char(x"B4");
        send_char(x"C5");
         
        i_UART_RX <= '0';
        wait for symbol_len;
        for i in 0 to 7 loop
            i_UART_RX <= std_logic(to_unsigned(16#32#, 8)(i));
            wait for symbol_len;
        end loop;
        i_UART_RX <= '1';           -- stop bit (line stays high)

        rx_char(v);
        assert v = 16#A2# report "byte 0 wrong" severity error;
        rx_char(v);
        assert v = 16#B4# report "byte 1 wrong" severity error;
        rx_char(v);
        assert v = 16#C5# report "byte 2 wrong" severity error;
        rx_char(v);
        assert v = 16#32# report "byte 3 wrong" severity error;

        assert false
            report "End of simulation"
            severity failure;

    end process;

end behavior;

