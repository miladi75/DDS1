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
        i_clk           : in STD_LOGIC;
        reset_n         : in STD_LOGIC;
        cnt_en          : in STD_LOGIC;
        
        a_mul           : in STD_LOGIC_VECTOR(C_block_size-1 downto 0);
        b_mul           : in STD_LOGIC_VECTOR(C_block_size-1 downto 0);
        
        n_input         : in STD_LOGIC_VECTOR(C_block_size-1 downto 0);
        
        out_mul         : out STD_LOGIC_VECTOR(C_block_size-1 downto 0);
        done_counter    : out STD_LOGIC
        );


end multiplication;
    


architecture rtl of multiplication is
    signal counter_i : std_logic_vector(C_block_size-1 downto 0);
    signal counter_out : STD_LOGIC_VECTOR(C_block_size-1 downto 0);
    signal counter_done : std_logic;
    
    signal mux_sel : std_logic;
    signal in_mux_1 : std_logic_vector(C_block_size-1 downto 0);
    signal out_mux_1 : std_logic_vector(C_block_size-1 downto 0);
    
    signal mul_exponent : std_logic;

begin
    process(reset_n)
    begin
        if reset_n = '0' then
            counter_out <= (others => '0');
            out_mul <= (others => '0');
            done_counter <= '0';
        end if;
    end process;
    

COUNTER : entity work.counter
    port map (
        y => counter_out,
        clk => i_clk,
        reset_n => reset_n,
        cnt_en => cnt_en );  

process(counter_i)


end process;

if counter_out = x"FF" then
    counter_done <= ('1' others => '0');
    

process(in_mux_1)
begin
    if counter_out = '0' then
        mux_sel <= '0';
    elsif counter_out <= '1' then
        mux_sel <= '1';

    end if;
end process;

 

process()
        
        
      
    
end rtl;
