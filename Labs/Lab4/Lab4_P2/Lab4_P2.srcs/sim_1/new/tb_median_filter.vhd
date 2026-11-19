----------------------------------------------------------------------------------
-- tb_median_top
-- Feeds 3x3 test windows column by column (top, middle, bottom) using only
-- i_data + i_valid. median_top makes en1/en2 itself.
-- After column k (k >= 5), o_med = median of columns k-4, k-3, k-2.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_median_top is
end tb_median_top;

architecture Behavioral of tb_median_top is

    component median_top
        port (
            clk     : in std_logic;
            rst     : in std_logic;
            i_data  : in unsigned (7 downto 0);
            i_valid : in std_logic;
            o_med   : out unsigned (7 downto 0));
    end component;

    signal clk     : std_logic := '0';
    signal rst     : std_logic := '1';
    signal i_data  : unsigned (7 downto 0) := (others => '0');
    signal i_valid : std_logic := '0';
    signal o_med   : unsigned (7 downto 0);

    constant clk_period : time := 10 ns;
    constant n_cols     : integer := 20;

    type int_array is array (natural range <>) of integer;

    -- each line is one column: top, middle, bottom
    constant pixels : int_array(0 to n_cols*3 - 1) := (
        -- window 1: median 50 in the center
         90,  10,  70,
         20,  50,  80,
         30,  60,  40,
        -- window 2: median 99 in the top-left corner
         99, 200,   3,
        250,   1,  55,
          7, 180, 120,
        -- window 3: median 128 in the bottom-right corner
          5, 240,  12,
        230,   8, 250,
         15, 220, 128,
        -- window 4: salt (255) in the center, median 13 in the top row
         10,  12,  11,
         13, 255,  14,
          9,  15,  16,
        -- window 5: pepper (0) in a corner, median 215 in the center
        200, 210,   0,
        205, 215, 220,
        225, 230, 235,
        -- window 6: all the same
         77,  77,  77,
         77,  77,  77,
         77,  77,  77,
        -- 2 flush columns to push the last window out
          0,   0,   0,
          0,   0,   0);

    -- expected o_med after columns 5..20 (windows starting at column 1..16)
    -- windows 1,4,7,10,13,16 are the designed ones above, the rest are overlaps
    constant expected : int_array(0 to n_cols - 5) := (
        50, 50, 55, 99, 55, 120, 128, 15, 14, 13, 15, 200, 215, 215, 77, 77);

begin

    uut : median_top port map(
        clk     => clk,
        rst     => rst,
        i_data  => i_data,
        i_valid => i_valid,
        o_med   => o_med);

    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim : process
        variable errors : integer := 0;
    begin
        rst <= '1';
        wait for 50 ns;
        wait until rising_edge(clk);
        rst <= '0';
        wait until rising_edge(clk);

        for k in 0 to n_cols - 1 loop
            -- send one column (3 pixels), one per clock
            for r in 0 to 2 loop
                i_data  <= to_unsigned(pixels(k*3 + r), 8);
                i_valid <= '1';
                wait until rising_edge(clk);
            end loop;
            i_valid <= '0';

            -- check output once 5 columns are in
            wait for 1 ns;
            if k >= 4 then
                if to_integer(o_med) /= expected(k - 4) then
                    errors := errors + 1;
                end if;
                assert to_integer(o_med) = expected(k - 4)
                    report "Window at column " & integer'image(k - 3) &
                           ": got " & integer'image(to_integer(o_med)) &
                           ", expected " & integer'image(expected(k - 4))
                    severity error;
            end if;

            -- idle clock between columns (valid gaps should not matter)
            wait until rising_edge(clk);
        end loop;

        if errors = 0 then
            report "ALL WINDOWS PASSED" severity note;
        else
            report integer'image(errors) & " WINDOWS FAILED" severity error;
        end if;
        wait;
    end process;

end Behavioral;
