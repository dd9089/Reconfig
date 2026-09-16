library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity ps2_keyboard is
   port (PS2_CLK  : in  std_logic;
         PS2_DATA : in  std_logic;
		 SWITCH   : -- to be completed
         LEDS     : out std_logic(7 downto 0));
end entity;

architecture rtl of ps2_keyboard is
-- declaration of state type to be completed
type tstates is (idle, r0, r1, ...  );
signal sstate : tstates;

-- sreg for storing the keyboard make and break codes
-- in the final design it needs to be longer 
signal sreg : std_logic_vector (7 downto 0);
signal spar : std_logic;

-- control outputs 'read data', 'read parity', 'read stop'
signal srd, srp, srs : std_logic;

begin
-- control unit to be completed
process(ps2_clk)
begin
  if ps2_clk'event and ps2_clk='1' then
    case sstate is
	  when idle => if ps2_data='0' then 
	                  sstate <= r0;
	    		   end if; 

	  when r0 => sstate <= r1; 	
      when r1 => sstate <= r2;	  
	  
-- ....
end process;

-- output logic for srd (read data), srp(read parity), and srs (read stop)
-- one statement for each of the control signals - to be completed





-- datapath to be completed 
process(ps2_clk)
begin
  if ps2_clk'event and ps2_clk='1' then
   if srd = '1' then
     sreg <= ps2_data & sreg(7 downto 1);
   end if;
  end if;
end process;

leds <= sreg;

end rtl;  

					  
