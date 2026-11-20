library ieee;
use ieee.std_logic_1164.all;
use  ieee.numeric_std.all;


entity top is
    generic(
        depth : integer := 16;
        width : integer := 8
    );
    port(
        clk             :  in   std_logic;
        rst             :  in   std_logic;
        i_uart_rx       :  in   std_logic;
        o_uart_tx       :  out  std_logic;
        m_axi_awaddr    :  out  std_logic_vector(31  downto  0);
        m_axi_awvalid   :  out  std_logic;
        m_axi_awready   :  in   std_logic;
        m_axi_wdata     :  out  std_logic_vector(31  downto  0);
        m_axi_wstrb     :  out  std_logic_vector(3   downto  0);
        m_axi_wvalid    :  out  std_logic;
        m_axi_wready    :  in   std_logic;
        m_axi_bresp     :  in   std_logic_vector(1   downto  0);
        m_axi_bvalid    :  in   std_logic;
        m_axi_bready    :  out  std_logic;
        m_axi_araddr    :  out  std_logic_vector(31  downto  0);
        m_axi_arvalid   :  out  std_logic;
        m_axi_arready   :  in   std_logic;
        m_axi_rdata     :  in   std_logic_vector(31  downto  0);
        m_axi_rresp     :  in   std_logic_vector(1   downto  0);
        m_axi_rvalid    :  in   std_logic;
        m_axi_rready    :  out  std_logic
    );
end top;
architecture behavioral of top is

    component AXIS_UART_RX is
        port ( 
            UART_RX           : in std_logic;
            almost_full       : in std_logic;
            CLK_100MHZ        : in std_logic;
            sclk_en_16_x_baud : in std_logic;
            ready             : in std_logic;
            valid             : out std_logic;
            data_out          : out std_logic_vector (7 downto 0));
    end component;
    
    component AXIS_UART_TX is
       Port (
            data_in : in std_logic_vector (7 downto 0);
            almost_empty      : in std_logic;
            CLK_100MHZ        : in std_logic;
            sclk_en_16_x_baud : in std_logic;
            valid             : in std_logic;
            ready             : out std_logic;
            UART_TX           : out std_logic );
    end component;
    
    COMPONENT axis_data_fifo_recieve
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
        almost_full  : OUT STD_LOGIC
      );
    END COMPONENT;
    
    COMPONENT axis_data_fifo_transmit
      PORT (
        s_axis_aresetn : IN STD_LOGIC;
        s_axis_aclk : IN STD_LOGIC;
        s_axis_tvalid : IN STD_LOGIC;
        s_axis_tready : OUT STD_LOGIC;
        s_axis_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        m_axis_tvalid : OUT STD_LOGIC;
        m_axis_tready : IN STD_LOGIC;
        m_axis_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        almost_full : OUT STD_LOGIC;
        almost_empty : OUT STD_LOGIC
      );
    END COMPONENT;
    
    component median_filter
        port (
            clk : in std_logic;
            rst : in std_logic;
            i_data : in unsigned (7 downto 0);
            i_en1  : in std_logic;
            i_en2  : in std_logic;
            o_med  : out unsigned (7 downto 0));
    end component;
    
    type translator is (idle, read_cmd, rii, rma_w, rpd, write, bresp, check_w, f_en, f_next, f_ack, rma_r, read, data, send, check_r);
    signal translator_state : translator;

    constant n_bytes : integer := 8;
    
    signal header   : std_logic_vector (63 downto 0) := (others => '0');
    
    signal size     : unsigned (31 downto 0);
    signal count    : unsigned (31 downto 0) := (others => '0');
    
    signal scount12 : unsigned (11 downto 0) := (others => '0');
    signal sclk_en_16_x_baud : std_logic := '0';
    
