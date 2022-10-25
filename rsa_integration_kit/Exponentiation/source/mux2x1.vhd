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
  port (
    a       : in  std_logic;
    b       : in  std_logic;
    sel     : in  std_logic;
    y       : out std_logic);
end mux2x1;

architecture rtl of mux2x1 is
begin
  y <= a when sel='0' else b;
end rtl;