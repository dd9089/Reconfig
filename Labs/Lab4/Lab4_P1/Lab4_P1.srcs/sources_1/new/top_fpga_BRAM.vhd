library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fpga_top_BRAM is
    generic(
        depth           :  integer  :=  32;
        width           :  integer  :=  8
    );
    port(
        clk_100MHz  :  in     std_logic;
        sys_rst     :  in     std_logic;
        i_UART_RX   :  in     std_logic;
        o_UART_TX   :  out    std_logic
           );
end fpga_top_BRAM;

architecture Behavioral of fpga_top_BRAM is

    component top is
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
    end component top;

    component blk_mem_gen_0
        port (
            rsta_busy      :  out  std_logic;
            rstb_busy      :  out  std_logic;
            s_aclk         :  in   std_logic;
            s_aresetn      :  in   std_logic;
            s_axi_awaddr   :  in   std_logic_vector(31  downto  0);
            s_axi_awvalid  :  in   std_logic;
            s_axi_awready  :  out  std_logic;
            s_axi_wdata    :  in   std_logic_vector(31  downto  0);
            s_axi_wstrb    :  in   std_logic_vector(3   downto  0);
            s_axi_wvalid   :  in   std_logic;
            s_axi_wready   :  out  std_logic;
            s_axi_bresp    :  out  std_logic_vector(1   downto  0);
            s_axi_bvalid   :  out  std_logic;
            s_axi_bready   :  in   std_logic;
            s_axi_araddr   :  in   std_logic_vector(31  downto  0);
            s_axi_arvalid  :  in   std_logic;
            s_axi_arready  :  out  std_logic;
            s_axi_rdata    :  out  std_logic_vector(31  downto  0);
            s_axi_rresp    :  out  std_logic_vector(1   downto  0);
            s_axi_rvalid   :  out  std_logic;
            s_axi_rready   :  in   std_logic
        );
    end component;
    
    signal clk             :   std_logic := '1';
    signal rst             :   std_logic := '1';
    signal rstn            :   std_logic;
    signal m_axi_awaddr    :   std_logic_vector(31  downto  0);
    signal m_axi_awvalid   :   std_logic;
    signal m_axi_awready   :   std_logic;
    signal m_axi_wdata     :   std_logic_vector(31  downto  0);
    signal m_axi_wstrb     :   std_logic_vector(3   downto  0);
    signal m_axi_wvalid    :   std_logic;
    signal m_axi_wready    :   std_logic;
    signal m_axi_bresp     :   std_logic_vector(1   downto  0);
    signal m_axi_bvalid    :   std_logic;
    signal m_axi_bready    :   std_logic;
    signal m_axi_araddr    :   std_logic_vector(31  downto  0);
    signal m_axi_arvalid   :   std_logic;
    signal m_axi_arready   :   std_logic;
    signal m_axi_rdata     :   std_logic_vector(31  downto  0);
    signal m_axi_rresp     :   std_logic_vector(1   downto  0);
    signal m_axi_rvalid    :   std_logic;
    signal m_axi_rready    :   std_logic;

-- Clock period definitions
    constant  clk_period   :  time     :=  10 ns;
    constant  clk_per_sym  :  integer  :=  868;
    constant  symbol_len   :  time     :=  clk_period*clk_per_sym;  --   100  MHz  /  115200  =  868.1  clock/symbol


begin

    top_0 : top
    generic map (
        depth  => 16,
        width  => 8
    )
    port map (
        clk              => clk,
        rst              => rst,
        i_uart_rx        => i_uart_rx,
        o_uart_tx        => o_uart_tx,
        m_axi_awaddr     => m_axi_awaddr,
        m_axi_awvalid    => m_axi_awvalid,
        m_axi_awready    => m_axi_awready,
        m_axi_wdata      => m_axi_wdata,
        m_axi_wstrb      => m_axi_wstrb,
        m_axi_wvalid     => m_axi_wvalid,
        m_axi_wready     => m_axi_wready,
        m_axi_bresp      => m_axi_bresp,
        m_axi_bvalid     => m_axi_bvalid,
        m_axi_bready     => m_axi_bready,
        m_axi_araddr     => m_axi_araddr,
        m_axi_arvalid    => m_axi_arvalid,
        m_axi_arready    => m_axi_arready,
        m_axi_rdata      => m_axi_rdata,
        m_axi_rresp      => m_axi_rresp,
        m_axi_rvalid     => m_axi_rvalid,
        m_axi_rready     => m_axi_rready
    );

memory : blk_mem_gen_0
  port map (
        rsta_busy      =>  open,
        rstb_busy      =>  open,
        s_aclk         =>  clk,
        s_aresetn      =>  rstn,
        s_axi_awaddr   =>  m_axi_awaddr,
        s_axi_awvalid  =>  m_axi_awvalid,
        s_axi_awready  =>  m_axi_awready,
        s_axi_wdata    =>  m_axi_wdata,
        s_axi_wstrb    =>  m_axi_wstrb,
        s_axi_wvalid   =>  m_axi_wvalid,
        s_axi_wready   =>  m_axi_wready,
        s_axi_bresp    =>  m_axi_bresp,
        s_axi_bvalid   =>  m_axi_bvalid,
        s_axi_bready   =>  m_axi_bready,
        s_axi_araddr   =>  m_axi_araddr,
        s_axi_arvalid  =>  m_axi_arvalid,
        s_axi_arready  =>  m_axi_arready,
        s_axi_rdata    =>  m_axi_rdata,
        s_axi_rresp    =>  m_axi_rresp,
        s_axi_rvalid   =>  m_axi_rvalid,
        s_axi_rready   =>  m_axi_rready
  );
  rst  <= sys_rst;
  rstn <= not rst;
  
  clk  <= clk_100MHz;

end Behavioral;
