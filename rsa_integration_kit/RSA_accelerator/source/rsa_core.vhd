--------------------------------------------------------------------------------
-- Author       : Oystein Gjermundnes
-- Organization : Norwegian University of Science and Technology (NTNU)
--                Department of Electronic Systems
--                https://www.ntnu.edu/ies
-- Course       : TFE4141 Design of digital systems 1 (DDS1)
-- Year         : 2018-2019
-- Project      : RSA accelerator
-- License      : This is free and unencumbered software released into the
--                public domain (UNLICENSE)
--------------------------------------------------------------------------------
-- Purpose:
--   RSA encryption core template. This core currently computes
--   C = M xor key_n
--
--   Replace/change this module so that it implements the function
--   C = M**key_e mod key_n.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_type.all;

entity rsa_core is
	generic (
		-- Users to add parameters here
		C_BLOCK_SIZE          : integer := 256;
		NB_CORE               : integer := 1
	);
	port (
		-----------------------------------------------------------------------------
		-- Clocks and reset
		-----------------------------------------------------------------------------
		clk                    :  in std_logic;
		reset_n                :  in std_logic;

		-----------------------------------------------------------------------------
		-- Slave msgin interface
		-----------------------------------------------------------------------------
		-- Message that will be sent out is valid
		msgin_valid             : in std_logic;
		-- Slave ready to accept a new message
		msgin_ready             : out std_logic;
		-- Message that will be sent out of the rsa_msgin module
		msgin_data              :  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		-- Indicates boundary of last packet
		msgin_last              :  in std_logic;

		-----------------------------------------------------------------------------
		-- Master msgout interface
		-----------------------------------------------------------------------------
		-- Message that will be sent out is valid
		msgout_valid            : out std_logic;
		-- Slave ready to accept a new message
		msgout_ready            :  in std_logic;
		-- Message that will be sent out of the rsa_msgin module
		msgout_data             : out std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		-- Indicates boundary of last packet
		msgout_last             : out std_logic;

		-----------------------------------------------------------------------------
		-- Interface to the register block
		-----------------------------------------------------------------------------
		key_e_d                 :  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		key_n                   :  in std_logic_vector(C_BLOCK_SIZE-1 downto 0);
		rsa_status              : out std_logic_vector(31 downto 0)

	);
end rsa_core;

architecture rtl of rsa_core is
    type StateType is (RESET, WAIT_NEW_TASK, ALLOCATE, FREE);
    signal state : StateType := RESET;
    signal msgout_data_array : array_std_logic_vector(0 to NB_CORE-1)(C_BLOCK_SIZE-1 downto 0);
    signal msgout_last_array : std_logic_vector(0 to NB_CORE-1);
    signal msgin_valid_array : std_logic_vector(0 to NB_CORE-1);
    signal msgin_ready_array : std_logic_vector(0 to NB_CORE-1);
    signal msgout_valid_array : std_logic_vector(0 to NB_CORE-1);
    signal msgout_ready_array : std_logic_vector(0 to NB_CORE-1);
    signal pointer_out, pointer_in : integer := 0;
begin    
    MUXNTO1_msgout_last : entity work.muxNx1
    generic map(NB_CORE)
    port map(
        input => msgout_last_array,
        sel => pointer_out,
        output => msgout_last
    );
    
    MUXNTO1_msgout_data : entity work.muxNx1_array_logic_vector
    generic map(C_BLOCK_SIZE, NB_CORE)
    port map(
        input => msgout_data_array,
        sel => pointer_out,
        output => msgout_data
    );

    GEN_EXP:
    for i in 0 to NB_CORE - 1 generate
        EXP_X: entity work.exponentiation
        generic map(C_BLOCK_SIZE)
        port map(
            message   => msgin_data  ,
			key       => key_e_d     ,
			valid_in  => msgin_valid_array(i),
			ready_in  => msgin_ready_array(i),
			ready_out => msgout_ready_array(i),
			valid_out => msgout_valid_array(i),
			result    => msgout_data_array(i),
			modulus   => key_n,
			clk       => clk,
			reset_n   => reset_n,
			msgin_last => msgin_last,
			msgout_last => msgout_last_array(i)
        );
    end generate;
    
	rsa_status   <= (others => '0');
	
	--
	-- State machine
	--
	process (clk, reset_n)
	begin
	   if reset_n = '0' then
	       state <= RESET;
	   elsif rising_edge(clk) then
	       case state is
	       when RESET =>
	           state <= WAIT_NEW_TASK;
           when WAIT_NEW_TASK =>               
               
           when ALLOCATE => 
               
           when FREE => 
	       end case;
	   end if;
	end process;
end rtl;
