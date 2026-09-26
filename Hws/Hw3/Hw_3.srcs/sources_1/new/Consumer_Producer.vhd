--  One process for state transitions, two processes for outputs, + one data path process

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TwoWayHandshake is
Port (
    i_clk : in std_logic;                     -- clock
    i_rst : in std_logic;                     -- reset

    i_data : in std_logic_vector(7 downto 0); -- data 
    
    i_req : in std_logic;                     -- request
    o_ack : out std_logic;                    -- acknowledge 

    o_req : out std_logic;                    -- request
    i_ack : in std_logic;                     -- acknowledge

    o_data : out std_logic_vector(7 downto 0)  -- data out
);
end TwoWayHandshake;


architecture Behavioral of TwoWayHandshake is
    type state_type is (idle, send_ack, read_data, ack_wait, send_data, hold_data);
    signal hybrid_state : state_type;

    signal s_d_en_i  : std_logic; -- for the input data latch
    signal s_d_en_o  : std_logic; -- for the output data latch
    

begin
    -- State machine transitions process
    process (i_clk)
    begin
        if rising_edge(i_clk) then
            if (i_rst = '1') then
                hybrid_state <= idle;
            else
                case hybrid_state is
                    when idle =>
                        if i_req = '0' then
                            hybrid_state <= send_ack;
                        else
                            hybrid_state <= idle;
                        end if;
                    when send_ack =>
                        if i_req = '1' then
                            hybrid_state <= read_data;
                        else
                            hybrid_state <= send_ack;
                        end if;
                    when read_data =>
                        hybrid_state <= ack_wait;
                    when ack_wait =>
                        if i_ack = '0' then
                            hybrid_state <= send_data;
                        else
                            hybrid_state <= ack_wait;
                        end if;
                    when send_data =>
                        hybrid_state <= hold_data;
                    when hold_data =>
                        if i_ack = '1' then
                            hybrid_state <= idle;
                        else
                            hybrid_state <= hold_data;
                        end if;
                end case;
            end if;
        end if;
    end process;

    -- State machine outputs
    process (hybrid_state)
    begin
        case hybrid_state is
            when ack_wait | send_data => o_req <= '0'; 
            when others => o_req <= '1';
        end case;
    end process;

    process (hybrid_state)
    begin
        case hybrid_state is
            when send_data => s_d_en_o <= '1';
            when others    => s_d_en_o  <= '0';
        end case;
    end process;
    
    process (hybrid_state)
    begin
        case hybrid_state is 
            when read_data => s_d_en_i <= '1';
            when others => s_d_en_i <= '0';
        end case;
    end process;
    
    process (hybrid_state)
    begin
        case hybrid_state is 
            when send_ack | read_data => o_ack <= '0';
            when others => o_ack <= '1';
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
            if s_d_en_o = '1' then
                o_data <= i_data;
            end if;
            if s_d_en_i = '1' then 
                o_data <= i_data;
            end if;
          end if;
        end if;
    end process;

end Behavioral;
