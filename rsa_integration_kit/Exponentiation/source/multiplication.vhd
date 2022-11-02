----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/25/2022 03:04:36 PM
-- Design Name: 
-- Module Name: multiplication - Behavioral
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

-- A comment line

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplication is
    generic(
        C_block_size : integer := 256
    );
    
    port(
        i_clk       : in STD_LOGIC;
        reset_n     : in STD_LOGIC;
        mul_a       : in STD_LOGIC_VECTOR(C_block_size-1 downto 0);
        
        mul_b       : in STD_LOGIC_VECTOR(C_block_size-1 downto 0);
        cnt_en      : in STD_LOGIC;
        input_n     : in STD_LOGIC_VECTOR(C_block_size-1 downto 0);
        out_mul     : out STD_LOGIC_VECTOR(C_block_size-1 downto 0);
        done_mul    : out STD_LOGIC
        );


end multiplication;
    


architecture rtl of multiplication is
    signal counter_in : std_logic_vector(C_block_size-1 downto 0);
    signal counter_out : STD_LOGIC_VECTOR(C_block_size-1 downto 0);
    
    signal loop_done : std_logic;
    signal k : std_logic_vector(integer(ceil(unsigened())-1 downto 0);
    signal mux_sel : std_logic_vector(1 downto 0);
    signal out_mux_1 : std_logic_vector(C_block_size-1 downto 0);

    
    signal mul_exponent : std_logic;

process(reset_n)
begin
    if reset_n = '0' then
        mul_exponent <= '0';
        out_mul <= (others => '0');
        done_mul <= '0';
    elsif rising_edge(i_clk) then
        if cnt_en = '1' then
            mul_exponent <= mul_a(C_block_size-1);
            out_mul <= mul_a * mul_b;
            done_mul <= '1';
        end if;
    end if;
end process;

process(mux_sel)
begin
    if counter_out = '0' then
        mux_sel <= '0';
    elsif counter_out <= '1' then
        mux_sel <= '1';

    end if;
end process;

 
COUNTER : entity work.counter
    port map (
        y => counter_out,
        clk => i_clk,
        reset_n => reset_n,
        cnt_en => cnt_en );  
process()
        
        
      
    
end rtl;
