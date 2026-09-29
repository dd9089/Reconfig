-- Module to read from an AXI slave
-- Assert i_start_rd with a valid addr to begin the transaction
-- No reads should be asserted until the current one is complete
-- Data appears on o_data with the o_valid clock signal
--
-- This file was modified from the Vivado IP creator

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rd_ctrl is
generic (
        -- The master requires a target slave base address.
        -- The master will initiate read and write transactions on the slave with base address specified here as a parameter.
        C_M_TARGET_SLAVE_BASE_ADDR  : std_logic_vector  := x"40000000";
        -- Width of M_AXI address bus.
        -- The master generates the read and write addresses of width specified as C_M_AXI_ADDR_WIDTH.
        C_M_AXI_ADDR_WIDTH  : integer   := 32;
        -- Width of M_AXI data bus.
        -- The master issues write data and accept read data where the width of the data bus is C_M_AXI_DATA_WIDTH
        C_M_AXI_DATA_WIDTH  : integer   := 32
);
port (
    -- USER I/O
    --A pulse to initiate a read transaction, means that i_addr is valid
    i_start_rd    : std_logic;
    -- address to read from
    i_addr     : in std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    -- asserts when AXI transactions is complete
    o_valid : out std_logic;
    -- output data
    o_data  : out STD_LOGIC_VECTOR(C_M_AXI_DATA_WIDTH-1 downto 0);

    -- AXI Signals
    -- axi clock signal
    m_axi_aclk  : in std_logic;
    -- axi active low reset signal
    m_axi_aresetn   : in std_logic;
    -- master interface Read Address Channel ports. Read address (issued by master)
    m_axi_araddr    : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    -- read address valid.
    -- this signal indicates that the channel is signaling valid read address and control information.
    m_axi_arvalid   : out std_logic;
    -- read address ready.
    -- this signal indicates that the slave is ready to accept an address and associated control signals.
    m_axi_arready   : in std_logic;
    -- master interface Read Data Channel ports. Read data (issued by slave)
    m_axi_rdata : in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    -- read response. This signal indicates the status of the read transfer.
    m_axi_rresp : in std_logic_vector(1 downto 0);
    -- read valid. this signal indicates that the channel is signaling the required read data.
    m_axi_rvalid    : in std_logic;
    -- read ready. this signal indicates that the master can accept the read data and response information.
    m_axi_rready    : out std_logic);
end rd_ctrl;

architecture Behavioral of rd_ctrl is

    type tstate is (idle, write);

    signal state  : tstate ;

    -- AXI4LITE signals
    signal axi_rready, axi_arvalid : std_logic;
    --read addresss
    signal axi_araddr   : std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    --Asserts when there is a read response error
    -- signal read_resp_error  : std_logic;
    --Asserts when a single beat read transaction is issued and remains asserted till the completion of read trasaction.
    signal read_issued  : std_logic;


begin
    -- Make user I/O clear
    o_data <= m_axi_rdata;
    o_valid <= m_axi_rvalid and axi_rready;

    --Read Address (AR)
    m_axi_araddr    <= std_logic_vector(unsigned(C_M_TARGET_SLAVE_BASE_ADDR) + unsigned(axi_araddr));
    m_axi_arvalid   <= axi_arvalid;
    --Read and Read Response (R)
    m_axi_rready    <= axi_rready;


    ------------------------------
    --Read Address Channel
    ------------------------------

    -- Capture i_addr value
    process(m_axi_aclk)
    begin
        if (rising_edge (m_axi_aclk)) then
            if (i_start_rd = '1') then
                axi_araddr <= i_addr;
            end if;
        end if;
    end process;

    process(m_axi_aclk)
    begin
        if (rising_edge (m_axi_aclk)) then
            if (m_axi_aresetn = '0') then
                axi_arvalid <= '0';
            else
                if (i_start_rd = '1') then
                    --signal a new read address command is available by user logic
                    axi_arvalid <= '1';
                elsif (m_axi_arready = '1' and axi_arvalid = '1') then
                    --raddress accepted by interconnect/slave (issue of m_axi_arready by slave)
                    axi_arvalid <= '0';
                end if;
            end if;
        end if;
    end process;


    ----------------------------------
    --read data (and response) channel
    ----------------------------------

    process(m_axi_aclk)
    begin
        if (rising_edge (m_axi_aclk)) then
            if (m_axi_aresetn = '0') then
                axi_rready <= '1';
            else
                if (m_axi_rvalid = '1' and axi_rready = '0') then
                    -- accept/acknowledge rdata/rresp with axi_rready by the master
                    -- when m_axi_rvalid is asserted by slave
                    axi_rready <= '1';
                elsif (axi_rready = '1') then
                    -- deassert after one clock cycle
                    axi_rready <= '0';
                end if;
            end if;
        end if;
    end process;

    --flag read errors
    -- read_resp_error <= (axi_rready and m_axi_rvalid and m_axi_rresp(1));

end Behavioral;
