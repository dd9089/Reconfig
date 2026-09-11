-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Fri Sep 11 14:30:51 2026
-- Host        : DESKTOP-RDVBQR0 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -mode funcsim -nolib -force -file
--               C:/Users/DIEGO/Documents/Reconfig/Tutorials/Tutorial2/Tutorial2.sim/sim_1/synth/func/xsim/handshake_tb_func_synth.vhd
-- Design      : handshakeTop
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7k70tfbv676-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity consumer is
  port (
    Q : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \o_data_reg[7]_0\ : out STD_LOGIC_VECTOR ( 7 downto 0 );
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    CLK : in STD_LOGIC;
    \o_data_reg[7]_1\ : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \FSM_onehot_current_state_reg[0]_0\ : in STD_LOGIC_VECTOR ( 1 downto 0 )
  );
end consumer;

architecture STRUCTURE of consumer is
  signal \FSM_onehot_current_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_current_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_current_state[2]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_current_state_reg_n_0_[1]\ : STD_LOGIC;
  signal \^q\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_onehot_current_state[1]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \FSM_onehot_current_state[2]_i_1\ : label is "soft_lutpair0";
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_onehot_current_state_reg[0]\ : label is "idle:001,send_ack:010,read_data:100";
  attribute FSM_ENCODED_STATES of \FSM_onehot_current_state_reg[1]\ : label is "idle:001,send_ack:010,read_data:100";
  attribute FSM_ENCODED_STATES of \FSM_onehot_current_state_reg[2]\ : label is "idle:001,send_ack:010,read_data:100";
begin
  Q(1 downto 0) <= \^q\(1 downto 0);
\FSM_onehot_current_state[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FEAA"
    )
        port map (
      I0 => \^q\(1),
      I1 => \FSM_onehot_current_state_reg[0]_0\(0),
      I2 => \FSM_onehot_current_state_reg[0]_0\(1),
      I3 => \^q\(0),
      O => \FSM_onehot_current_state[0]_i_1_n_0\
    );
\FSM_onehot_current_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0302"
    )
        port map (
      I0 => \^q\(0),
      I1 => \FSM_onehot_current_state_reg[0]_0\(0),
      I2 => \FSM_onehot_current_state_reg[0]_0\(1),
      I3 => \FSM_onehot_current_state_reg_n_0_[1]\,
      O => \FSM_onehot_current_state[1]_i_1_n_0\
    );
\FSM_onehot_current_state[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A8"
    )
        port map (
      I0 => \FSM_onehot_current_state_reg_n_0_[1]\,
      I1 => \FSM_onehot_current_state_reg[0]_0\(1),
      I2 => \FSM_onehot_current_state_reg[0]_0\(0),
      O => \FSM_onehot_current_state[2]_i_1_n_0\
    );
\FSM_onehot_current_state_reg[0]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => CLK,
      CE => '1',
      D => \FSM_onehot_current_state[0]_i_1_n_0\,
      Q => \^q\(0),
      S => SR(0)
    );
\FSM_onehot_current_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => '1',
      D => \FSM_onehot_current_state[1]_i_1_n_0\,
      Q => \FSM_onehot_current_state_reg_n_0_[1]\,
      R => SR(0)
    );
\FSM_onehot_current_state_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => '1',
      D => \FSM_onehot_current_state[2]_i_1_n_0\,
      Q => \^q\(1),
      R => SR(0)
    );
\o_data_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => \^q\(1),
      D => \o_data_reg[7]_1\(0),
      Q => \o_data_reg[7]_0\(0),
      R => SR(0)
    );
\o_data_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => \^q\(1),
      D => \o_data_reg[7]_1\(1),
      Q => \o_data_reg[7]_0\(1),
      R => SR(0)
    );
\o_data_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => \^q\(1),
      D => \o_data_reg[7]_1\(2),
      Q => \o_data_reg[7]_0\(2),
      R => SR(0)
    );
\o_data_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => \^q\(1),
      D => \o_data_reg[7]_1\(3),
      Q => \o_data_reg[7]_0\(3),
      R => SR(0)
    );
\o_data_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => \^q\(1),
      D => \o_data_reg[7]_1\(4),
      Q => \o_data_reg[7]_0\(4),
      R => SR(0)
    );
\o_data_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => \^q\(1),
      D => \o_data_reg[7]_1\(5),
      Q => \o_data_reg[7]_0\(5),
      R => SR(0)
    );
\o_data_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => \^q\(1),
      D => \o_data_reg[7]_1\(6),
      Q => \o_data_reg[7]_0\(6),
      R => SR(0)
    );
