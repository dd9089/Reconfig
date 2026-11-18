
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_TextIO.all;
use STD.TextIO.all;

entity tb_fpga_top_BRAM is
end tb_fpga_top_BRAM;

architecture behavior of tb_fpga_top_BRAM is

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
        
        file PGM_IN         : text open READ_MODE is "feep.pgm";
        
        file PGM_OUT        : text open WRITE_MODE is "feep_out.pgm";
        
        variable v          : integer;
        
        variable n          : integer;
        
        variable L_IN       : line;
        
        variable L_OUT      : line;
                
        variable success    : boolean := true;
        
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
              
        end send_pgm;
       
    begin
        sys_rst <= '0';
        wait for 200 ns;
        
       
        assert false
            report "End of simulation"
            severity failure;

    end process;

end behavior;

