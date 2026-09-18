----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 09/10/2017 04:56:31 PM
-- Design Name:
-- Module Name: PS2interface - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PS2_behv is
port (

		CLK_100MHZ : in  std_logic;  -- Main FPGA clock, needed for designs with external clock

		PS2_CLK   : in  std_logic;  -- keyboard clock
		PS2_DATA  : in  std_logic;  -- keyboard data

		BTN_UP    : in  std_logic;
		SWITCH    : in  std_logic_vector (0 downto 0);
        LEDS      : out std_logic_vector (7 downto 0) -- Increase the length when displaying parity
	);
end PS2_behv;

architecture Behavioral of PS2_behv is

	signal sreg : std_logic_vector (7 downto 0);
	signal shex : std_logic_vector (15 downto 0);

	signal reset   : std_logic;
	signal ssel    : std_logic_vector (0 downto 0);
	signal new_clk : std_logic;
	
	-- Debug signal flags
	attribute mark_debug : string;
    attribute mark_debug of PS2_CLK: signal is "true";
    attribute mark_debug of PS2_DATA: signal is "true";
    attribute mark_debug of sreg: signal is "true";	
	
	component clk_wiz_0
        port
         (-- Clock in ports
          -- Clock out ports
          clk_out1          : out    std_logic;
          -- Status and control signals
          reset             : in     std_logic;
          clk_in1           : in     std_logic
         );
    end component;

begin

    your_instance_name : clk_wiz_0
       port map ( 
      -- Clock out ports  
       clk_out1 => new_clk,
      -- Status and control signals 
      reset=> BTN_UP,              
       -- Clock in ports
       clk_in1 => CLK_100MHZ
     );
    
    reset <= BTN_UP;
	ssel  <= SWITCH;

	------------------------------------------------------------
	-- Reading with PS/2 clock synchronization
	------------------------------------------------------------
	process (ps2_clk, reset)
		variable vcounter : unsigned(3 downto 0);
		variable vreading : std_logic;
	begin

		if (reset = '1') then
            vreading  := '0';
            vcounter  := (others => '0');
            sreg      <= (others => '0');
            shex      <= (others => '0');

		elsif (PS2_CLK'event and PS2_CLK = '0') then
			if vreading = '1' then
				if vcounter < 9 then
					if vcounter < 8 then
						sreg <= PS2_DATA & sreg(7 downto 1);
					end if;
					vcounter := vcounter + 1;
				else
					vreading := '0';
					vcounter := (others => '0');
					shex(15 downto 12) <= sreg(7 downto 4);
					shex(11 downto 8)  <= sreg(3 downto 0);
					shex(7  downto 0)  <= shex(15 downto 8);
				end if;
			elsif PS2_DATA = '0' then
				vreading := '1';
				vcounter := (others => '0');
			end if;
		end if;
	end process;

	------------------------------------------------------------
	-- Select the output
	------------------------------------------------------------
	process (ssel, shex)
	begin
		case ssel is
			when "0" => LEDS <= shex (15 downto 8);
			when "1" => LEDS <= shex (7  downto 0);
			when others => LEDS <= X"FF";
		end case;
	end process;

end Behavioral;
