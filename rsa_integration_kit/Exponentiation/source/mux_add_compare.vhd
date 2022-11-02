


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity mux_add_compare is
    generic (
		C_block_size : integer := 256
	);

  port(n, r, input_0, input_1 : in std_logic_vector(C_block_size-1 downto 0);
      out_mux : out std_logic_vector(C_block_size-1 downto 0)
  );

end mux_add_compare;

architecture rtl of mux_add_compare is
    
    signal mux_sel : std_logic;
begin

process(n, r) is
begin
    if (r >= n) then
        out_mux <= r;
    else
        out_mux <= r - n; 
    end if;
    
end process;

end rtl;


