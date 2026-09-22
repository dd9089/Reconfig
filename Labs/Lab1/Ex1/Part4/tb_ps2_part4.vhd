library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ps2 is
end tb_ps2;

architecture behavior of tb_ps2 is

	-- Component Declaration for the Unit Under Test (UUT)
    -- TODO Fill this in
    component ps2_keyboard is
        port( PS2_CLK  : in  std_logic;
              PS2_DATA : in  std_logic;
		      BTN_UP   : in  std_logic;
		      CLK_100MHz : in std_logic;
		      SWITCH   : in  std_logic_vector (0 downto 0);
              LEDS     : out std_logic_vector (9 downto 0));
    end component;
    
	-- Inputs
	signal	clk			    : std_logic:='1';
	signal	clk_active      : std_logic:='0';
	signal	btn_up			: std_logic:='1';
	signal	data    		: std_logic:='1';
	signal  clk_100Mhz      : std_logic:='0';
	signal	switch   		: std_logic_vector (0 downto 0):=(others=>'0');

	-- Outputs
	signal	LEDs			: std_logic_vector (9 downto 0);


	-- clk period definitions
	constant clk_period : time := 100 us;
    constant key        : std_logic_vector(7 downto 0) := X"15";
    constant key_par    : std_logic                    :=   '0';
    constant break      : std_logic_vector(7 downto 0) := X"F0";
    constant break_par  : std_logic                    :=   '1';

begin

    -- Component Instantiation
    -- TODO Instantiate it
    uut : ps2_keyboard
        port map (
            PS2_CLk    => clk,
            PS2_DATA   => data,
            BTN_UP     => btn_up,
            CLK_100MHz => clk_100MHz,
            SWITCH     => switch,
            LEDS       => LEDs); 
    
    clk <= not clk after clk_period/2 when clk_active = '1';
    clk_100MHz <= not clk_100MHz after 5 ns;

	-- Stimulus process
	process
	begin
		-- hold BTN_UP state for 100 ns
		wait for clk_period;
		BTN_UP <= '0';

        clk_active <= '1';
        data <= '0'; -- start bit
        wait for clk_period*5/4; -- offset data from clock edge
        for i in 0 to key'high loop
            data <= key(i);
            wait for clk_period;
        end loop;
        data <= key_par;
        wait for clk_period;
        data <= '1'; -- stop bit
        wait for clk_period*1/4; -- ensure clock stops high
        clk_active <= '0';

        wait for clk_period*4;

        clk_active <= '1';
        data <= '0'; -- start bit
        wait for clk_period*5/4; -- offset data from clock edge
        for i in 0 to break'high loop
            data <= break(i);
            wait for clk_period;
        end loop;
        data <= break_par;
        wait for clk_period;
        data <= '1'; -- stop bit
        wait for clk_period*1/4; -- ensure clock stops high
        clk_active <= '0';

        wait for clk_period*4;

        clk_active <= '1';
        data <= '0'; -- start bit
        wait for clk_period*5/4; -- offset data from clock edge
        for i in 0 to key'high loop
            data <= key(i);
            wait for clk_period;
        end loop;
        data <= key_par;
        wait for clk_period;
        data <= '1'; -- stop bit
        wait for clk_period*1/4; -- ensure clock stops high
        clk_active <= '0';

        wait for clk_period;


    switch <= not switch;
    wait for clk_period*2;

    assert false
      report "End of tests"
        severity failure;
	end process;

end behavior;

