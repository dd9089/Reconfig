library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Combinational_Output is
Port (
    i_clk : in std_logic;                     -- clock
    i_rst : in std_logic;                     -- reset

    w : in std_logic;                         -- input

    z : out std_logic                         -- Output

);
end Combinational_Output;

architecture Behavioral of Combinational_Output is
    type state_type is (A, B, C);
    signal state : state_type;
    signal next_state: state_type;


begin
    -- State Register Memory
    process (i_clk)
    begin
        if rising_edge(i_clk) then
            if (i_rst = '0') then
                state <= A;
            else
                state <= next_state;
            end if;
       end if;
   end process;
   
   -- Next State Logic
   process (state, w)
   begin
        case state is
            when A =>
                if w = '1' then
                    next_state <= B;
                else
                    next_state <= A;
                end if;
             when B =>
                if W = '1' then
                    next_state <= C;
                else
                    next_state <= A;
                end if;
             when C =>
                if w = '1' then
                    next_state <= C;
                else
                    next_state <= A;
                end if;
          end case;
    end process;

    -- State machine outputs
    process (state)
    begin
        case state is
            when C =>
                z <= '1';
            when others =>
                z <= '0';
        end case;
    end process;

end Behavioral;
