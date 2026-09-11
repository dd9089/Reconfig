-- Wrapper entity for producer and consumer 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity handshakeTop is
Port ( 
    i_clk : in std_logic;                     -- clock
    i_rst : in std_logic;                     -- reset 
    
    i_send : in std_logic;                    -- initiate send
    i_data : in std_logic_vector(7 downto 0); -- data in 
    
    o_recv : out std_logic;                   -- received something
    o_data : out std_logic_vector(7 downto 0) -- data out
);
end handshakeTop;

architecture Behavioral of handshakeTop is
   component producer is
   port ( 
       i_clk : in std_logic;                     -- clock
       i_rst : in std_logic;                     -- reset 
       
       i_send : in std_logic;                    -- initiate send
       i_data : in std_logic_vector(7 downto 0); -- data in 
        
       o_req : out std_logic;                    -- request
       i_ack : in std_logic;                     -- acknowledge 
       o_data : out std_logic_vector(7 downto 0) -- data out
    );
    end component;
    
    component consumer is
    port ( 
        i_clk : in std_logic;                     -- clock
        i_rst : in std_logic;                     -- reset 
    
        i_req : in std_logic;                     -- request
        o_ack : out std_logic;                    -- acknowledge 
        i_data : in std_logic_vector(7 downto 0); -- data out
        
        o_recv : out std_logic;                   -- recieved something
        o_data : out std_logic_vector(7 downto 0) -- data out 
    );
    end component;
    
    signal req : std_logic;
    signal ack : std_logic;
    signal internal_data : std_logic_vector(7 downto 0);
begin
    prod : producer port map (
        i_clk => i_clk,
        i_rst => i_rst,
        i_send => i_send,
        i_data => i_data,
        o_req => req,
        i_ack => ack,
        o_data => internal_data
    );
    
    cons : consumer port map (
        i_clk => i_clk,
        i_rst => i_rst,
        i_req => req,
        o_ack => ack,
        i_data => internal_data,  
        o_recv => o_recv,
        o_data => o_data
    );
end Behavioral;
