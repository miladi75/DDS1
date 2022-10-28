-- *****************************************************************************
-- Name:     mux2x1.vhd   
-- Created:  20.02.16 @ NTNU   
-- Author:   Jonas Eggen
-- Purpose:  A two input mux with an input bit width of 1.
-- *****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2x1 is
  generic (
    C_block_size : integer := 256
  );
  port (
    a       : in  std_logic_vector(C_block_size - 1 downto 0);
    b       : in  std_logic_vector(C_block_size - 1 downto 0);
    sel     : in  std_logic;
    y       : out std_logic_vector(C_block_size - 1 downto 0));
end mux2x1;

architecture rtl of mux2x1 is
begin
  y <= a when sel='0' else b;
end rtl;