library ieee;
use ieee.std_logic_1164.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;
use ieee.numeric_std.all;

entity multiplication is
	generic (
		C_block_size : integer := 256
	);
	port (
		--input controll
		valid_in	: in STD_LOGIC;
		ready_in	: out STD_LOGIC;

		--input data
		a          	: in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );
		b      		: in STD_LOGIC_VECTOR ( C_block_size-1 downto 0 );

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
end multiplication;


architecture multBehave of multiplication is
    type StateType is (RESET, READ_INPUT, RUNNING, WAIT_OUTPUT, STORE_OUTPUT);
    signal state : StateType := RESET;

    signal i : std_logic_vector(integer(ceil(log2(real(C_block_size)))) - 1 downto 0) := (others => '0');
    signal wire_b_i, cnt_en, pipo_reg_en : std_logic := '0';
    signal reset_local : std_logic := '1';
    signal wire_a_out, wire_b_out, wire_modulus_out, wire_a_b_i : std_logic_vector(C_block_size - 1 downto 0);
    signal wire_r_in, wire_r_out, wire_mod1_mod2 : std_logic_vector(C_block_size downto 0);
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
	   input => wire_b_out,
	   sel => to_integer(unsigned(i)),
	   output => wire_b_i
	);
	
	MUX2X1: entity work.mux2x1
	generic map(C_block_size)
	port map(
	   a => (others => '0'),
	   b => wire_a_out,
	   sel => wire_b_i,
	   y => wire_a_b_i
	);
	
	SHIFT_PIPO_REG_r: entity work.PIPO_shift_register
	generic map(C_block_size + 1)
	port map(
	   d => wire_r_in,
	   clk => clk,
	   reset_n => reset_n and reset_local,
	   enable => pipo_reg_en,
	   q => wire_r_out
	);
	
	PSEUDO_MOD1: entity work.pseudo_modulo
	generic map(C_block_size + 1)
	port map(
	   r => std_logic_vector(unsigned(wire_r_out) + unsigned('0' & wire_a_b_i)),
	   n => '0' & wire_modulus_out,
	   result => wire_mod1_mod2
	);
	
	PSEUDO_MOD2: entity work.pseudo_modulo
	generic map(C_block_size + 1)
	port map(
	   r => wire_mod1_mod2,
	   n => '0' & wire_modulus_out,
	   result => wire_r_in
	);
	
	REG_a: entity work.register_reset_n_enable
	generic map(C_block_size)
	port map(
	   clk => clk,
	   reset_n => reset_n,
	   enable => valid_in and ready_in,
	   d => a,
	   q => wire_a_out
	);
	
	REG_b: entity work.register_reset_n_enable
	generic map(C_block_size)
	port map(
	   clk => clk,
	   reset_n => reset_n,
	   enable => valid_in and ready_in,
	   d => b,
	   q => wire_b_out
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
	   d => wire_r_in(C_block_size - 1 downto 0),
	   q => result
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
	           cnt_en <= '0';
	           ready_in <= '0';
	           valid_out <= '0';
	           pipo_reg_en <= '0';
	           state <= READ_INPUT;
	       when READ_INPUT =>
	           reset_local <= '1';
	           ready_in <= '1';
	           if valid_in = '1' and ready_in = '1' then
	               ready_in <= '0';
	               state <= RUNNING;
	           end if;
	       when RUNNING =>
	           pipo_reg_en <= '1';
	           ready_in <= '0';
	           cnt_en <= '1';
	           if tmp_i >= C_block_size - 2 then
	               cnt_en <= '0';
	               pipo_reg_en <= '0';
	               if ready_out = '1' then
	                   valid_out <= '1';
	                   state <= STORE_OUTPUT;
	               else
    	               state <= WAIT_OUTPUT;
    	           end if;
	           end if;
	       when WAIT_OUTPUT =>
	           if ready_out <= '1' then
	               valid_out <= '1';
	               state <= STORE_OUTPUT;
	           end if;
	       when STORE_OUTPUT =>
	           if ready_out = '1' and valid_out = '1' then
	               state <= RESET;
	           end if;
	       when others =>
	           state <= RESET;
	       end case;
	   end if;
	end process;
end multBehave;
