-- Module to write to an AXI slave
-- Assert i_start_wr with a valid addr and data to begin the transaction
-- No writes should be asserted until the current one is complete
-- o_ready is held high when no transaction is occuring
--
-- This file was modified from the Vivado IP creator
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wr_ctrl is
generic (
        -- The master requires a target slave base address.
        -- The master will initiate read and write transactions on the slave with base address specified here as a parameter.
        C_M_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000000";
        -- Width of M_AXI address bus.
        -- The master generates the read and write addresses of width specified as C_M_AXI_ADDR_WIDTH.
        C_M_AXI_ADDR_WIDTH	: integer	:= 32;
        -- Width of M_AXI data bus.
        -- The master issues write data and accept read data where the width of the data bus is C_M_AXI_DATA_WIDTH
        C_M_AXI_DATA_WIDTH	: integer	:= 32
);
port (
    -- USER I/O
    --A pulse to initiate a write transaction, means that i_addr and i_data are valid
    i_start_wr    : std_logic;
    -- data to write
    i_data     : in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    -- address to write to
    i_addr     : in std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    -- asserts when AXI transactions are not in progress
    o_ready : out std_logic;

    -- AXI I/O
    -- axi clock signal
    m_axi_aclk	: in std_logic;
    -- axi active low reset signal
    m_axi_aresetn	: in std_logic;
    -- Master Interface Write Address Channel ports. Write address (issued by master)
    m_axi_awaddr	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    -- write address valid.
    -- this signal indicates that the master signaling valid write address and control information.
    m_axi_awvalid	: out std_logic;
    -- write address ready.
    -- this signal indicates that the slave is ready to accept an address and associated control signals.
    m_axi_awready	: in std_logic;
    -- master interface Write Data Channel ports. Write data (issued by master)
    m_axi_wdata	: out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    -- write strobes.
    -- this signal indicates which byte lanes hold valid data.
    -- there is one write strobe bit for each eight bits of the write data bus.
    m_axi_wstrb	: out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
    -- write valid. This signal indicates that valid write data and strobes are available.
    m_axi_wvalid	: out std_logic;
    -- write ready. This signal indicates that the slave can accept the write data.
    m_axi_wready	: in std_logic;
    -- master interface Write Response Channel ports.
    -- this signal indicates the status of the write transaction.
    m_axi_bresp	: in std_logic_vector(1 downto 0);
    -- write response valid.
    -- this signal indicates that the channel is signaling a valid write response
    m_axi_bvalid	: in std_logic;
    -- response ready. This signal indicates that the master can accept a write response.
    m_axi_bready	: out std_logic);
end wr_ctrl;

architecture Behavioral of wr_ctrl is
    --Asserts when there is a write response error
    -- signal write_resp_error  : std_logic;
    -- intermidiate for o_ready
    signal ready	: std_logic;

    -- AXI4LITE signals
    --write address valid
    signal axi_awvalid	: std_logic;
    --write data valid
    signal axi_wvalid	: std_logic;
    --write response acceptance
    signal axi_bready	: std_logic;
    --write address
    signal axi_awaddr	: std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    --write data
    signal axi_wdata	: std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
begin
    -- I/O Connections assignments
    o_ready <= ready;

    --Adding the offset address to the base addr of the slave
    m_axi_awaddr	<= std_logic_vector (unsigned(C_M_TARGET_SLAVE_BASE_ADDR) + unsigned(axi_awaddr));
    --axi 4 write data
    m_axi_wdata	    <= axi_wdata;
    m_axi_awvalid	<= axi_awvalid;
    --write data(w)
    m_axi_wvalid	<= axi_wvalid;
    --set all byte strobes in this example
    m_axi_wstrb	    <= (others => '1');
    --write response (B)
    m_axi_bready	<= axi_bready;

    -- Capture user inputs
    process(m_axi_aclk)
    begin
        if (rising_edge (m_axi_aclk)) then
            if (i_start_wr = '1') then
                axi_awaddr <= i_addr;
                axi_wdata <= i_data;
            end if;
        end if;
    end process;

    ----------------------
    --write address channel
    ----------------------

    process(m_axi_aclk)
    begin
        if (rising_edge (m_axi_aclk)) then
            --only valid signals must be deasserted during reset per axi spec
            if (m_axi_aresetn = '0') then
                axi_awvalid <= '0';
            else
                --signal a new address/data command is available by user logic
                if (i_start_wr = '1') then
                    axi_awvalid <= '1';
                elsif (m_axi_awready = '1' and axi_awvalid = '1') then
                    --address accepted by interconnect/slave (issue of m_axi_awready by slave)
                    axi_awvalid <= '0';
                end if;
            end if;
        end if;
    end process;


    ----------------------
    --write data channel
    ----------------------

    process(m_axi_aclk)
    begin
        if (rising_edge (m_axi_aclk)) then
            if (m_axi_aresetn = '0') then
                axi_wvalid <= '0';
            else
                if (i_start_wr = '1') then
                    --signal a new address/data command is available by user logic
                    axi_wvalid <= '1';
                elsif (m_axi_wready = '1' and axi_wvalid = '1') then
                    --data accepted by interconnect/slave (issue of m_axi_wready by slave)
                    axi_wvalid <= '0';
                end if;
            end if;
        end if;
    end process;


    ------------------------------
    --write response (b) channel
    ------------------------------

    process(m_axi_aclk)
    begin
        if (rising_edge (m_axi_aclk)) then
            if (m_axi_aresetn = '0') then
                axi_bready <= '0';
            else
                if (m_axi_bvalid = '1' and axi_bready = '0') then
                    -- accept/acknowledge bresp with axi_bready by the master
                    -- when m_axi_bvalid is asserted by slave
                    axi_bready <= '1';
                elsif (axi_bready = '1') then
                    -- deassert after one clock cycle
                    axi_bready <= '0';
                end if;
            end if;
        end if;
    end process;

    --flag write errors
    --write_resp_error <= (axi_bready and m_axi_bvalid and m_axi_bresp(1));

    process(m_axi_aclk)
    begin
        if (rising_edge (m_axi_aclk)) then
            if (m_axi_aresetn = '0') then
                ready <= '1';
            else
                if (axi_bready = '1' and m_axi_bvalid = '1') then
                    ready <= '1';
                elsif (i_start_wr = '1') then
                    ready <= '0';
                else
                    ready <= ready;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
