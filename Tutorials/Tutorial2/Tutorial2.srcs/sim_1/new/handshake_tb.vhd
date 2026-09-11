library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity handshake_tb is
--  Port ( );
end handshake_tb;

architecture Behavioral of handshake_tb is
    component handshakeTop is
    port ( 
        i_clk : in std_logic;                     -- clock
        i_rst : in std_logic;                     -- reset 
        
        i_send : in std_logic;                    -- initiate send
        i_data : in std_logic_vector(7 downto 0); -- data in 
        
        o_recv : out std_logic;                   -- received something
        o_data : out std_logic_vector(7 downto 0) -- data out
    );
    end component;
    
    signal clk : std_logic := '0';
    signal rst :  std_logic := '0'; 
    
    signal send : std_logic := '0';
    signal recv : std_logic;
    signal input_data : std_logic_vector(7 downto 0) := (others => '0');
    signal output_data : std_logic_vector(7 downto 0);
        
    constant clk_period : time := 10 ns; 
begin
    uut : handshakeTop port map (
        i_clk => clk,
        i_rst => rst,
        i_send => send,
        i_data => input_data,
        o_recv => recv,
        o_data => output_data
    );

    clk <= not clk after clk_period/2;
    
    stim_proc : process
    begin
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        wait for clk_period;
        
        input_data <= x"55";
        send <= '1';
        wait for clk_period;
        send <= '0';
        wait for clk_period*10;
        
        input_data <= x"AA";
        send <= '1';
        wait for clk_period;
        send <= '0';
        wait for clk_period*6;
        
        report "Simulation Finished" severity FAILURE;
    end process;
end Behavioral;