\o_data_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => \^q\(1),
      D => \o_data_reg[7]_1\(7),
      Q => \o_data_reg[7]_0\(7),
      R => SR(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity producer is
  port (
    Q : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \o_data_reg[7]_0\ : out STD_LOGIC_VECTOR ( 7 downto 0 );
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    CLK : in STD_LOGIC;
    D : in STD_LOGIC_VECTOR ( 7 downto 0 );
    i_send_IBUF : in STD_LOGIC;
    \FSM_onehot_state_reg[0]_0\ : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end producer;

architecture STRUCTURE of producer is
  signal \FSM_onehot_state[0]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state[1]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state[2]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state[3]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_state_reg_n_0_[1]\ : STD_LOGIC;
  signal \^q\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s_d_en : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_onehot_state[1]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \FSM_onehot_state[2]_i_1\ : label is "soft_lutpair1";
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[0]\ : label is "ack_wait:0010,send_data:0100,hold_data:1000,idle:0001";
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[1]\ : label is "ack_wait:0010,send_data:0100,hold_data:1000,idle:0001";
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[2]\ : label is "ack_wait:0010,send_data:0100,hold_data:1000,idle:0001";
  attribute FSM_ENCODED_STATES of \FSM_onehot_state_reg[3]\ : label is "ack_wait:0010,send_data:0100,hold_data:1000,idle:0001";
begin
  Q(1 downto 0) <= \^q\(1 downto 0);
\FSM_onehot_state[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F444"
    )
        port map (
      I0 => i_send_IBUF,
      I1 => \^q\(0),
      I2 => \FSM_onehot_state_reg[0]_0\(0),
      I3 => \^q\(1),
      O => \FSM_onehot_state[0]_i_1_n_0\
    );
\FSM_onehot_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F888"
    )
        port map (
      I0 => i_send_IBUF,
      I1 => \^q\(0),
      I2 => \FSM_onehot_state_reg[0]_0\(0),
      I3 => \FSM_onehot_state_reg_n_0_[1]\,
      O => \FSM_onehot_state[1]_i_1_n_0\
    );
\FSM_onehot_state[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \FSM_onehot_state_reg_n_0_[1]\,
      I1 => \FSM_onehot_state_reg[0]_0\(0),
      O => \FSM_onehot_state[2]_i_1_n_0\
    );
\FSM_onehot_state[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BA"
    )
        port map (
      I0 => s_d_en,
      I1 => \FSM_onehot_state_reg[0]_0\(0),
      I2 => \^q\(1),
      O => \FSM_onehot_state[3]_i_1_n_0\
    );
\FSM_onehot_state_reg[0]\: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => CLK,
      CE => '1',
      D => \FSM_onehot_state[0]_i_1_n_0\,
      Q => \^q\(0),
      S => SR(0)
    );
\FSM_onehot_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => '1',
      D => \FSM_onehot_state[1]_i_1_n_0\,
      Q => \FSM_onehot_state_reg_n_0_[1]\,
      R => SR(0)
    );
\FSM_onehot_state_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => '1',
      D => \FSM_onehot_state[2]_i_1_n_0\,
      Q => s_d_en,
      R => SR(0)
    );
\FSM_onehot_state_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => '1',
      D => \FSM_onehot_state[3]_i_1_n_0\,
      Q => \^q\(1),
      R => SR(0)
    );
\o_data_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => s_d_en,
      D => D(0),
      Q => \o_data_reg[7]_0\(0),
      R => SR(0)
    );
\o_data_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => s_d_en,
      D => D(1),
      Q => \o_data_reg[7]_0\(1),
      R => SR(0)
    );
\o_data_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => s_d_en,
      D => D(2),
      Q => \o_data_reg[7]_0\(2),
      R => SR(0)
    );
\o_data_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => s_d_en,
      D => D(3),
      Q => \o_data_reg[7]_0\(3),
      R => SR(0)
    );
\o_data_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => s_d_en,
      D => D(4),
      Q => \o_data_reg[7]_0\(4),
      R => SR(0)
    );
\o_data_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => s_d_en,
      D => D(5),
      Q => \o_data_reg[7]_0\(5),
      R => SR(0)
    );
\o_data_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => s_d_en,
      D => D(6),
      Q => \o_data_reg[7]_0\(6),
      R => SR(0)
    );
