library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL;

entity XilinxIntro is 
port ( a          : in std_logic_vector (7 downto 0); 
       y1, y2, y3 : out std_logic ); 
end XilinxIntro;

architecture rtl of XilinxIntro is 
signal s_tmp : std_logic := '1';

begin
---------------------------
process (a)
begin
  s_tmp <= '1';
  for i in 0 to 7 loop
    s_tmp <= s_tmp and a(i);
  end loop;
  y1 <= s_tmp;
end process;
---------------------------
---------------------------
process (a)
variable v_tmp : std_logic := '1';
begin
  for i in 0 to 7 loop
    v_tmp := v_tmp and a(i);
  end loop;
  y2 <= v_tmp;
end process;
---------------------------
---------------------------
process (a)
-----------
function f_and (a : in std_logic_vector (7 downto 0)) return std_logic is
variable v_tmp : std_logic := '1';
begin
  for i in 0 to 7 loop
    v_tmp := v_tmp and a(i);
  end loop;
  return v_tmp;
end function f_and;
-----------
begin
 y3 <= f_and(a);
end process;
---------------------------
end architecture;

