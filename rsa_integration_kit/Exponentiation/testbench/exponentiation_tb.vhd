library ieee;
use ieee.std_logic_1164.all;


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

    message <= x"0000000000000000000000000000000000000000000000000000000000000013", x"0000000000000000000000000000000000000000000000000000000000000042" after 5*period; -- 19, 66
    key <=     x"0000000000000000000000000000000000000000000000000000000000000005", x"000000000000000000000000000000000000000000000000000000000000004D" after 5*period; -- 5, 77
    modulus <= x"0000000000000000000000000000000000000000000000000000000000000077"; -- 119
    -- Should be 66(10) / 42(16)

    valid_in <= '0', '1' after 2*period, '0' after 4*period, '1' after 8*period;
    ready_out <= '0', '1' after 2*period;
    
    
    /*i_multiplication : entity work.multiplication
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

    message <= x"0000000000000000000000000000000000000000000000000000000000000013", x"0000000000000000000000000000000000000000000000000000000000000004" after 5*period; -- 19, 4
    key <=     x"0000000000000000000000000000000000000000000000000000000000000013", x"0000000000000000000000000000000000000000000000000000000000000004" after 5*period; -- 19, 4
    modulus <= x"0000000000000000000000000000000000000000000000000000000000000077"; -- 119

    valid_in <= '0', '1' after 2*period, '0' after 4*period, '1' after 8*period;
    ready_out <= '0', '1' after 2*period;
    */
    
end expBehave;
