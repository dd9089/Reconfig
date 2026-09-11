-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Mon Aug 31 18:06:23 2026
-- Host        : Pacheco running 64-bit major release  (build 9200)
-- Command     : write_vhdl -mode funcsim -nolib -force -file
--               C:/Users/diego/Documents/Reconfig/Tutorial1/Tutorial1.sim/sim_1/synth/func/xsim/XilinxIntro_tb_func_synth.vhd
-- Design      : XilinxIntro
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity XilinxIntro is
  port (
    i_a : in STD_LOGIC;
    i_b : in STD_LOGIC;
    i_s0 : in STD_LOGIC;
    i_s1 : in STD_LOGIC;
    o_result : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of XilinxIntro : entity is true;
end XilinxIntro;

architecture STRUCTURE of XilinxIntro is
  signal i_a_IBUF : STD_LOGIC;
  signal i_b_IBUF : STD_LOGIC;
  signal i_s0_IBUF : STD_LOGIC;
  signal i_s1_IBUF : STD_LOGIC;
  signal o_result_OBUF : STD_LOGIC;
begin
i_a_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => i_a,
      O => i_a_IBUF
    );
i_b_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => i_b,
      O => i_b_IBUF
    );
i_s0_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => i_s0,
      O => i_s0_IBUF
    );
i_s1_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => i_s1,
      O => i_s1_IBUF
    );
o_result_OBUF_inst: unisim.vcomponents.OBUF
     port map (
      I => o_result_OBUF,
      O => o_result
    );
o_result_OBUF_inst_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6E85"
    )
        port map (
      I0 => i_a_IBUF,
      I1 => i_b_IBUF,
      I2 => i_s0_IBUF,
      I3 => i_s1_IBUF,
      O => o_result_OBUF
    );
end STRUCTURE;
