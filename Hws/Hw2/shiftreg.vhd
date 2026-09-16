library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shiftreg is
port ( 
    -- clock
    i_clk : in std_logic;
    -- active high synchronous reset
    i_rst : in std_logic;
    -- parallel inputs
    i_a : in std_logic;
    i_b : in std_logic;
    i_c : in std_logic;
    i_d : in std_logic;
    -- serial inputs
    i_sr : in std_logic;
    i_sl : in std_logic;
    -- control inputs
    i_s1 : in std_logic;
    i_s0 : in std_logic; 
    -- parallel output
    o_a : out std_logic;
    o_b : out std_logic;
    o_c : out std_logic;
    o_d : out std_logic  
);
end shiftreg;

architecture Behavioral of shiftreg is

begin
    process (i_clk) 
        variable vsel : std_logic_vector(1 downto 0);
        variable vreg : std_logic_vector(3 downto 0);
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                vsel := (others => '0');
                vreg := (others => '0');
            else
                vsel := i_s1 & i_s0;
                case vsel is
                    when "00" => -- shift left
                        vreg := vreg(2 downto 0) & i_sl;
                    when "01" => -- shift right
                        vreg := i_sr & vreg(3 downto 1);
                    when "10" => -- parallel load
                        vreg := i_a & i_b & i_c & i_d;
                    when others => -- "11" hold
                        vreg := vreg;
                end case;
            end if;
            (o_a, o_b, o_c, o_d) <= vreg;
        end if;

    end process;
end Behavioral;
