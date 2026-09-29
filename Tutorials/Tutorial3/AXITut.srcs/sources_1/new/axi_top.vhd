library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axi_top is
    port (
        RST        : in std_logic;
        CLK_100MHZ : in std_logic;
        WR_BTN     : in std_logic;
        SWITCHES   : in std_logic_vector (15 downto 0);
        LEDs       : out std_logic_vector (15 downto 0)
    );
end axi_top;

architecture Behavioral of axi_top is

    -- AXI GPIO Component
    COMPONENT axi_gpio_0
      PORT (
        s_axi_aclk : IN STD_LOGIC;
        s_axi_aresetn : IN STD_LOGIC;
        s_axi_awaddr : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
        s_axi_awvalid : IN STD_LOGIC;
        s_axi_awready : OUT STD_LOGIC;
        s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        s_axi_wvalid : IN STD_LOGIC;
        s_axi_wready : OUT STD_LOGIC;
        s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_bvalid : OUT STD_LOGIC;
        s_axi_bready : IN STD_LOGIC;
        s_axi_araddr : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
        s_axi_arvalid : IN STD_LOGIC;
        s_axi_arready : OUT STD_LOGIC;
        s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        s_axi_rvalid : OUT STD_LOGIC;
        s_axi_rready : IN STD_LOGIC;
        gpio_io_i : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        gpio2_io_o : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
      );
    END COMPONENT;

    component rd_ctrl is
        generic (
            C_M_TARGET_SLAVE_BASE_ADDR  : std_logic_vector  := x"40000000";
            C_M_AXI_ADDR_WIDTH  : integer   := 32;
            C_M_AXI_DATA_WIDTH  : integer   := 32
        );
        port (
            i_start_rd    : in std_logic;
            i_addr     : in std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
            o_valid : out std_logic;
            o_data  : out STD_LOGIC_VECTOR(C_M_AXI_DATA_WIDTH-1 downto 0);

            m_axi_aclk  : in std_logic;
            m_axi_aresetn   : in std_logic;
            m_axi_araddr    : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
            m_axi_arvalid   : out std_logic;
            m_axi_arready   : in std_logic;
            m_axi_rdata : in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
            m_axi_rresp : in std_logic_vector(1 downto 0);
            m_axi_rvalid    : in std_logic;
            m_axi_rready    : out std_logic
        );
    end component rd_ctrl;

    component wr_ctrl is
        generic (
            C_M_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000000";
            C_M_AXI_ADDR_WIDTH	: integer	:= 32;
            C_M_AXI_DATA_WIDTH	: integer	:= 32
        );
        port (
            i_start_wr    : in std_logic;
            i_data     : in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
            i_addr     : in std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
            o_ready : out std_logic;

            m_axi_aclk	: in std_logic;
            m_axi_aresetn	: in std_logic;
            m_axi_awaddr	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
            m_axi_awvalid	: out std_logic;
            m_axi_awready	: in std_logic;
            m_axi_wdata	: out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
            m_axi_wstrb	: out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
            m_axi_wvalid	: out std_logic;
            m_axi_wready	: in std_logic;
            m_axi_bresp	: in std_logic_vector(1 downto 0);
            m_axi_bvalid	: in std_logic;
            m_axi_bready	: out std_logic
        );
    end component wr_ctrl;


    constant C_M_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= "000000000";
    constant C_M_AXI_ADDR_WIDTH	        : integer	        := 9;
    constant C_M_AXI_DATA_WIDTH	        : integer	        := 32;

    signal s_axi_aresetn : std_logic;
    signal s_axi_awaddr  : std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    signal s_axi_awvalid : std_logic;
    signal s_axi_awready : std_logic;
    signal s_axi_wdata   : std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    signal s_axi_wstrb   : std_logic_vector(3 downto 0);
    signal s_axi_wvalid  : std_logic;
    signal s_axi_wready  : std_logic;
    signal s_axi_bresp   : std_logic_vector(1 downto 0);
    signal s_axi_bvalid  : std_logic;
    signal s_axi_bready  : std_logic;
    signal s_axi_araddr  : std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    signal s_axi_arvalid : std_logic;
    signal s_axi_arready : std_logic;
    signal s_axi_rdata   : std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    signal s_axi_rresp   : std_logic_vector(1 downto 0);
    signal s_axi_rvalid  : std_logic;
    signal s_axi_rready  : std_logic;

    attribute mark_debug : string;
    attribute mark_debug of 
        s_axi_araddr, s_axi_arready, s_axi_arvalid,
        s_axi_awaddr, s_axi_awready, s_axi_awvalid,
        s_axi_bready, s_axi_bresp, s_axi_bvalid,
        s_axi_rdata, s_axi_rready, s_axi_rresp, s_axi_rvalid,
        s_axi_wdata, s_axi_wready, s_axi_wstrb,
        s_axi_wvalid : signal is "true";
     

    type tstate_rd is (IDLE_R, START_READ, WAIT_READ, STORE_READ);
    signal state_rd, ns_rd : tstate_rd; 
    type tstate_wr is (IDLE_W, START_WRITE, WAIT_WRITE);
    signal state_wr, ns_wr : tstate_wr; 
    
    signal start_rd, rd_valid, start_wr, wr_ready : std_logic;
    signal rd_data, wr_data : std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    signal rd_addr, wr_addr : std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);

    signal wr_btn_d1 : std_logic;
    signal wr_pulse : std_logic;
    
