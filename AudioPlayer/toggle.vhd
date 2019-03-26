library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity toggle is
port(	clk: in std_logic;
		rst: in std_logic;
		input: in std_logic;
		output: out std_logic);
end toggle;

architecture Behavioral of toggle is
	type state is(ZERO_1, ZERO_2, WAIT0, ONE_1, ONE_2, WAIT1);
	signal c_state, n_state: state;
	signal reg, n_reg: std_logic;
	signal counter, n_counter: std_logic_vector(18 downto 0);
begin

	process(c_state, counter, reg, input) is
	begin
		n_state <= c_state;	
		n_counter <= counter + 1;
		n_reg <= reg;	
		
		case c_state is
		when ZERO_2 =>		
			if(input='1') then
				n_counter <= (others => '0');
				n_state <= WAIT0;
			end if;
		when WAIT0 =>		
			if(conv_integer(counter)=500000) then
				if(input='1') then
					n_state <= ONE_1;
				else
					n_state <= ZERO_2;
				end if;
			end if;
		when ONE_1=>
			n_reg <= '1';
			if(input='0') then
				n_state <= ONE_2;
			end if;
		when ONE_2 =>		
			if(input='1') then
				n_counter <= (others => '0');
				n_state <= WAIT1;
			end if;
		when WAIT1 =>
			if(conv_integer(counter)=500000) then
				if(input='1') then
					n_state <= ZERO_1;
				else
					n_state <= ONE_2;
				end if;
			end if;
		when ZERO_1 =>
			n_reg <= '0';
			if(input='0') then
				n_state <= ZERO_2;
			end if;
		when others => null;
		end case;
	end process;
	
	output <= reg;

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				c_state <= ZERO_2;
				reg <= '1';
				counter <= (others => '0');
			else
				c_state <= n_state;
				reg <= n_reg;
				counter <= n_counter;
			end if;
		end if;
	end process;
	
end Behavioral;

