----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/10/2026 08:53:54 PM
-- Design Name: 
-- Module Name: addsub - direct_arch
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

entity addsub is
    Port (
        a   : in std_logic_vector (7 downto 0);
        b   : in std_logic_vector (7 downto 0);
        ctr : in std_logic;
        r   : out std_logic_vector (7 downto 0));
end addsub;

architecture direct_arch of addsub is
    signal src0, src1, sum: signed (7 downto 0);
begin
    src0 <= signed(a);
    src1 <= signed(b);
    sum  <= src0 + src1 when ctr = '0' else
        src0 - src1;
    r    <= std_logic_vector(sum);
end direct_arch;

--architecture manual_carry_arch of addsub is
--    signal src0, src1, sum: signed (8 downto 0);
--    signal b_tmp: std_logic_vector (7 downto 0);
--    signal cin  : std_logic;
--begin
--    src0 <= signed(a & '1');
--    b_tmp <= b when ctr='0' else  
--        not b;
--   cin <= '0' when ctr='0' else
--        '1';
--    src1 <= signed(b_tmp & cin);
--    sum <=src0 + src1;
--    r <= std_logic_vector(sum(8 downto 1));
--end manual_carry_arch;