begin

    -- AXI GPIO Instantiation
    axi_gpio_inst_0 : axi_gpio_0
      PORT MAP (
        s_axi_aclk => CLK_100MHZ,
        s_axi_aresetn => s_axi_aresetn,
        s_axi_awaddr => s_axi_awaddr,
        s_axi_awvalid => s_axi_awvalid,
        s_axi_awready => s_axi_awready,
        s_axi_wdata => s_axi_wdata,
        s_axi_wstrb => s_axi_wstrb,
        s_axi_wvalid => s_axi_wvalid,
        s_axi_wready => s_axi_wready,
        s_axi_bresp => s_axi_bresp,
        s_axi_bvalid => s_axi_bvalid,
        s_axi_bready => s_axi_bready,
        s_axi_araddr => s_axi_araddr,
        s_axi_arvalid => s_axi_arvalid,
        s_axi_arready => s_axi_arready,
        s_axi_rdata => s_axi_rdata,
        s_axi_rresp => s_axi_rresp,
        s_axi_rvalid => s_axi_rvalid,
        s_axi_rready => s_axi_rready,
        gpio_io_i => SWITCHES,
        gpio2_io_o => LEDs
      );
    

    rd_ctrl_0 : rd_ctrl
    generic map (
        C_M_TARGET_SLAVE_BASE_ADDR   => C_M_TARGET_SLAVE_BASE_ADDR,
        C_M_AXI_ADDR_WIDTH           => C_M_AXI_ADDR_WIDTH,
        C_M_AXI_DATA_WIDTH           => C_M_AXI_DATA_WIDTH
    )
    port map (
        i_start_rd       => start_rd,
        i_addr           => rd_addr,
        o_valid          => rd_valid,
        o_data           => rd_data,
        m_axi_aclk       => CLK_100MHZ,
        m_axi_aresetn    => s_axi_aresetn,
        m_axi_araddr     => s_axi_araddr,
        m_axi_arvalid    => s_axi_arvalid,
        m_axi_arready    => s_axi_arready,
        m_axi_rdata      => s_axi_rdata,
        m_axi_rresp      => s_axi_rresp,
        m_axi_rvalid     => s_axi_rvalid,
        m_axi_rready     => s_axi_rready
    );

    wr_ctrl_0 : wr_ctrl
    generic map (
        C_M_TARGET_SLAVE_BASE_ADDR	 => C_M_TARGET_SLAVE_BASE_ADDR,
        C_M_AXI_ADDR_WIDTH	         => C_M_AXI_ADDR_WIDTH,
        C_M_AXI_DATA_WIDTH	         => C_M_AXI_DATA_WIDTH
    )
    port map (
        i_start_wr       => start_wr,
        i_data           => wr_data,
        i_addr           => wr_addr,
        o_ready          => wr_ready,
        m_axi_aclk	     => CLK_100MHZ,
        m_axi_aresetn	 => s_axi_aresetn,
        m_axi_awaddr	 => s_axi_awaddr,
        m_axi_awvalid	 => s_axi_awvalid,
        m_axi_awready	 => s_axi_awready,
        m_axi_wdata	     => s_axi_wdata,
        m_axi_wstrb	     => s_axi_wstrb,
        m_axi_wvalid	 => s_axi_wvalid,
        m_axi_wready	 => s_axi_wready,
        m_axi_bresp	     => s_axi_bresp,
        m_axi_bvalid	 => s_axi_bvalid,
        m_axi_bready	 => s_axi_bready
    );



    s_axi_aresetn <= not RST; -- Pressed button is 1, so invert for active low

    rd_addr <= "000000000";
    wr_addr <= "000001000";

    
    process(CLK_100MHZ)                                                          
    begin                                                                             
        if (rising_edge (CLK_100MHZ)) then                                              
            if (s_axi_aresetn = '0') then                                                
                state_rd <= IDLE_R;
                state_wr <= IDLE_W;
            else                                                                          
                state_rd <= ns_rd;
                state_wr <= ns_wr;
            end if;                                                                         
        end if;                                                                         
    end process;   
                                                                       
    process(CLK_100MHZ)
    begin
        -- single pulse on rising edge of btn input
        if (rising_edge(CLK_100MHZ)) then
            wr_pulse <= wr_btn and not wr_btn_d1;
            wr_btn_d1 <= wr_btn;
        end if;
    end process;   

    -- READ SWITCHES NEXT STATE PROCESS
    process(state_rd,rd_valid,wr_ready)                                                          
    begin                                                                             
        case state_rd is
            when IDLE_R =>
                ns_rd <= START_READ;
            when START_READ =>
                ns_rd <= WAIT_READ;
            when WAIT_READ =>
                if rd_valid = '1' then
                    ns_rd <= STORE_READ;
                else
                    ns_rd <= WAIT_READ;
                end if;
            when STORE_READ =>
                ns_rd <= IDLE_R;
            when OTHERS => -- How did we get here??
                ns_rd <= IDLE_R;
        end case;
    end process;                                                                        
 
    -- WRITE LEDS NEXT STATE PROCESS
    process(state_wr,wr_pulse,wr_ready)                                                          
    begin                                                                             
        case state_wr is
            when IDLE_W =>
                if wr_pulse = '1' then
                    ns_wr <= START_WRITE;
                else
                    ns_wr <= IDLE_W;
                end if;
            when START_WRITE =>
                ns_wr <= WAIT_WRITE;
            when WAIT_WRITE =>
                if wr_ready = '1' then
                    ns_wr <= IDLE_W;
                else
                    ns_wr <= WAIT_WRITE;
                end if;
            when OTHERS => -- How did we get here??
                ns_wr <= IDLE_W;
        end case;
    end process;  
           
    process(CLK_100MHZ)
    begin
        if rising_edge(CLK_100MHZ) then
            if ns_rd = START_READ then
                start_rd <= '1';
            else
                start_rd <= '0'; 
            end if;
        end if;
    end process;

    process(CLK_100MHZ)
    begin
        if rising_edge(CLK_100MHZ) then
            if ns_rd = STORE_READ then
                wr_data <= rd_data;
            else
                wr_data <= wr_data;
            end if;
        end if;
    end process;

    
    process(CLK_100MHZ)
    begin
        if rising_edge(CLK_100MHZ) then
            if ns_wr = START_WRITE then
                start_wr <= '1';
            else
                start_wr <= '0';
            end if;
        end if;
    end process;

end Behavioral;