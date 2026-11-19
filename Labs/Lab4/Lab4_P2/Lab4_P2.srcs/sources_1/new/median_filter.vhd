----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2026 10:38:07 AM
-- Design Name: 
-- Module Name: median_filter - Behavioral
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

entity median_filter is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        i_data : in unsigned (7 downto 0);
        i_en1 : in std_logic;
        i_en2 : in std_logic;
        o_med : out unsigned (7 downto 0));
end median_filter;

architecture Behavioral of median_filter is
    signal r1 : unsigned (7 downto 0) := (others => '0');
    signal r2 : unsigned (7 downto 0) := (others => '0');
    
    signal a : unsigned (7 downto 0) := (others => '0');
    signal b : unsigned (7 downto 0) := (others => '0');
    signal c : unsigned (7 downto 0) := (others => '0');
    
    signal h1 : unsigned (7 downto 0) := (others => '0');
    signal m1 : unsigned (7 downto 0) := (others => '0');
    signal l1 : unsigned (7 downto 0) := (others => '0');
    
    signal h2 : unsigned (7 downto 0) := (others => '0');
    signal m2 : unsigned (7 downto 0) := (others => '0');
    signal l2 : unsigned (7 downto 0) := (others => '0');
    
    signal h3 : unsigned (7 downto 0) := (others => '0');
    signal mh3 : unsigned (7 downto 0) := (others => '0');
    signal ml3 : unsigned (7 downto 0) := (others => '0');
    signal l3 : unsigned (7 downto 0) := (others => '0');
    
    signal h4 : unsigned (7 downto 0) := (others => '0');
    signal m4 : unsigned (7 downto 0) := (others => '0');
    signal l4 : unsigned (7 downto 0) := (others => '0');
    
    signal s1_h : unsigned (7 downto 0) := (others => '0');
    signal s1_l : unsigned (7 downto 0) := (others => '0');
    
    signal s2_h : unsigned (7 downto 0) := (others => '0');
    signal s2_l : unsigned (7 downto 0) := (others => '0');
    
    signal s3_h : unsigned (7 downto 0) := (others => '0');
    signal s3_l : unsigned (7 downto 0) := (others => '0');
    
    signal s4_h : unsigned (7 downto 0) := (others => '0');
    signal s4_l : unsigned (7 downto 0) := (others => '0');
    
    signal s5_h : unsigned (7 downto 0) := (others => '0');
    signal s5_l : unsigned (7 downto 0) := (others => '0');
    
    signal s6_h : unsigned (7 downto 0) := (others => '0');
    signal s6_l : unsigned (7 downto 0) := (others => '0');
    
    signal s7_h : unsigned (7 downto 0) := (others => '0');
    signal s7_l : unsigned (7 downto 0) := (others => '0');
    
    signal s8_h : unsigned (7 downto 0) := (others => '0');
    signal s8_l : unsigned (7 downto 0) := (others => '0');
    
    signal s9_h : unsigned (7 downto 0) := (others => '0');
    signal s9_l : unsigned (7 downto 0) := (others => '0');
    
    signal s10_h : unsigned (7 downto 0) := (others => '0');
    signal s10_l : unsigned (7 downto 0) := (others => '0');
    
    signal s11_h : unsigned (7 downto 0) := (others => '0');
    signal s11_l : unsigned (7 downto 0) := (others => '0');
    
    signal s12_h : unsigned (7 downto 0) := (others => '0');
    signal s12_l : unsigned (7 downto 0) := (others => '0');
    
    signal s13_h : unsigned (7 downto 0) := (others => '0');
    
    component two_sort 
        port(
            a : in unsigned (7 downto 0);
            b : in unsigned (7 downto 0);
            low : out unsigned (7 downto 0);
            hi : out unsigned (7 downto 0));
    end component;
