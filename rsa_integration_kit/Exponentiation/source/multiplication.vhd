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
        c_enable    : in STD_LOGIC;
        input_n     : in STD_LOGIC_VECTOR(C_block_size-1 downto 0);
        out_mul     : out STD_LOGIC_VECTOR(C_block_size-1 downto 0);
        done_mul    : out STD_LOGIC
        );



end multiplication;
    


architecture Behavioral of multiplication is
    signal counter_out : STD_LOGIC_VECTOR(C_block_size-1 downto 0);
    --component counter
    
    --port map(
    --coutner_out => y,
    --y =>coutner_out ,
    
    --);

begin 
    COUNTER : entity work.counter
    port map (
      y => counter_out,
     clk => i_clk,
    reset_n => reset_n,
    cnt_en => c_enable 
    );  
 
        
      
    
end Behavioral;