--    signal scount4 : unsigned (3 downto 0) := (others => '0');
--    signal rcount4 : unsigned (3 downto 0) := (others => '0');
    signal rcount8 : unsigned (7 downto 0) := (others => '0');
        
    signal aresetn : std_logic;
    
    signal cmd     : std_logic_vector (7 downto 0);
    
    signal rx_tdata: std_logic_vector (7 downto 0);
    signal rx_tvalid, rx_tready, rx_almost_full : std_logic;
    
    signal recieve_tdata : std_logic_vector (7 downto 0);
    signal recieve_tvalid, recieve_tready : std_logic;
    
    signal transmit_tdata : std_logic_vector (7 downto 0);
    signal transmit_tvalid, transmit_tready : std_logic;
    
    signal tx_tdata : std_logic_vector (7 downto 0);
    signal tx_tvalid, tx_tready, tx_almost_empty : std_logic;
       
    signal tdata    : std_logic_vector (7 downto 0) := (others => '0');
    
    signal aw_done  : std_logic := '0';
    signal w_done   : std_logic := '0';
    
    signal sel : unsigned (1 downto 0) := (others => '0');
    
    signal n    : unsigned (31 downto 0) := (others => '0');
    signal base : unsigned (31 downto 0) := (others => '0');
    signal c    : unsigned (31 downto 0) := (others => '0');
    signal f_size : unsigned (31 downto 0) := (others => '0');
    signal lim  : unsigned (31 downto 0) := (others => '0');
    
    signal f_pix : unsigned (7 downto 0) := (others => '0');
    signal o_med : unsigned (7 downto 0) := (others => '0');
    
    signal en1 : std_logic;
    signal en2 : std_logic;
