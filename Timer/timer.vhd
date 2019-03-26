library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity timer is
generic(WIDTH: positive := 8);
port(	clk: in std_logic;
		rst: in std_logic;
		tick: in std_logic;
		wr: in std_logic;
		rd: in std_logic;
		int: out std_logic;
		input: in std_logic_vector(WIDTH-1 downto 0);
		output: out std_logic_vector(WIDTH-1 downto 0));
end timer;

architecture Behavioral of timer is
	type state is(STOP, COUNT, INTERRUPT);
	signal c_state, n_state: state;
	signal counter, n_counter: std_logic_vector(WIDTH-1 downto 0);
	signal reg, n_reg: std_logic;
begin

	process(c_state, counter, reg, wr, rd, input, tick) is
	begin
		output <= counter;
		n_counter <= counter;
		n_state <= c_state;
		n_reg <= '0';
	
		case c_state is
		when STOP =>
			if(wr='1') then
				n_counter <= input;
				n_state <= COUNT;
			end if;
		when COUNT =>
			if(wr='1') then
				n_counter <= input;
			elsif(conv_integer(counter)=0) then
				n_state <= INTERRUPT;
			elsif(tick='1') then			
				n_counter <= counter - 1;	
			end if;
		when INTERRUPT =>
			n_reg <= '1';
			if(rd='1') then
				n_state <= STOP;
			end if;
		when others => null;
		end case;
	end process;
	
	int <= reg;

	process(clk) is
	begin
		if(falling_edge(clk)) then
			if(rst='1') then
				c_state <= STOP;
				counter <= (others => '0');
				reg <= '0';
			else
				c_state <= n_state;
				counter <= n_counter;
				reg <= n_reg;
			end if;
		end if;
	end process;

end Behavioral;

