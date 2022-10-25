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
        input_a     : in std_logic_vector(C_block_size-1 downto 0);
        input_b     : in std_logic vector(C_block_size-1 downto 0);
        enable_clk  : in std_logic;
        input_n     : in std_logic;
        out_mul     : out std_logic;
        );



end multiplication;


architecture Behavioral of multiplication is

begin


end Behavioral;
