--  One process for state transitions, two processes for outputs, + one data path process

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity producer is
Port (
    i_clk : in std_logic;                     -- clock
    i_rst : in std_logic;                     -- reset

    i_send : in std_logic;                    -- initiate send
    i_data : in std_logic_vector(7 downto 0); -- data in

    o_req : out std_logic;                    -- request
    i_ack : in std_logic;                     -- acknowledge

    o_data : out std_logic_vector(7 downto 0) -- data out
);
end producer;

architecture Behavioral of producer is
    type state_type is (idle, ack_wait, send_data, hold_data);
    signal state : state_type;

    signal s_d_en  : std_logic;

begin
    -- State machine transitions process
    process (i_clk)
    begin
        if rising_edge(i_clk) then
            if (i_rst = '1') then
                state <= idle;
            else
                case state is
                    when idle =>
                        if i_send = '1' then
                            state <= ack_wait;
                        else
                            state <= idle;
                        end if;
                    when ack_wait =>
                        if i_ack = '0' then
                            state <= send_data;
                        else
                            state <= ack_wait;
                        end if;
                    when send_data =>
                        state <= hold_data;
                    when hold_data =>
                        if i_ack = '1' then
                            state <= idle;
                        else
                            state <= hold_data;
                        end if;
                end case;
            end if;
        end if;
    end process;

    -- State machine outputs
    process (state)
    begin
        case state is
            when idle | hold_data =>
                o_req <= '1';
            when ack_wait | send_data =>
                o_req <= '0';
        end case;
    end process;

    process (state)
    begin
        case state is
            when send_data => s_d_en <= '1';
            when others    => s_d_en <= '0';
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

end Behavioral;
