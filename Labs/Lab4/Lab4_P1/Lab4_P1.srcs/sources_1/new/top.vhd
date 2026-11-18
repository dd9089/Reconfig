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
    
    type translator is (idle, read_cmd, rii, rma_w, rpd, write, bresp, check_w, rma_r, read, data, send, check_r);
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

        -- clock enable according to the required baud value
    process(clk)
    begin
        if clk'event and clk = '1' then
            -- if scount = X"28B" then  ----  for    9600 baud : 100 MHZ / (16 * 9600)   = 651 => 0x28B /
            if scount12 = X"36" then    ----  for  115200 baud : 100 MHZ / (16 * 115200) =  54 => 0x 36 /
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
                        elsif cmd = x"02" then
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
                        if m_axi_bvalid = '1' then
                            translator_state <= check_w;
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
                        if m_axi_rvalid = '1' then
                            translator_state <= send;
                        end if;
                    when send =>
                        if transmit_tready = '1' then
                            translator_state <= check_r;
                        end if;
                    when check_r =>
                        if count < size - 1 then
                            translator_state <= read;
                        else
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
                        if count < size - 1 then
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
            when send => transmit_tvalid <= '1';
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
                when others => null;
            end case;
        end if;
    end process;
    
    --State Machine Output (aw_done)
    process (clk)
    begin
        if Rising_edge(clk) then
            case (translator_state) is
                when rpd => 
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
                when rpd =>
                    w_done <= '0';
                when write =>
                    if (m_axi_wready = '1') then
                        w_done <= '1';
                    end if;
                when others => null;
            end case;
        end if;
    end process;
    
    size <= unsigned(header(63 downto 32));
    
    m_axi_wdata <= x"000000" & tdata;
    
    m_axi_wstrb  <= "0001";
    
    m_axi_awaddr <= std_logic_vector(count(29 downto 0)) & "00";
    
    m_axi_araddr <= std_logic_vector(count(29 downto 0)) & "00";
    
    m_axi_bready <= '1';
    
    m_axi_rready <= '1';
    
    sclk_en_16_x_baud <= '1' when scount12 = X"35" else '0';
    
    aresetn <= not rst;

end behavioral;
