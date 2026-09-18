library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity ps2_keyboard is
   port (PS2_CLK    : in  std_logic;
         PS2_DATA   : in  std_logic;
		 BTN_UP     : in  std_logic;
		 CLK_100MHZ : in std_logic;
		 SWITCH     : in  std_logic_vector (0 downto 0);
         LEDS       : out std_logic_vector (9 downto 0));
end entity;

architecture rtl of ps2_keyboard is
-- declaration of state type to be completed
type tstates is (idle, r0, r1, r2, r3, r4, r5, r6, r7, rp, rs);
signal sstate : tstates;

-- sreg for storing the keyboard make and break codes
-- in the final design it needs to be longer 
signal sreg     : std_logic_vector (7 downto 0);
signal spar     : std_logic;
signal reset    : std_logic;
signal calc_par : std_logic;

-- control outputs 'read data', 'read parity', 'read stop'
signal srd, srp, srs : std_logic;

signal curr_byte, prev_byte         : std_logic_vector (7 downto 0);
signal curr_par, prev_par           : std_logic;
signal curr_calc_par, prev_calc_par : std_logic;

-- Clock divider signals
signal sclk_divider : std_logic_vector (7 downto 0);
signal sclk_enable  : std_logic;

signal ps2_en        : std_logic;  
signal ps2_data_sync : std_logic_vector (3 downto 0);
signal ps2_clk_sync  : std_logic_vector (3 downto 0);   

begin
reset <= BTN_UP;

process (clk_100MHZ, reset)
begin
  if (CLK_100MHZ'event and CLK_100MHZ ='1') then
    if (reset = '1') then
      sclk_divider <= (others => '0');
      sclk_enable <= '0';
    elsif (sclk_divider = x"FF") then          -- make it 256
      sclk_divider <= (others => '0');
      sclk_enable <= '1';
    else
      sclk_divider <= std_logic_vector(unsigned(sclk_divider) + 1);
      sclk_enable <= '0';
    end if;
  end if;
end process;

ps2_en <=  sclk_enable and ps2_clk_sync(3) and not ps2_clk_sync(2);

process (CLK_100MHZ, reset)
begin
    if reset = '1' then
        ps2_data_sync <= (others => '0');
        ps2_clk_sync <= (others => '0');
    elsif CLK_100MHZ'event and CLK_100MHZ='1' then
        if sclk_enable = '1' then
            ps2_data_sync <= ps2_data_sync (2 downto 0) & PS2_DATA;
            ps2_clk_sync  <= ps2_clk_sync  (2 downto 0) & PS2_CLK;
        end if;
    end if;
end process;

-- control unit to be completed
process(CLK_100MHZ, reset)
begin  
  if reset = '1' then
    sstate <= idle;
  elsif CLK_100MHZ'event and CLK_100MHZ='1' then
    if ps2_en = '1' then
        case sstate is
          when idle => if ps2_data_sync(3) ='0' then 
                          sstate <= r0;
                       end if;
          when r0 => sstate <= r1; 	
          when r1 => sstate <= r2;
          when r2 => sstate <= r3;
          when r3 => sstate <= r4;
          when r4 => sstate <= r5;
          when r5 => sstate <= r6;
          when r6 => sstate <= r7;
          when r7 => sstate <= rp;
          when rp => sstate <= rs;
          when rs => sstate <= idle;
        end case;
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
        when r0 | r1 | r2 | r3 | r4 | r5 | r6 | r7 => srd <= '1';
        when rp => srp <= '1';
        when rs => srs <= '1';
        when others => null;
    end case;
end process;

-- datapath to be completed 
process(CLK_100MHZ, reset)
begin
  if reset = '1' then
    sreg <= (others => '0');
    spar <= '0';
  elsif CLK_100MHZ'event and CLK_100MHZ='1' then
   if ps2_en = '1' then 
       if srd = '1' then
         sreg <= ps2_data_sync(3) & sreg(7 downto 1);
       end if;
       if srp = '1' then 
         spar <= ps2_data_sync(3);
       end if;
    end if;
  end if;
end process;

calc_par <= not (sreg(0) xor sreg(1) xor sreg(2) xor sreg(3) xor sreg(4) xor sreg(5) xor sreg(6) xor sreg(7));

process (CLK_100MHZ, reset)
begin
    if reset = '1' then
        curr_byte <= (others => '0');
        prev_byte <= (others => '0');
        
        curr_par <= '0';
        prev_par <= '0';
        
        curr_calc_par <= '0';
        prev_calc_par <= '0';
    elsif CLK_100MHZ'event and CLK_100MHZ = '1' then
        if ps2_en = '1' then
            if srs = '1' then
                prev_calc_par <= curr_calc_par;
                curr_calc_par <= calc_par;
                
                prev_par <= curr_par;
                curr_par <= spar;
                
                prev_byte <= curr_byte;
                curr_byte <= sreg;
            end if;
        end if;
    end if;    
end process;

with SWITCH select
    LEDS <= curr_calc_par & curr_par & curr_byte when "0",
            prev_calc_par & prev_par & prev_byte when others;
end rtl;  