begin
    s1 : two_sort port map(
       a => a,
       b => b,
       low => s1_l,
       hi => s1_h); 
    
    s2 : two_sort port map(
        a => s1_h,
        b => s3_h,
        low => s2_l,
        hi => s2_h);
        
    s3 : two_sort port map(
        a => s1_l,
        b => c,
        low => s3_l,
        hi => s3_h);

    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                r1 <= (others => '0');
            elsif i_en1 = '1' then
                r1 <= i_data;
            end if;
        end if;
    end process;  
    
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                r2 <= (others => '0');
            elsif i_en1 = '1' then
                r2 <= r1;
            end if;
        end if;
    end process; 
    
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                A <= (others => '0');
            elsif i_en2 = '1' then
                A <= r2;
            end if;
        end if;
    end process;
    
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                B <= (others => '0');
            elsif i_en2 = '1' then
                B <= r1;
            end if;
        end if;
    end process;
    
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                C <= (others => '0');
            elsif i_en2 = '1' then
                C <= i_data;
            end if;
        end if;
    end process;
    
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                h1 <= (others => '0');
            elsif i_en2 = '1' then
                h1 <= s2_h;
            end if;
        end if;
    end process;
    
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                m1 <= (others => '0');
            elsif i_en2 = '1' then
                m1 <= s2_l;
            end if;
        end if;
    end process;
    
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                l1 <= (others => '0');
            elsif i_en2 = '1' then
                l1 <= s3_l;
            end if;
        end if;
    end process;
    
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                h2 <= (others => '0');
            elsif i_en2 = '1' then
                h2 <= h1;
            end if;
        end if;
    end process;
    
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                m2 <= (others => '0');
            elsif i_en2 = '1' then
                m2 <= m1;
            end if;
        end if;
    end process;
    
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                l2 <= (others => '0');
            elsif i_en2 = '1' then
                l2 <= l1;
            end if;
        end if;
    end process;
    
     s4 : two_sort port map(
       a => h1,
       b => h2,
       low => s4_l,
       hi => s4_h); 
        
     s5 : two_sort port map(
       a => m1,
       b => m2,
       low => s5_l,
       hi => s5_h); 
     
     s6 : two_sort port map(
       a => l1,
       b => l2,
       low => s6_l,
       hi => s6_h); 
    
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                h3 <= (others => '0');
            elsif i_en2 = '1' then
                h3 <= s4_l;
            end if;
        end if;
    end process;
    
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                mh3 <= (others => '0');
            elsif i_en2 = '1' then
                mh3 <= s5_h;
            end if;
        end if;
    end process;
    
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                ml3 <= (others => '0');
            elsif i_en2 = '1' then
                ml3 <= s5_l;
            end if;
        end if;
    end process;
    
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                l3 <= (others => '0');
            elsif i_en2 = '1' then
                l3 <= s6_h;
            end if;
        end if;
    end process;    
    
     s7 : two_sort port map(
       a => h3,
       b => h1,
       low => s7_l,
       hi => s7_h); 
       
     s8 : two_sort port map(
       a => ml3,
       b => m1,
       low => s8_l,
       hi => s8_h); 
    
     s9 : two_sort port map(
       a => mh3,
       b => s8_h,
       low => s9_l,
       hi => s9_h); 
    
     s10 : two_sort port map(
       a => l3,
       b => l1,
       low => s10_l,
       hi => s10_h); 
    
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                h4 <= (others => '0');
            elsif i_en2 = '1' then
                h4 <= s7_l;
            end if;
        end if;
    end process;
    
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                m4 <= (others => '0');
            elsif i_en2 = '1' then
                m4 <= s9_l;
            end if;
        end if;
    end process;
    
    process (clk)
    begin
        if Rising_edge(clk) then
            if rst = '1' then
                l4 <= (others => '0');
            elsif i_en2 = '1' then
                l4 <= s10_h;
            end if;
        end if;
    end process;
    
     s11 : two_sort port map(
       a => h4,
       b => m4,
       low => s11_l,
       hi => s11_h); 
    
     s12 : two_sort port map(
       a => s11_l,
       b => l4,
       low => s12_l,
       hi => s12_h); 
    
     s13 : two_sort port map(
       a => s11_h,
       b => s12_h,
       low => o_med,
       hi => s13_h); 
    
end Behavioral;
