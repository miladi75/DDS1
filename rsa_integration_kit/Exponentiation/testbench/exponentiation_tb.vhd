library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity exponentiation_tb is
	generic (
		C_block_size : integer := 256
	);
end exponentiation_tb;


architecture expBehave of exponentiation_tb is

	signal message 		: STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
	signal key 			: STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
	signal valid_in 	: STD_LOGIC;
	signal ready_in 	: STD_LOGIC;
	signal ready_out 	: STD_LOGIC;
	signal valid_out 	: STD_LOGIC;
	signal result 		: STD_LOGIC_VECTOR(C_block_size-1 downto 0);
	signal modulus 		: STD_LOGIC_VECTOR(C_block_size-1 downto 0);
	signal clk 			: STD_LOGIC := '0';
	signal restart 		: STD_LOGIC;
	signal reset_n 		: STD_LOGIC;
	signal msgin_last   : STD_LOGIC;
	signal msgout_last  : STD_LOGIC;
	
	constant period : time := 2 ns;
    signal done : boolean := false;
begin
	i_exponentiation : entity work.exponentiation
		port map (
			message      => message  ,
			key          => key      ,
			valid_in     => valid_in ,
			ready_in     => ready_in ,
			ready_out    => ready_out,
			valid_out    => valid_out,
			result       => result   ,
			modulus      => modulus  ,
			clk          => clk      ,
			reset_n      => reset_n  ,
			msgin_last   => msgin_last,
			msgout_last  => msgout_last
		);
		
    clk <= '0' when done else not clk after period / 2;
    reset_n <= '0', '1' after Period;
		
	process is
	   procedure Test(constant test_message : in std_logic_vector(C_block_size-1 downto 0);
	                  constant test_key : in std_logic_vector(C_block_size-1 downto 0);
	                  constant test_modulus : in std_logic_vector(C_block_size-1 downto 0);
	                  constant test_expected : in std_logic_vector(C_block_size-1 downto 0)) is
        begin
           message <= test_message;
	       key <=     test_key;
	       modulus <= test_modulus;
        
           valid_in <= '1';
	       ready_out <= '0';
	   
	       wait until ready_in = '1'; wait for period;
	       valid_in <= '0';
	       ready_out <= '1';
	   
	       wait until valid_out = '1'; wait for period;
	       ready_out <= '0';
	   
	       assert test_expected = result report "FAIL expected result (" & to_hstring(test_expected) & ") /= current result (" & to_hstring(result) & ")" severity error;
        end procedure;
	
	begin
	   -- Initialization
	   wait until reset_n = '1';
	   
	   -- Tests cases
	   Test(x"0a23232323232323232323232323232323232323232323232323232323232323", -- message
	        x"0000000000000000000000000000000000000000000000000000000000010001", -- key
	        x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d", -- modulus
	        x"85ee722363960779206a2b37cc8b64b5fc12a934473fa0204bbaaf714bc90c01");-- expected
	   
	   -- Finalizing testbench
	   report "*******************************";
	   report "ALL TESTS FINISHED SUCCESSFULLY";
	   report "*******************************";
	   done <= true;
	   wait;
	end process;    
end expBehave;
