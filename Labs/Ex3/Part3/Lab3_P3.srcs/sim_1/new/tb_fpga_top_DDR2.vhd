---------------------------------------------------------------------------------
-- Created by       :
-- Filename         : tb_fpga_top.vhd
-- Author           : Andrew Ramsey
-- Created On       : 2017-10-24 23:25
-- Last Modified    : 2017-10-25 00:30
-- Version          : v1.0
-- Description      :
--
--
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_TextIO.all;
use STD.TextIO.all;

entity tb_fpga_top is
end tb_fpga_top;

architecture behavior of tb_fpga_top is

    signal  clk        :  std_logic:='0';
    signal  sys_rst    :  std_logic:='1';
    signal  i_UART_RX  :  std_logic:='1';
    signal  o_UART_TX  :  std_logic;

    signal  s_ddr2_addr      :  std_logic_vector(12  downto  0);
    signal  s_ddr2_ba        :  std_logic_vector(2   downto  0);
    signal  s_ddr2_ras_n     :  std_logic;
    signal  s_ddr2_cas_n     :  std_logic;
    signal  s_ddr2_we_n      :  std_logic;
    signal  s_ddr2_ck_p      :  std_logic_vector(0   downto  0);
    signal  s_ddr2_ck_n      :  std_logic_vector(0   downto  0);
    signal  s_ddr2_cke       :  std_logic_vector(0   downto  0);
    signal  s_ddr2_cs_n      :  std_logic_vector(0   downto  0);
    signal  s_ddr2_dm        :  std_logic_vector(1   downto  0);
    signal  s_ddr2_odt       :  std_logic_vector(0   downto  0);
    signal  s_ddr2_dq        :  std_logic_vector(15  downto  0);
    signal  s_ddr2_dqs_p     :  std_logic_vector(1   downto  0);
    signal  s_ddr2_dqs_n     :  std_logic_vector(1   downto  0);

    -- Clock period definitions
    constant  clk_period   :  time     :=  10 ns;
    constant  clk_per_sym  :  integer  :=  868;
    constant  symbol_len   :  time     :=  clk_period*clk_per_sym;  --   100  MHz  /  115200  =  868.1  clock/symbol


    component ddr2_model is
        port(
            ck       :  in     std_logic_vector(0   downto  0);
            ck_n     :  in     std_logic_vector(0   downto  0);
            cke      :  in     std_logic_vector(0   downto  0);
            cs_n     :  in     std_logic_vector(0   downto  0);
            ras_n    :  in     std_logic;
            cas_n    :  in     std_logic;
            we_n     :  in     std_logic;
            dm_rdqs  :  inout  std_logic_vector(1   downto  0);
            ba       :  in     std_logic_vector(2   downto  0);
            addr     :  in     std_logic_vector(12  downto  0);
            dq       :  inout  std_logic_vector(15  downto  0);
            dqs      :  inout  std_logic_vector(1   downto  0);
            dqs_n    :  inout  std_logic_vector(1   downto  0);
            rdqs_n   :  out    std_logic_vector(1   downto  0);
            odt      :  in     std_logic_vector(0   downto  0)
        );
    end component;

    component fpga_top is
        port(
            clk_100MHz  :  in     std_logic;
            sys_rst     :  in     std_logic;
            i_UART_RX   :  in     std_logic;
            o_UART_TX   :  out    std_logic;
            ddr2_addr   :  out    std_logic_vector(12  downto  0);
            ddr2_ba     :  out    std_logic_vector(2   downto  0);
            ddr2_ras_n  :  out    std_logic;
            ddr2_cas_n  :  out    std_logic;
            ddr2_we_n   :  out    std_logic;
            ddr2_ck_p   :  out    std_logic_vector(0   downto  0);
            ddr2_ck_n   :  out    std_logic_vector(0   downto  0);
            ddr2_cke    :  out    std_logic_vector(0   downto  0);
            ddr2_cs_n   :  out    std_logic_vector(0   downto  0);
            ddr2_dm     :  out    std_logic_vector(1   downto  0);
            ddr2_odt    :  out    std_logic_vector(0   downto  0);
            ddr2_dq     :  inout  std_logic_vector(15  downto  0);
            ddr2_dqs_p  :  inout  std_logic_vector(1   downto  0);
            ddr2_dqs_n  :  inout  std_logic_vector(1   downto  0)
        );
    end component;

