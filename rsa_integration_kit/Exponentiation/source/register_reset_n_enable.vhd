library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_reset_n_enable is
  generic (
    REGISTER_WIDTH : natural := 8);
  port (
    clk     : in  std_logic;
    reset_n : in  std_logic;
    enable  : in std_logic;
    d       : in  std_logic_vector(REGISTER_WIDTH-1 downto 0);
    q       : out std_logic_vector(REGISTER_WIDTH-1 downto 0));
end register_reset_n_enable;

architecture rtl of register_reset_n_enable is
begin
  process(clk, reset_n)
  begin
    if(reset_n = '0') then
      q <= (others => '0');
    elsif (clk'event and clk='1') then
        if enable = '1' then
            q <= d;
        end if;
    end if;
  end process;
end rtl;