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
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity demux1xN is
    generic (
		size : integer := 256
	);
    port (
        input : in STD_LOGIC;
        sel : in INTEGER range 0 to size-1;
        output : out STD_LOGIC_VECTOR(0 to size-1)
    );
end demux1xN;

architecture demux1xNBehav of demux1xN is
begin
    process (input)
    begin
        output <= (others => '0');
        output(sel) <= input;
    end process;
end demux1xNBehav;
