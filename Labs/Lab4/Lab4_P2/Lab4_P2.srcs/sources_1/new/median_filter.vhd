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
    signal s13_l : unsigned (7 downto 0) := (others => '0');
    
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
        
        
        
            
end Behavioral;
