library ieee;
use ieee.std_logic_1164.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;
use ieee.numeric_std.all;

entity exponentiation is
	generic (
		C_block_size : integer := 256
	);
	port (
		--input controll
		valid_in	: in STD_LOGIC;
		ready_in	: out STD_LOGIC;

		--input data
		message 	: in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
		key 		: in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );

		--ouput controll
		ready_out	: in STD_LOGIC;
		valid_out	: out STD_LOGIC;

		--output data
		result 		: out STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		--modulus
		modulus 	: in STD_LOGIC_VECTOR(C_block_size-1 downto 0);

		--utility
		clk 		: in STD_LOGIC;
		reset_n 	: in STD_LOGIC
	);
end exponentiation;


architecture expBehave of exponentiation is
    signal counter_enable : std_logic;
    signal muxNto1_out : std_logic;
    signal i : std_logic_vector(integer(ceil(log2(real(C_block_size))))-1 downto 0);
    signal c_in : std_logic_vector(C_block_size-1 downto 0);
    signal c_out : std_logic_vector(C_block_size-1 downto 0);
    signal p_in : std_logic_vector(C_block_size-1 downto 0); 
    signal p_out : std_logic_vector(C_block_size-1 downto 0);
    signal mult_1_done, mult_2_done, mult_done : std_logic;
begin
	--result <= message xor modulus;
	--ready_in <= ready_out;
	--valid_out <= valid_in;
	
	process(reset_n)
	begin
	   if (reset_n = '0') then
	       c_in <= (0 => '1', others => '0');
	       c_out <= (others => '0');
	       p_in <= message;
	       p_out <= (others => '0');
	   end if;
	end process;
	
	process(i)
	   variable tmp_i : integer;
	begin
	   tmp_i := to_integer(unsigned(i));
	   if (tmp_i >= C_block_size) then
	       valid_out <= '1';
	       counter_enable <= '0';
	   end if;
	end process;
	
	process(valid_in)
	begin
	   if (valid_in = '1') then
	       counter_enable <= '1';
	   end if;
	end process;
	
	i_incr: entity work.counter 
	generic map(integer(ceil(log2(real(C_block_size))))) 
	port map(
	   clk,
	   reset_n,
	   counter_enable,
	   i
	);
	
	muxNto1: entity work.muxNx1
	generic map(C_block_size)
	port map(
	   key,
	   to_integer(unsigned(i)),
	   muxNto1_out
	);
	
	reg_c: entity work.register_reset_n
	generic map(C_block_size)
	port map(
	   clk,
	   reset_n,
	   c_in,
	   c_out
	);
	
	reg_p: entity work.register_reset_n
	generic map(C_block_size)
	port map(
	   clk,
	   reset_n,
	   p_in,
	   p_out
	);
	
	mult_c_p: entity work.multiplication
	generic map(C_block_size)
	port map(
	   input_a => c_out,
	   input_b => p_out,
	   enable => muxNto1_out,
       input_n => modulus,
	   out_mul => c_in,
	   done => mult_1_done,
	   clk => clk,
	   reset_n => reset_n
	);
	
	mult_p_p: entity work.multiplication
	generic map(C_block_size)
	port map(
	   input_a => p_out,
	   input_b => p_out,
	   enable => '1',
	   input_n => modulus,
	   out_mul => p_in,
	   done => mult_2_done,
	   clk => clk,
	   reset_n => reset_n
	);
	
	mult_done <= mult_1_done and mult_2_done;
end expBehave;
