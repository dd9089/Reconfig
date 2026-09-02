
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity XilinxIntro_tb is
end XilinxIntro_tb;

architecture Behavioral of XilinxIntro_tb is
component  XilinxIntro is 
port ( a          : in std_logic_vector (3 downto 0); 
       y1, y2, y3 : out std_logic ); 
end component;

signal sa : std_logic_vector (3 downto 0) := X"0"; 
signal sy1, sy2, sy3: std_logic;

begin
uut: XilinxIntro port map (a => sa, y1 => sy1, y2 => sy2, y3 => sy3);

stim_proc: process 
begin 
sa <= X"0";
wait for 10ns; 
sa <= X"F";
wait for 10ns; 
sa <= "1010";
wait for 10ns; 
sa <= "0001";
wait for 10ns; 
sa <= "1110";
wait for 10ns; 
wait;
end process;

end Behavioral;
