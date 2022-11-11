library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
	        
	   Test(x"6DBD39F7578F288D45F77C72CD42C339382C8FABDE8F9A247680D28812D7C247", -- message
	        x"0000000000000000000000000000000000000000000000000000000000010001", -- key
	        x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d", -- modulus
	        x"299bd501d86465e68e6d7ccff39d063d875f0ed3c24cab019f8257dbb64ae227");-- expected 
	        
	   Test(x"6E668092EFB9E176993193E1D66A68019580A8873708266A939196BCD7ACFDE6", -- message
	        x"0000000000000000000000000000000000000000000000000000000064501111", -- key
	        x"A9A67DFF3A7B469E7A342406AF1DF30972D54E555702DF806DCB6D00A7D311CD", -- modulus
	        x"37D53C5EDED3D8481F62ABAEAE1239F8CF6E7122CBB4484381EF6E36113965DE");-- expected
	        
	   Test(x"5635ab8cfd7390f2a13bd77238e4dfd2089e0216021806db3b4e8bee2b29c735", -- message
	        x"0cea1651ef44be1f1f1476b7539bed10d73e3aac782bd9999a1e5a790932bfe9", -- key
	        x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d", -- modulus
	        x"2323232323232323232323232323232323232323232323232323232323232323");-- expected
	        
	   Test(x"85ee722363960779206a2b37cc8b64b5fc12a934473fa0204bbaaf714bc90c01", -- message
	        x"0cea1651ef44be1f1f1476b7539bed10d73e3aac782bd9999a1e5a790932bfe9", -- key
	        x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d", -- modulus
	        x"0a23232323232323232323232323232323232323232323232323232323232323");-- expected
	   
	   Test(x"81dc2a1f43b2a9f27e13c73493204d823eed68ddabe9b79bfbfaa11bbacc35fe", -- message
	        x"0cea1651ef44be1f1f1476b7539bed10d73e3aac782bd9999a1e5a790932bfe9", -- key
	        x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d", -- modulus
	        x"20202020207478742e6e695f317470203a2020202020202020202020454d414e");-- expected
	        
	   Test(x"1c6a9b8ec4485bd5a460e171a1f6723680599cfb58315b9c8ce213b0a81ef034", -- message
	        x"0cea1651ef44be1f1f1476b7539bed10d73e3aac782bd9999a1e5a790932bfe9", -- key
	        x"99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d", -- modulus
	        x"0a23202020202020202020202020202020202020202020202020202020202020");-- expected
	        
	   -- Finalizing testbench
	   done <= true;
	   wait;
	end process;    
end expBehave;
