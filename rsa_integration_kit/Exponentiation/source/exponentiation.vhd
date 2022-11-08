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
    type StateType is (RESET, READ_INPUT, RUNNING, WAIT_MULT, WAIT_OUTPUT, STORE_OUTPUT);
    signal state : StateType := RESET;

    signal i : std_logic_vector(integer(ceil(log2(real(C_block_size)))) - 1 downto 0) := (others => '0');
    signal wire_key_i_in, cnt_en, valid_in_mul, ready_out_mul, ready_in_cp, valid_out_cp, ready_in_pp, valid_out_pp, init_p_en, init_c_en : std_logic := '0';
    signal wire_key_i_out : std_logic_vector(0 downto 0);
    signal reset_local : std_logic := '1';
    signal wire_p_in, wire_p_out, wire_c_in, wire_c_out, wire_mul_c_out, wire_message_out, wire_key_out, wire_modulus_out, wire_mult_p, wire_mult_c : std_logic_vector(C_block_size - 1 downto 0);
begin
    COUNTER: entity work.counter
	generic map(integer(ceil(log2(real(C_block_size)))))
	port map(
	   clk => clk,
	   reset_n => reset_n and reset_local,
	   cnt_en => cnt_en,
	   y => i
	);
	
	MUXNX1: entity work.muxNx1
	generic map(C_block_size)
	port map(
	   input => key,
	   sel => C_block_size - to_integer(unsigned(i)) - 1,
	   output => wire_key_i_in
	);
	
	REG_p: entity work.register_reset_n
	generic map(C_block_size)
	port map(
	   clk => clk,
	   reset_n => reset_n,
	   d => wire_p_in,
	   q => wire_p_out
	);
	
	REG_c: entity work.register_reset_n
	generic map(C_block_size)
	port map(
	   clk => clk,
	   reset_n => reset_n,
	   d => wire_c_in,
	   q => wire_c_out
	);
	
	MULT_c_p: entity work.multiplication
	generic map (C_block_size)
	port map (
	   valid_in => valid_in_mul,
	   ready_in => ready_in_cp,
	   a => wire_mult_c,
       b => wire_mult_p,
	   ready_out => ready_out_mul,
	   valid_out => valid_out_cp,
	   result => wire_mul_c_out,
	   modulus => modulus,
	   clk => clk,
	   reset_n => reset_n
	);
	
	MULT_p_p: entity work.multiplication
	generic map (C_block_size)
	port map (
	   valid_in => valid_in_mul,
	   ready_in => ready_in_pp,
	   a => wire_mult_p,
       b => wire_mult_p,
	   ready_out => ready_out_mul,
	   valid_out => valid_out_pp,
	   result => wire_p_in,
	   modulus => modulus,
	   clk => clk,
	   reset_n => reset_n
	);
	
	REG_key_i: entity work.register_reset_n
	generic map(1)
	port map(
	   clk => clk,
	   reset_n => reset_n and reset_local,
	   d => (0 => wire_key_i_in),
	   q => wire_key_i_out
	);
	
	MUX2X1: entity work.mux2x1
	generic map(C_block_size)
	port map(
	   a => wire_mult_c,
	   b => wire_mul_c_out,
	   sel => wire_key_i_out(0),
	   y => wire_c_in
	);
	
	REG_message: entity work.register_reset_n_enable
	generic map(C_block_size)
	port map(
	   clk => clk,
	   reset_n => reset_n,
	   enable => valid_in and ready_in,
	   d => message,
	   q => wire_message_out
	);
	
	REG_key: entity work.register_reset_n_enable
	generic map(C_block_size)
	port map(
	   clk => clk,
	   reset_n => reset_n,
	   enable => valid_in and ready_in,
	   d => key,
	   q => wire_key_out
	);
	
	REG_modulus: entity work.register_reset_n_enable
	generic map(C_block_size)
	port map(
	   clk => clk,
	   reset_n => reset_n,
	   enable => valid_in and ready_in,
	   d => modulus,
	   q => wire_modulus_out
	);
	
	REG_result: entity work.register_reset_n
	generic map(C_block_size)
	port map(
	   clk => clk,
	   reset_n => reset_n,
	   d => wire_c_in,
	   q => result
	);
	
	MUX2X1_INIT_P: entity work.mux2x1
	generic map(C_block_size)
	port map(
	   a => wire_p_out,
	   b => wire_message_out,
	   sel => init_p_en,
	   y => wire_mult_p
	);
	
	MUX2X1_INIT_C: entity work.mux2x1
	generic map(C_block_size)
	port map(
	   a => wire_c_out,
	   b => std_logic_vector(to_unsigned(1, C_block_size)),
	   sel => init_c_en,
	   y => wire_mult_c
	);
	
	--
	-- State machine
	--
	process(clk, reset_n)
	   variable tmp_i : integer;
	begin
	   tmp_i := to_integer(unsigned(i));
	   if reset_n = '0' then
	       state <= RESET;
	   elsif rising_edge(clk) then
	       case state is
	       when RESET =>
	           reset_local <= '0';
	           ready_in <= '0';
	           valid_out <= '0';
	           cnt_en <= '0';
	           valid_in_mul <= '0';
	           ready_out_mul <= '0';
	           state <= READ_INPUT;
	       when READ_INPUT =>
	           reset_local <= '1';
	           ready_in <= '1';
	           init_p_en <= '1';
	           init_c_en <= '1';
	           if valid_in = '1' and ready_in = '1' then
	               ready_in <= '0';
	               state <= RUNNING;
	           end if;
	       when RUNNING =>
	           ready_out_mul <= '0';
	           ready_in <= '0';
	           cnt_en <= '0';
	           valid_in_mul <= '1';
	           if ready_in_cp = '1' and ready_in_pp = '1' then
	               state <= WAIT_MULT;
	           end if;
	       when WAIT_MULT =>
	           valid_in_mul <= '0';
	           ready_out_mul <= '1';
	           if valid_out_cp = '1' and valid_out_pp = '1' then
	               init_p_en <= '0';
	               init_c_en <= '0';
	               if tmp_i >= C_block_size - 1 then
	                   if ready_out = '1' then
	                       valid_out <= '1';
	                       state <= STORE_OUTPUT;
	                   else
	                       state <= WAIT_OUTPUT;
	                   end if;
	               else
	                   cnt_en <= '1';
	                   state <= RUNNING;
	               end if;
	           end if;
	       when WAIT_OUTPUT =>
	           ready_out_mul <= '0';
	           if ready_out = '1' then
	               valid_out <= '1';
	               state <= STORE_OUTPUT;
	           end if;
	       when STORE_OUTPUT =>
	           ready_out_mul <= '0';
	           if ready_out = '1' and valid_out = '1' then
	               state <= RESET;
	           end if;
	       when others =>
	           state <= RESET;
	       end case;
	   end if;
	end process;
end expBehave;