begin
    RX_inst : AXIS_UART_RX port map
    ( 
        UART_RX             => i_uart_rx,      
        almost_full         => rx_almost_full,
        CLK_100MHZ          => clk,   
        sclk_en_16_x_baud   => sclk_en_16_x_baud,
        ready               => rx_tready,      
        valid               => rx_tvalid,         
        data_out            => rx_tdata);
      
    TX_inst : AXIS_UART_TX port map
    (
        CLK_100MHZ          => clk,
        sclk_en_16_x_baud   => sclk_en_16_x_baud,
        data_in             => tx_tdata,
        valid               => tx_tvalid,
        UART_TX             => o_uart_tx,
        ready               => tx_tready,
        almost_empty        => tx_almost_empty);
    
    AXIS_FIFO_RX : axis_data_fifo_recieve
      PORT MAP (
        s_axis_aresetn => aresetn,
        s_axis_aclk => clk,
        s_axis_tvalid => rx_tvalid,
        s_axis_tready => rx_tready,
        s_axis_tdata => rx_tdata,
        m_axis_tvalid => recieve_tvalid,
        m_axis_tready => recieve_tready,
        m_axis_tdata => recieve_tdata,
        almost_empty => open,
        almost_full => rx_almost_full
      );
      
      AXIS_FIFO_TX : axis_data_fifo_transmit
      PORT MAP (
        s_axis_aresetn => aresetn,
        s_axis_aclk => clk,
        s_axis_tvalid => transmit_tvalid,
        s_axis_tready => transmit_tready,
        s_axis_tdata => transmit_tdata,
        m_axis_tvalid => tx_tvalid,
        m_axis_tready => tx_tready,
        m_axis_tdata => tx_tdata,
        almost_full => open,
        almost_empty => tx_almost_empty
      );
      
      filter : median_filter port map(
       clk => clk,
       rst => rst,
       i_data => f_pix,
       i_en1 => en1,
       i_en2 => en2,
       o_med => o_med); 

        -- clock enable according to the required baud value
    process(clk)
    begin
        if clk'event and clk = '1' then
            -- if scount = X"28B" then  ----  for    9600 baud : 100 MHZ / (16 * 9600)   = 651 => 0x28B /
            if scount12 = X"35" then    ----  for  115200 baud : 100 MHZ / (16 * 115200) =  54 => 0x 36 /
                scount12 <= (others => '0');
            else
                scount12 <= scount12 + 1;
            end if;
        end if;
    end process;
    
    -- Translator state machine
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                translator_state <= idle;
            else
                case (translator_state) is
                    when idle => 
                        if recieve_tvalid = '1' then 
                            translator_state <= read_cmd;
                        end if;
                    when read_cmd =>
                        if cmd = x"01" then
                            translator_state <= rii;
                        elsif cmd = x"02" or cmd = x"03" or cmd = x"04" then
                            translator_state <= rma_r;
                        else
                            translator_state <= idle;
                        end if;
                    when rii => 
                        if recieve_tvalid = '1' then
                            if rcount8 = 7 then
                                translator_state <= rma_w;
                            end if;
                        end if;
                    when rma_w =>
                        translator_state <= rpd;
                    when rpd =>
                        if recieve_tvalid = '1' then
                            translator_state <= write;
                        end if;
                    when write =>
                        if (aw_done = '1' or m_axi_awready = '1') and  (w_done = '1' or m_axi_wready = '1') then
                            translator_state <= bresp;
                        end if;
                    when bresp =>
                        if cmd = x"01" then
                            if m_axi_bvalid = '1' then
                                translator_state <= check_w;
                            end if;
                        elsif cmd = x"04" then
                            if m_axi_bvalid = '1' then
                                translator_state <= f_next;
                            end if;
                        end if;
                    when check_w =>
                        if count < size - 1 then
                            translator_state <= rpd;
                        else
                            translator_state <= idle;
                        end if;
                    when rma_r =>
                        translator_state <= read;
                    when read =>
                        if m_axi_arready = '1' then
                            translator_state <= data;
                        end if;
                    when data =>
                        if cmd = x"04" then
                            if m_axi_rvalid = '1' then
                                translator_state <= f_en;
                            end if;
                        else
                            if m_axi_rvalid = '1' then
                                translator_state <= send;
                            end if;
                       end if;
                    when send =>
                        if transmit_tready = '1' then
                            translator_state <= check_r;
                        end if;
                    when check_r =>
                        if count < lim - 1 then
                            translator_state <= read;
                        else
                            translator_state <= idle;
                        end if;
                    when f_en =>
                        if sel < 2 then
                            translator_state <= read;
                        elsif sel = 2 then
                            if n < 3 then
                                translator_state <= f_next;
                            else
                                translator_state <= write;
                            end if;                    
                        end if;
                    when f_next =>
                        if n = f_size + 2 then
                            translator_state <= f_ack;
                        else
                            translator_state <= read;
                        end if;
                    when f_ack =>
                        if transmit_tready = '1' then
                            translator_state <= idle;
                        end if;
                    when others => translator_state <= idle;
                end case;
            end if;
        end if;
    end process;
        
    -- Header counter
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                rcount8 <= (others => '0');
            elsif  translator_state = rii and recieve_tvalid = '1' then
                if rcount8 = to_unsigned(n_bytes - 1, rcount8'length) then
                    rcount8 <= (others => '0');
                else
                    rcount8 <= rcount8 + 1;
                end if;
            end if;
        end if;
    end process;
    
    --Pixel Counter
    process (clk) 
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                count <= (others => '0');
            else
                case (translator_state) is
                    when check_w | check_r =>
                        if count < lim - 1 then
                           count <= count + 1; 
                        end if;
                    when rma_w | rma_r=>
                        count <= (others => '0');
                    when others =>
                        null;
                end case;
           end if;
        end if;
    end process;
    
    --State machine output (m_axi_awvalid)
    process (translator_state, aw_done)
    begin
        case (translator_state) is
            when write => 
                if (aw_done = '0') then
                    m_axi_awvalid <= '1';
                else
                    m_axi_awvalid <= '0';
                end if;
            when others => m_axi_awvalid <= '0';
        end case;
    end process;
    
    --State machine output (m_axi_wvalid)
    process (translator_state, w_done)
    begin
        case (translator_state) is
            when write =>
                if (w_done = '0') then
                    m_axi_wvalid <= '1';
                else
                    m_axi_wvalid <= '0';
                end if;
            when others => m_axi_wvalid <= '0';
        end case;
    end process;
    
    --State machine output (m_axi_arvalid)
    process (translator_state)
    begin
        case (translator_state) is
            when read => m_axi_arvalid <= '1';
            when others => m_axi_arvalid <= '0';
        end case;
    end process;
    
    --State machine output (transmit_tvalid)
    process (translator_state)
    begin
        case (translator_state) is
            when send | f_ack => transmit_tvalid <= '1';
            when others => transmit_tvalid <= '0';
        end case;
    end process;
    
    --State machine output (revieve_tready)
    process (translator_state, recieve_tvalid)
    begin
        case (translator_state) is
            when idle | rii | rpd => 
                if recieve_tvalid = '1' then
                    recieve_tready <= '1';
                else 
                    recieve_tready <= '0';
                end if;
            when others => recieve_tready <= '0';
        end case;
    end process;
    
    --State machine output (Header)
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                header <= (others => '0');
            else
                case(translator_state) is
                    when rii =>
                        if recieve_tvalid = '1' then
                            header <= recieve_tdata & header(63 downto 8);
                        end if;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
    
    --State machine output (Command)
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                cmd <= (others => '0');
            else
                case(translator_state) is
                    when idle =>
                        if recieve_tvalid = '1' then
                            cmd <=  recieve_tdata;
                        end if;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
    
    --State machine output (Data)
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                tdata <= (others => '0');
            else
                case (translator_state) is
                    when rpd => 
                        if recieve_tvalid = '1' then
                            tdata <= recieve_tdata;
                        end if;
                    when others => null;
                end case;
            end if;
        end if;
    end process;
    
    --State Machine Output (transmit_tdata)
    process (clk)
    begin
        if Rising_edge(clk) then
            case (translator_state) is
                when data =>
                    if m_axi_rvalid = '1' then
                        transmit_tdata <= m_axi_rdata(7 downto 0);
                    end if;
                when f_next =>
                    transmit_tdata <= x"01";
                when others => null;
            end case;
        end if;
    end process;
    
    --State Machine Output (aw_done)
    process (clk)
    begin
        if Rising_edge(clk) then
            case (translator_state) is
                when rpd | f_en => 
                    aw_done <= '0';
                when write =>
                    if (m_axi_awready = '1') then
                        aw_done <= '1';
                    end if;
                when others => null;
            end case;
        end if;
    end process;
    
    --State Machine Output (w_done)
    process (clk)
    begin
        if Rising_edge(clk) then
            case (translator_state) is
                when rpd | f_en =>
                    w_done <= '0';
                when write =>
                    if (m_axi_wready = '1') then
                        w_done <= '1';
                    end if;
                when others => null;
            end case;
        end if;
    end process;
    
    --State Machine Output (base)
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                base <= (others => '0');
            else
                case (translator_state) is
                    when idle =>
                        base <= c;
                    when f_next =>
                        base <= base + 1;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
    
    --State Machine Output (n)
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                n <= (others => '0');
            else
                case (translator_state) is
                    when idle =>
                        n <= (others => '0');
                    when f_next =>
                        n <= n + 1;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
    
    --State Machine Output (sel)
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                sel <= (others => '0');
            else
                case (translator_state) is
                    when idle | f_next =>
                        sel <= (others => '0');
                    when f_en =>
                        if sel < 2 then
                            sel <= sel + 1;
                        end if;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
    
    -- State Machine Output (f_pix)
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                f_pix <= (others => '0');
            else
                case (translator_state) is
                    when data =>
                        if m_axi_rvalid = '1' then
                            f_pix <= unsigned(m_axi_rdata(7 downto 0));
                        end if;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
    
    --State Machine Output (en1)
    process (translator_state, sel)
    begin
        case (translator_state) is
            when f_en =>
                if sel < 2 then
                    en1 <= '1';
                else
                    en1 <= '0';
                end if;
            when others =>
                en1 <= '0';
        end case;
    end process;

    --State Machine Output (en2)
    process (translator_state, sel)
    begin
        case (translator_state) is
            when f_en =>
                if sel = 2 then
                    en2 <= '1';
                else 
                    en2 <= '0';
                end if;
            when others =>
                en2 <= '0';
        end case;
    end process;
    
    --araddr
    process (cmd, count, base, c, sel)
    begin
        case cmd is
            when x"03" =>
                m_axi_araddr <= std_logic_vector(x"00100000" + (count(29 downto 0) & "00"));
            when x"04" =>
                case sel is
                    when "00" =>
                        m_axi_araddr <= std_logic_vector(base(29 downto 0)) & "00";
                    when "01" =>
                        m_axi_araddr <= std_logic_vector(base(29 downto 0) - c(29 downto 0)) & "00";
                    when others =>
                        m_axi_araddr <= std_logic_vector(base(29 downto 0) + c(29 downto 0)) & "00";
                end case;
            when others =>
                m_axi_araddr <= std_logic_vector(count(29 downto 0)) & "00";
        end case;
    end process;
    
    --awaddr
    process (cmd, count, n)
    begin
        case cmd is
            when x"04" =>
                m_axi_awaddr <= std_logic_vector(x"00100000" + ((n(29 downto 0) - 3) & "00"));
            when others =>
                m_axi_awaddr <= std_logic_vector(count(29 downto 0)) & "00";
        end case;
    end process;
    
    --wdata
    process (cmd, tdata, o_med)
    begin
        case cmd is
            when x"04" =>
                m_axi_wdata <= x"000000" & std_logic_vector(o_med);
            when others =>
                m_axi_wdata <= x"000000" & tdata;
        end case;
    end process;
    
    size <= unsigned(header(63 downto 32));
    
    c <= x"0000" & unsigned(header(31 downto 16));
    
    f_size <= size - (c(30 downto 0) & '0');
    
    lim <= f_size when cmd = x"03" else size;
        
    m_axi_wstrb  <= "0001";
            
    m_axi_bready <= '1';
    
    m_axi_rready <= '1';
    
    sclk_en_16_x_baud <= '1' when scount12 = X"35" else '0';
    
    aresetn <= not rst;

end behavioral;
