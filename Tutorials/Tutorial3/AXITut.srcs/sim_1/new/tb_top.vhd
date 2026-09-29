library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top is
end tb_top;

architecture behav of tb_top is
    --
    -- Helper function to print std_logic_vectors more easily
    function vec2str(vec: std_logic_vector) return string is
        variable stmp: string(vec'high+1 downto 1);
        variable counter : integer := 1;
    begin
        for i in vec'reverse_range loop
            stmp(counter) := std_logic'image(vec(i))(2); -- image returns '1' (with quotes)
            counter := counter + 1;
        end loop;
        return stmp;
    end vec2str;

	component axi_top
	port (
			RST : in std_logic;
			CLK_100MHZ : in std_logic;
            WR_BTN     : in std_logic;
			SWITCHES : in std_logic_vector (15 downto 0);
			LEDs : out std_logic_vector (15 downto 0)
	);
	end component;

	signal RST : std_logic := '1';
	signal CLK_100MHZ : std_logic := '0';
	signal WR_BTN : std_logic := '0';
	signal SWITCHES : std_logic_vector (15 downto 0) := (others => '0');
	signal LEDs : std_logic_vector (15 downto 0);

    constant clk_period : time := 10 ns;
	begin


	UUT: axi_top 	port map (
		RST => RST,
		CLK_100MHZ => CLK_100MHZ,
		WR_BTN => WR_BTN,
		SWITCHES => SWITCHES,
		LEDs => LEDs
	);

    CLK_100MHZ <= not CLK_100MHZ after clk_period/2;

	stim_process: process
	   variable old_switches : std_logic_vector(15 downto 0);
    begin
        wait for clk_period*3;
        RST <= '0';

        for i in 0 to 256 loop
            old_switches := switches;
            SWITCHES <= std_logic_vector(to_unsigned(i*2, 16));          
            wait for clk_period*20;
            
            WR_BTN <= '1';
            wait for clk_period*2;
            WR_BTN <= '0';
            wait for clk_period*20;
            assert SWITCHES = LEDS
                report "Read or write failed at " & time'image(now) & " Got: " & vec2str(LEDs) & " Expected: " & vec2str(SWITCHES)
                severity error;
        end loop;

		assert false
			report "Simulation finished"
			severity failure;
	end process stim_process;

end behav;
