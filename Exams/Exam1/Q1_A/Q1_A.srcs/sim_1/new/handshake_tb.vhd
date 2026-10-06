library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Moore_tb is
--  Port ( );
end Moore_tb;

architecture Behavioral of Moore_tb is
    component Combinational_Output is
    port ( 
        i_clk : in std_logic;                     -- clock
        i_rst : in std_logic;                     -- reset 
        
        w     : in std_logic;                    -- input
        
        z     : out std_logic                    -- output
    );
    end component;
    
    component Registered_Output is
    port(
        i_clk : in std_logic;                     -- clock
        i_rst : in std_logic;                     -- reset 
        
        w     : in std_logic;                    -- input
        
        z     : out std_logic                    -- output
    );
    end component;
    
    signal clk      : std_logic := '0';
    signal rst      :  std_logic := '0'; 
    
    signal w        : std_logic := '0';
    signal z_comb   : std_logic;
    signal z_reg    : std_logic;

    constant clk_period : time := 10 ns; 
begin
    uut_comb : Combinational_Output port map (
        i_clk => clk,
        i_rst => rst,
        w => w,
        z => z_comb
    );
    
    uut_reg : Registered_Output port map (
        i_clk => clk,
        i_rst => rst,
        w => w,
        z => z_reg
    );

    clk <= not clk after clk_period/2;
    
    stim_proc : process
    begin
        rst <= '0';
        wait for clk_period;
        rst <= '1';
        wait for clk_period*2;
        
        w <= '1';
        wait for clk_period;
        
        w <= '0';
        wait for clk_period;
        
        w <= '1';
        wait for clk_period*3;     
        
        w <= '0';
        wait for clk_period;
        
        w <= '1';
        wait for clk_period;
        
        rst <= '0';
        wait for clk_period;
        
        report "Simulation Finished" severity FAILURE;
    end process;
end Behavioral;
