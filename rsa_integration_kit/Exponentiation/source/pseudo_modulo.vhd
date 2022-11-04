library ieee;
use ieee.std_logic_1164.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;
use ieee.numeric_std.all;

entity pseudo_modulo is
	generic (
		C_block_size : integer := 256
	);
	port (
		r            : in std_logic_vector(C_block_size - 1 downto 0);
		n            : in std_logic_vector(C_block_size - 1 downto 0);
		result       : out std_logic_vector(C_block_size - 1 downto 0)
	);
end pseudo_modulo;


architecture rtl of pseudo_modulo is
    signal condition : std_logic;
begin	
	process (r, n)
	begin
	   if r >= n then
	       condition <= '1';
	   else
	       condition <= '0';
	   end if;
	end process;
	
	MUX2X1: entity work.mux2x1
    generic map(C_block_size)
    port map(
        a => r,
        b => std_logic_vector(to_unsigned(to_integer(unsigned(r)) - to_integer(unsigned(n)), C_block_size)),
        sel => condition,
        y => result
    );
end rtl;
