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

entity tb_fpga_top_DDR2 is
end tb_fpga_top_DDR2;

architecture behavior of tb_fpga_top_DDR2 is

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
        
         type img_array is array (0 to 4095) of Integer;
        
        variable img_in     : img_array;
        
        variable img_out    : img_array;
        
        variable rows       : integer;
        
        variable cols       : integer;
        
        variable max_val    : integer;
        
        variable size       : integer;
        
        file PGM_IN         : text open READ_MODE is "f.pgm";
        
        file PGM_OUT        : text open WRITE_MODE is "feep_out.pgm";
        
        file PGM_FILTERED   : text open WRITE_MODE is "feep_filtered.pgm";
        
        variable v          : integer;
        
        variable n          : integer;
        
        variable L_IN       : line;
        
        variable L_OUT      : line;
                
        variable success    : boolean := true;
        
        variable byte       : unsigned (15 downto 0);
        
        variable four_bytes : unsigned (31 downto 0);
        
        procedure read_pgm is
        begin
            readline(PGM_IN, L_IN); -- skip 
            readline(PGM_IN, L_IN); -- cols and rows 
            read(L_IN, cols);
            read(L_IN, rows);
            readline(PGM_IN, L_IN); -- max pixel value
            read(L_IN, max_val);
            
            size := rows * cols;
            n    := 0;
            
            while not endfile (PGM_IN) loop
                readline(PGM_IN, L_IN);
                loop
                    read(L_IN, v, success);
                    exit when not success;
                    img_in(n) := v;
                    n := n + 1;                        
               end loop;
            end loop;
            
            assert n = size
                report "Pixel size is wrong" severity failure;
        end read_pgm;
        
        procedure send_pgm is
        begin
            send_char(x"01");
            
            byte := to_unsigned(rows, 16); -- send rows 2 bytes
            send_char(byte(7 downto 0));
            send_char(byte(15 downto 8));
            
            byte := to_unsigned(cols, 16); -- send cols 2  bytes
            send_char(byte(7 downto 0));
            send_char(byte(15 downto 8));
            
            four_bytes := to_unsigned(size, 32);    -- send size 4 bytes
            send_char(four_bytes(7 downto 0));
            send_char(four_bytes(15 downto 8));
            send_char(four_bytes(23 downto 16));
            send_char(four_bytes(31 downto 24));
            
            for i in 0 to size - 1 loop
                send_char(to_unsigned(img_in(i), 8), i = size -1); --send main data
            end loop;
        end send_pgm;
        
        procedure recieve_pgm( 
            chr  : in unsigned(7 downto 0);
            count : in integer
        ) is
        begin
            send_char(chr, true);
            
            for i in 0 to count - 1 loop
                rx_char(v);
                img_out(i) := v;
            end loop;
        end recieve_pgm;
        
        procedure save_pgm (
            file f_out  : text;
            n_rows  : in integer
        ) is
        begin
            write(L_OUT, string'("P2"));
            writeline(PGM_OUT, L_OUT);
            
            write(L_OUT, integer'image(cols));
            write(L_OUT, string'(" "));
            write(L_OUT, integer'image(rows));
            writeline(PGM_OUT, L_OUT);
            
            write(L_OUT, integer'image(max_val));
            writeline(PGM_OUT, L_OUT);
            
            for i in 0 to rows - 1 loop
                for x in 0 to cols - 1 loop
                    write(L_OUT, img_out(i * cols + x));
                    write(L_OUT, string'("  "));
                end loop;
                writeline(PGM_OUT, L_OUT);
            end loop;
        end save_pgm;
        
        procedure process_pgm is
        begin
            send_char(x"04", true);
            rx_char(v);
            
            assert v = 1
                report "Wrong byte back"
                severity failure;
        end process_pgm;
        
    begin
        wait for 200 ns;
        sys_rst <= '0';
        wait for 1 us; -- wait for ui_clk_sync_rst
       
        read_pgm;
        report "Read";
        send_pgm;
        report "Sent";
        process_pgm;
        Report "Processed";
        recieve_pgm(x"02", size);
        Report "Recieved 02";
        save_pgm(PGM_OUT, rows);
        Report "Saved 02";
        recieve_pgm(x"03", size - 2 * cols);
        Report "Recieved 03";
        save_pgm(PGM_FILTERED, rows - 2);

        assert false
            report "End of simulation"
            severity failure;

    end process;

end behavior;

