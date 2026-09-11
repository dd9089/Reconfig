--  One process for next state logic, one process for memory(register), three processes for outputs, + one data path process

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity consumer is
Port ( 
    i_clk : in std_logic;                     -- clock
    i_rst : in std_logic;                     -- reset 

    i_req : in std_logic;                     -- request
    o_ack : out std_logic;                    -- acknowledge 
    i_data : in std_logic_vector(7 downto 0); -- data out
    
    o_recv : out std_logic;                   -- recieved something
    o_data : out std_logic_vector(7 downto 0) -- data out 
);
end consumer;

architecture Behavioral of consumer is
    type state_type is (idle, send_ack, read_data);
    signal current_state, next_state : state_type;
    
    signal s_d_en  : std_logic; 
    
begin
    
    process (current_state, i_req) 
    begin
      case current_state is
         when idle => 
            if i_req = '0' then
                next_state <= send_ack;
            else 
                next_state <= idle;
            end if;
         when send_ack => 
            if i_req = '1' then
              next_state <= read_data;
            else 
              next_state <= send_ack;
            end if;
         when read_data => 
            next_state <= idle;
         end case;
    end process;

    process (i_clk) 
    begin
        if rising_edge(i_clk) then
            if (i_rst = '1') then
              current_state <= idle;
            else
              current_state <= next_state;
            end if;
        end if;
    end process;

   -- State machine outputs
    process (current_state) 
    begin
      case current_state is
        when idle   => o_ack <= '1';
        when others => o_ack <= '0'; 
      end case;
    end process;
    
    process (current_state) 
    begin
      case current_state is
        when read_data => o_recv <= '1';
        when others   =>  o_recv <= '0';    
      end case;
    end process;

    process (current_state) 
    begin
      case current_state is
        when read_data => s_d_en <= '1';
        when others   =>  s_d_en <= '0';    
      end case;
    end process;

  	------------------------------------
 
  	------------------------------------
    -- Data path process
    process (i_clk) 
    begin
        if rising_edge(i_clk) then
          if (i_rst = '1') then
             o_data <= (others=>'0');
          else   
            if s_d_en = '1' then
                o_data <= i_data;
            end if;
          end if;  
        end if;
    end process;
    ------------------------------------  
    
end Behavioral;