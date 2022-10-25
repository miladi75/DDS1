----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2022 01:21:46 PM
-- Design Name: 
-- Module Name: PIPO_shift_register - rtl
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
use ieee.numeric_std.all;

entity PIPO_shift_register is
    Port ( d : in STD_LOGIC_VECTOR (255 downto 0);
           clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           sh : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR (255 downto 0)
           );
end PIPO_shift_register;

architecture rtl of PIPO_shift_register is

begin
    process(clk, reset_n)
    begin
    if (reset_n = '0') then
        q <= (others => '0');
    elsif(clk'event and clk = '1') then
        q <= STD_LOGIC_VECTOR(shift_left(unsigned(d), 1));
    end if;
    end process;

end rtl;
