library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package my_type is
        type array_std_logic_vector is array(natural range <>) of std_logic_vector;
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;
use work.my_type.all;

entity muxNx1_array_logic_vector is
    generic (
		C_BLOCK_SIZE : integer := 256;
		NB_CORE : integer := 4
	);
    port (
        input : in array_std_logic_vector(0 to NB_CORE-1)(C_BLOCK_SIZE downto 0);
        sel : in INTEGER range 0 to NB_CORE-1;
        output : out STD_LOGIC_VECTOR(C_BLOCK_SIZE-1 downto 0)
    );
end muxNx1_array_logic_vector;

architecture muxNx1Behav of muxNx1_array_logic_vector is
begin
    output <= input(sel);
end muxNx1Behav;
