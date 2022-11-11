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
	
	constant period : time := 2 ns;
    signal done : boolean := false;
    
    signal expected : std_logic_vector(C_block_size-1 downto 0);

begin
	i_exponentiation : entity work.exponentiation
		port map (
			message   => message  ,
			key       => key      ,
			valid_in  => valid_in ,
			ready_in  => ready_in ,
			ready_out => ready_out,
			valid_out => valid_out,
			result    => result   ,
			modulus   => modulus  ,
			clk       => clk      ,
			reset_n   => reset_n
		);

    clk <= '0' when done else not clk after period / 2;
    reset_n <= '0', '1' after Period;
    done <= true after 300000 ns;

    message <= x"0a23232323232323232323232323232323232323232323232323232323232323";
    key <=     x"0000000000000000000000000000000000000000000000000000000000010001";
    modulus <= x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d";
	-- Should be 85ee722363960779206a2b37cc8b64b5fc12a934473fa0204bbaaf714bc90c01
	

    valid_in <= '0', '1' after 2*period, '0' after 4*period;--, '1' after 8*period;
    ready_out <= '0', '1' after 2*period;
     
   /*
    i_multiplication : entity work.multiplication
		port map (
			a         => message  ,
			b         => key      ,
			valid_in  => valid_in ,
			ready_in  => ready_in ,
			ready_out => ready_out,
			valid_out => valid_out,
			result    => result   ,
			modulus   => modulus  ,
			clk       => clk      ,
			reset_n   => reset_n
		);

    clk <= '0' when done else not clk after period / 2;
    reset_n <= '0', '1' after Period;
    done <= true after 12 ms;

    message <= x"0a23232323232323232323232323232323232323232323232323232323232323";
    key <=     x"0000000000000000000000000000000000000000000000000000000000010001";
    modulus <= x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d";

    valid_in <= '0', '1' after 2*period, '0' after 4*period;
    ready_out <= '0', '1' after 2*period;
    
    expected <= std_logic_vector((unsigned(message) * unsigned(key)) mod unsigned(modulus));
    */
    
end expBehave;