\o_data_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => s_d_en,
      D => D(7),
      Q => \o_data_reg[7]_0\(7),
      R => SR(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity handshakeTop is
  port (
    i_clk : in STD_LOGIC;
    i_rst : in STD_LOGIC;
    i_send : in STD_LOGIC;
    i_data : in STD_LOGIC_VECTOR ( 7 downto 0 );
    o_recv : out STD_LOGIC;
    o_data : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of handshakeTop : entity is true;
end handshakeTop;

architecture STRUCTURE of handshakeTop is
  signal ack : STD_LOGIC;
  signal i_clk_IBUF : STD_LOGIC;
  signal i_clk_IBUF_BUFG : STD_LOGIC;
  signal i_data_IBUF : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal i_rst_IBUF : STD_LOGIC;
  signal i_send_IBUF : STD_LOGIC;
  signal o_data_OBUF : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal o_recv_OBUF : STD_LOGIC;
  signal prod_n_0 : STD_LOGIC;
  signal prod_n_1 : STD_LOGIC;
  signal prod_n_2 : STD_LOGIC;
  signal prod_n_3 : STD_LOGIC;
  signal prod_n_4 : STD_LOGIC;
  signal prod_n_5 : STD_LOGIC;
  signal prod_n_6 : STD_LOGIC;
  signal prod_n_7 : STD_LOGIC;
  signal prod_n_8 : STD_LOGIC;
  signal prod_n_9 : STD_LOGIC;
begin
cons: entity work.consumer
     port map (
      CLK => i_clk_IBUF_BUFG,
      \FSM_onehot_current_state_reg[0]_0\(1) => prod_n_0,
      \FSM_onehot_current_state_reg[0]_0\(0) => prod_n_1,
      Q(1) => o_recv_OBUF,
      Q(0) => ack,
      SR(0) => i_rst_IBUF,
      \o_data_reg[7]_0\(7 downto 0) => o_data_OBUF(7 downto 0),
      \o_data_reg[7]_1\(7) => prod_n_2,
      \o_data_reg[7]_1\(6) => prod_n_3,
      \o_data_reg[7]_1\(5) => prod_n_4,
      \o_data_reg[7]_1\(4) => prod_n_5,
      \o_data_reg[7]_1\(3) => prod_n_6,
      \o_data_reg[7]_1\(2) => prod_n_7,
      \o_data_reg[7]_1\(1) => prod_n_8,
      \o_data_reg[7]_1\(0) => prod_n_9
    );
i_clk_IBUF_BUFG_inst: unisim.vcomponents.BUFG
     port map (
      I => i_clk_IBUF,
      O => i_clk_IBUF_BUFG
    );
i_clk_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => i_clk,
      O => i_clk_IBUF
    );
\i_data_IBUF[0]_inst\: unisim.vcomponents.IBUF
     port map (
      I => i_data(0),
      O => i_data_IBUF(0)
    );
\i_data_IBUF[1]_inst\: unisim.vcomponents.IBUF
     port map (
      I => i_data(1),
      O => i_data_IBUF(1)
    );
\i_data_IBUF[2]_inst\: unisim.vcomponents.IBUF
     port map (
      I => i_data(2),
      O => i_data_IBUF(2)
    );
\i_data_IBUF[3]_inst\: unisim.vcomponents.IBUF
     port map (
      I => i_data(3),
      O => i_data_IBUF(3)
    );
\i_data_IBUF[4]_inst\: unisim.vcomponents.IBUF
     port map (
      I => i_data(4),
      O => i_data_IBUF(4)
    );
\i_data_IBUF[5]_inst\: unisim.vcomponents.IBUF
     port map (
      I => i_data(5),
      O => i_data_IBUF(5)
    );
\i_data_IBUF[6]_inst\: unisim.vcomponents.IBUF
     port map (
      I => i_data(6),
      O => i_data_IBUF(6)
    );
\i_data_IBUF[7]_inst\: unisim.vcomponents.IBUF
     port map (
      I => i_data(7),
      O => i_data_IBUF(7)
    );
i_rst_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => i_rst,
      O => i_rst_IBUF
    );
i_send_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => i_send,
      O => i_send_IBUF
    );
\o_data_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => o_data_OBUF(0),
      O => o_data(0)
    );
\o_data_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => o_data_OBUF(1),
      O => o_data(1)
    );
\o_data_OBUF[2]_inst\: unisim.vcomponents.OBUF
     port map (
      I => o_data_OBUF(2),
      O => o_data(2)
    );
\o_data_OBUF[3]_inst\: unisim.vcomponents.OBUF
     port map (
      I => o_data_OBUF(3),
      O => o_data(3)
    );
\o_data_OBUF[4]_inst\: unisim.vcomponents.OBUF
     port map (
      I => o_data_OBUF(4),
      O => o_data(4)
    );
\o_data_OBUF[5]_inst\: unisim.vcomponents.OBUF
     port map (
      I => o_data_OBUF(5),
      O => o_data(5)
    );
\o_data_OBUF[6]_inst\: unisim.vcomponents.OBUF
     port map (
      I => o_data_OBUF(6),
      O => o_data(6)
    );
\o_data_OBUF[7]_inst\: unisim.vcomponents.OBUF
     port map (
      I => o_data_OBUF(7),
      O => o_data(7)
    );
o_recv_OBUF_inst: unisim.vcomponents.OBUF
     port map (
      I => o_recv_OBUF,
      O => o_recv
    );
prod: entity work.producer
     port map (
      CLK => i_clk_IBUF_BUFG,
      D(7 downto 0) => i_data_IBUF(7 downto 0),
      \FSM_onehot_state_reg[0]_0\(0) => ack,
      Q(1) => prod_n_0,
      Q(0) => prod_n_1,
      SR(0) => i_rst_IBUF,
      i_send_IBUF => i_send_IBUF,
      \o_data_reg[7]_0\(7) => prod_n_2,
      \o_data_reg[7]_0\(6) => prod_n_3,
      \o_data_reg[7]_0\(5) => prod_n_4,
      \o_data_reg[7]_0\(4) => prod_n_5,
      \o_data_reg[7]_0\(3) => prod_n_6,
      \o_data_reg[7]_0\(2) => prod_n_7,
      \o_data_reg[7]_0\(1) => prod_n_8,
      \o_data_reg[7]_0\(0) => prod_n_9
    );
end STRUCTURE;
