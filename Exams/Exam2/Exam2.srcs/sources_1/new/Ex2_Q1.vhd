----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/05/2026 05:49:51 PM
-- Design Name: 
-- Module Name: Ex2_Q1 - Behavioral
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

entity Ex2_Q1 is
    Port (
        clk         : in std_logic;
        reset       : in std_logic;
        up_ndn      : in std_logic;
        p_load      : in std_logic;
        p_load_data : in std_logic_vector (2 downto 0);
        cnt_out     : out std_logic_vector (2 downto 0)
        );
end Ex2_Q1;

architecture RTL of Ex2_Q1 is
    signal cnt      : unsigned (2 downto 0) := (others => '0');
begin    
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                cnt <= (others => '0');
            elsif p_load = '1' then
                cnt <= unsigned(p_load_data);
            elsif up_ndn = '1' then
                cnt <= cnt + 1;                
            else
                cnt <= cnt - 1;
            end if;        
        end if;
    end process;
    
    cnt_out <= std_logic_vector(cnt);
end RTL;
