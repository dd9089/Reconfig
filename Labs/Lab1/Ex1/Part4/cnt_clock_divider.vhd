------------------------------------------------------------
-- Slowing down a counter with a clock divider (sclk_enable)
-- In our case this approach will be used for all sequential 
-- components (except the clock divider itself)
------------------------------------------------------------

process(clk_100MHz)
begin
  if (clk_100MHz'event and clk_100MHz = '1') then
    if (sreset = '1') then
      scounter <= (others => '0');
    elsif (sclk_enable = '1') then
      scounter <= std_logic_vector(unsigned(scounter) + 1);
    end if;
  end if;
end process;


------------------------------------------------------------
-- Clock divider for clk_enable
------------------------------------------------------------
process (clk_100MHz, sreset)
begin
  if (clk_100MHz'event and clk_100MHz='1') then
    if (sreset = '1') then
      sclk_divider <= (others => '0');
      sclk_enable <= '0';
    elsif (sclk_divider = "XXXXXXXX") then          -- make it 256
      sclk_divider <= (others => '0');
      sclk_enable <= '1';
    else
      sclk_divider <= std_logic_vector(unsigned(sclk_divider) + 1);
      sclk_enable <= '0';
    end if;
  end if;
end process;