begin

    ddr2_model_0 : ddr2_model
    port map (
        ck               => s_ddr2_ck_p,
        ck_n             => s_ddr2_ck_n,
        cke              => s_ddr2_cke,
        cs_n             => s_ddr2_cs_n,
        ras_n            => s_ddr2_ras_n,
        cas_n            => s_ddr2_cas_n,
        we_n             => s_ddr2_we_n,
        dm_rdqs          => s_ddr2_dm,
        ba               => s_ddr2_ba,
        addr             => s_ddr2_addr,
        dq               => s_ddr2_dq,
        dqs              => s_ddr2_dqs_p,
        dqs_n            => s_ddr2_dqs_n,
        rdqs_n           => open,
        odt              => s_ddr2_odt
    );

    fpga_top_0 : fpga_top
    port map(
        clk_100MHz           => clk,
        sys_rst              => sys_rst,
        i_UART_RX            => i_UART_RX,
        o_UART_TX            => o_UART_TX,
        ddr2_addr            => s_ddr2_addr,
        ddr2_ba              => s_ddr2_ba,
        ddr2_ras_n           => s_ddr2_ras_n,
        ddr2_cas_n           => s_ddr2_cas_n,
        ddr2_we_n            => s_ddr2_we_n,
        ddr2_ck_p            => s_ddr2_ck_p,
        ddr2_ck_n            => s_ddr2_ck_n,
        ddr2_cke             => s_ddr2_cke,
        ddr2_cs_n            => s_ddr2_cs_n,
        ddr2_dm              => s_ddr2_dm,
        ddr2_odt             => s_ddr2_odt,
        ddr2_dq              => s_ddr2_dq,
        ddr2_dqs_p           => s_ddr2_dqs_p,
        ddr2_dqs_n           => s_ddr2_dqs_n
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
            chr  : in unsigned(7 downto 0);
            last : in boolean := false
        ) is begin
            i_UART_RX <= '0';
            wait for symbol_len;
            for i in 0 to chr'high loop
                i_UART_RX <= chr(i);
                wait for symbol_len;
            end loop;
            i_UART_RX <= '1';
            if not last then
                wait for symbol_len;
            end if;
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
        
        type byte_array is array (0 to 15) of std_logic_vector (7 downto 0);
        
        variable bytes      : byte_array;
        
        variable v          : integer;
        
        variable n          : integer;
        
        variable L_IN       : line;
        
        variable L_OUT      : line;
        
        variable arg        : std_logic_vector (7 downto 0);
        
        variable command    : string(1 to 4);
                
        variable success    : boolean := true;
        
        file STIM_IN        : text open READ_MODE is "stim_in.txt";
        file LOG_OUT        : text open WRITE_MODE is "recieved.txt";
    begin
        wait for 200 ns;
        sys_rst <= '0';
        wait for 1 us; -- wait for ui_clk_sync_rst
        -- TODO Put stimulus here
        while not endfile (STIM_IN) loop
            readline(STIM_IN, L_IN);
            read(L_IN, command);
            
            case command is
                when "TEST" =>
                    n := 0;
                    loop 
                        hread(L_IN, arg, success);
                        exit when not success;
                        bytes(n) := arg;
                        n := n + 1;                        
                    end loop;
                    
                    for i in 0 to n-1 loop
                        send_char(unsigned(bytes(i)), i = n-1);
                    end loop;
                    
                    for i in 0 to n-1 loop
                        rx_char(v);
                        
                        write (L_OUT, now);
                        write (L_OUT, string'(" "));
                        hwrite(L_OUT, std_logic_vector(to_unsigned(v, 8)));
                        writeline(LOG_OUT, L_OUT);
                        
                        assert v = to_integer(unsigned(bytes(i)))
                            report "Byte " & integer'image(i) & " is wrong Read " & integer'image(to_integer(to_unsigned(v, 8))) & " Expected " & integer'image(to_integer(unsigned(bytes(i))))
                                severity error;
                    end loop;
                when "WAIT" =>
                    read(L_IN, n);
                    for i_wait in 1 to n loop
                        wait until rising_edge(clk);
                    end loop;
                
                when others => report "wrong command: " &command;
            end case;
        end loop;

        assert false
            report "End of simulation"
            severity failure;

    end process;

end behavior;

