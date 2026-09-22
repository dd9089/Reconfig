library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity ps2_keyboard is
   port (PS2_CLK  : in  std_logic;
         PS2_DATA : in  std_logic;
		 BTN_UP   : in  std_logic;
		 SWITCH   : in  std_logic_vector (0 downto 0);
         LEDS     : out std_logic_vector (9 downto 0));
end entity;

architecture rtl of ps2_keyboard is
-- declaration of state type to be completed
type tstates is (idle, rd, rp, rs);
signal sstate : tstates;

-- sreg for storing the keyboard make and break codes
-- in the final design it needs to be longer 
signal sreg     : std_logic_vector (7 downto 0);
signal spar     : std_logic;
signal reset    : std_logic;
signal calc_par : std_logic;
signal count    : integer range 0 to 8;

-- control outputs 'read data', 'read parity', 'read stop'
signal srd, srp, srs : std_logic;

signal curr_byte, prev_byte         : std_logic_vector (7 downto 0);
signal curr_par, prev_par           : std_logic;
signal curr_calc_par, prev_calc_par : std_logic;

begin
reset <= BTN_UP;
-- control unit to be completed
process(ps2_clk, reset)
begin  
  if reset = '1' then
    sstate <= idle;
  elsif ps2_clk'event and ps2_clk='0' then
    case sstate is
	  when idle => if ps2_data='0' then 
	                  sstate <= rd;
	    		   end if;
	  when rd => 
	       if count = 7 then
	           sstate <= rp;
	       end if;
      when rp => sstate <= rs;
      when rs => sstate <= idle;
    end case;
  end if;
end process;

process(ps2_clk, reset)
begin  
  if reset = '1' then
    count <= 0;

  elsif ps2_clk'event and ps2_clk='0' then
    if sstate = idle then
        count <= 0;
    elsif srd = '1' then
        count <= count + 1;
    end if;
  end if;
end process;

-- output logic for srd (read data), srp(read parity), and srs (read stop)
-- one statement for each of the control signals - to be completed
process(sstate)
begin
    srd <= '0';
    srp <= '0';
    srs <= '0';
    
    case sstate is
        when rd => srd <= '1';
        when rp => srp <= '1';
        when rs => srs <= '1';
        when others => null;
    end case;
end process;

-- datapath to be completed 
process(ps2_clk, reset)
begin
  if reset = '1' then
    sreg <= (others => '0');
    spar <= '0';
  elsif ps2_clk'event and ps2_clk='0' then
   if srd = '1' then
     sreg <= ps2_data & sreg(7 downto 1);
   end if;
   if srp = '1' then 
     spar <= PS2_DATA;
   end if;
  end if;
end process;

calc_par <= not (sreg(0) xor sreg(1) xor sreg(2) xor sreg(3) xor sreg(4) xor sreg(5) xor sreg(6) xor sreg(7));

process (ps2_clk, reset)
begin
    if reset = '1' then
        curr_byte <= (others => '0');
        prev_byte <= (others => '0');
        
        curr_par <= '0';
        prev_par <= '0';
        
        curr_calc_par <= '0';
        prev_calc_par <= '0';
    elsif ps2_clk'event and ps2_clk = '0' then
        if srs = '1' then
            prev_calc_par <= curr_calc_par;
            curr_calc_par <= calc_par;
            
            prev_par <= curr_par;
            curr_par <= spar;
            
            prev_byte <= curr_byte;
            curr_byte <= sreg;
        end if;
    end if;    
end process;

with SWITCH select
    LEDS <= curr_calc_par & curr_par & curr_byte when "0",
            prev_calc_par & prev_par & prev_byte when others;
end rtl;  