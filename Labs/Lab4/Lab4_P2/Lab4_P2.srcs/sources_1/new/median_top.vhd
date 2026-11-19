----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2026 02:34:49 PM
-- Design Name: 
-- Module Name: median_top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity median_top is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        i_data : in unsigned ( 7 downto 0);
        i_valid : in std_logic;
        o_med : out unsigned (7 downto 0));
end median_top;

architecture Behavioral of median_top is
    signal count : unsigned (2 downto 0);
    signal en1  : std_logic;
    signal en2  : std_logic;
    
    component median_filter
        port (
            clk : in std_logic;
            rst : in std_logic;
            i_data : in unsigned (7 downto 0);
            i_en1  : in std_logic;
            i_en2  : in std_logic;
            o_med  : out unsigned (7 downto 0));
   end component;
    
begin
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                count <= (others => '0');
            elsif i_valid = '1' then
                if count = 2 then
                    count <= (others => '0');
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;
    
    process (count, i_valid)
    begin
        if count = 2 then
            en1 <= '0';
        else
            en1 <= i_valid;
        end if;
    end process;

    process (count, i_valid)
    begin
        if count = 2 then
            en2 <= i_valid;
        else
            en2 <= '0';
        end if; 
    end process;
    
     filter : median_filter port map(
       clk => clk,
       rst => rst,
       i_data => i_data,
       i_en1 => en1,
       i_en2 => en2,
       o_med => o_med); 
end Behavioral;
