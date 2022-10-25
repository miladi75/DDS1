----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2022 15:20:53
-- Design Name: 
-- Module Name: muxNx1 - muxNx1Behav
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity muxNx1 is
    generic (
		size : integer := 256
	);
    port (
        input : in STD_LOGIC_VECTOR(0 to size-1);
        sel : in INTEGER range 0 to size-1;
        output : out STD_LOGIC
    );
end muxNx1;

architecture muxNx1Behav of muxNx1 is
begin
    output <= input(sel);
end muxNx1Behav;
